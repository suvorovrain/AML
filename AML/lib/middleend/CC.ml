(** Copyright 2025-2026, Rodion Suvorov, Dmitriy Chirkov*)

(** SPDX-License-Identifier: LGPL-3.0-or-later *)

open Base
open Anf_types
module S = Set
module M = Map

type cc_state =
  { temps : int
  ; bound : (string, String.comparator_witness) S.t
  ; subst : immexpr M.M(String).t
  }

module CCState = struct
  type 'a t = cc_state -> ('a, string) Result.t * cc_state

  let return x st = Ok x, st
  let error msg st = Error msg, st

  let bind : 'a t -> ('a -> 'b t) -> 'b t =
    fun t f st ->
    match t st with
    | Error msg, st' -> Error msg, st'
    | Ok a, tran_st -> f a tran_st
  ;;

  let ( let* ) = bind
  let get st = Ok st, st
  let put st _ = Ok (), st

  let rec map_m f = function
    | [] -> return []
    | x :: xs ->
      let* y = f x in
      let* ys = map_m f xs in
      return (y :: ys)
  ;;

  let run m st = m st
end

open CCState

let fresh_name (base : string) : string CCState.t =
  let* st = get in
  let id = st.temps in
  let* () = put { st with temps = id + 1 } in
  return (Printf.sprintf "%s_cc_%d" base id)
;;

let free_vars_imm : immexpr -> (string, String.comparator_witness) S.t = function
  | ImmNum _ -> S.empty (module String)
  | ImmId id -> S.singleton (module String) id
;;

let rec free_vars_cexpr : cexpr -> (string, String.comparator_witness) S.t = function
  | CImm imm -> free_vars_imm imm
  | CBinop (_, i1, i2) -> S.union (free_vars_imm i1) (free_vars_imm i2)
  | CApp (f, args) ->
    List.fold args ~init:(free_vars_imm f) ~f:(fun acc arg ->
      S.union acc (free_vars_imm arg))
  | CIte (i, thn, els) ->
    S.union (free_vars_imm i) (S.union (free_vars_aexpr thn) (free_vars_aexpr els))
  | CFun (arg, body) -> S.remove (free_vars_aexpr body) arg

and free_vars_aexpr : aexpr -> (string, String.comparator_witness) S.t = function
  | ACE cexpr -> free_vars_cexpr cexpr
  | ALet (Nonrecursive, name, rhs, body) ->
    let rhs_fvs = free_vars_cexpr rhs in
    let body_fvs = S.remove (free_vars_aexpr body) name in
    S.union rhs_fvs body_fvs
  | ALet (Recursive, name, rhs, body) ->
    let rhs_fvs = S.remove (free_vars_cexpr rhs) name in
    let body_fvs = S.remove (free_vars_aexpr body) name in
    S.union rhs_fvs body_fvs
;;

let with_new_scope
      (new_bound : (string, String.comparator_witness) S.t)
      (new_subst : immexpr M.M(String).t)
      (comp : 'a CCState.t)
  : 'a CCState.t
  =
  let* old_st = get in
  let* () = put { old_st with bound = new_bound; subst = new_subst } in
  let* result = comp in
  let* new_st = get in
  let* () = put { old_st with temps = new_st.temps } in
  return result
;;

let with_binding (name : string) (comp : 'a CCState.t) : 'a CCState.t =
  let* old_st = get in
  let new_bound = S.add old_st.bound name in
  with_new_scope new_bound old_st.subst comp
;;

let rec cc_aexpr (aexpr : aexpr) : aexpr CCState.t =
  match aexpr with
  | ACE cexpr -> cc_cexpr_to_aexpr cexpr
  | ALet (rec_flag, name, rhs, body) ->
    (match rhs with
     | CFun (arg, f_body) ->
       let* st = get in
       let fvs = free_vars_cexpr (CFun (arg, f_body)) in
       let fvs_without_self =
         match rec_flag with
         | Recursive -> S.remove fvs name
         | Nonrecursive -> fvs
       in
       let captured_list = S.to_list (S.inter fvs_without_self st.bound) in
       let* helper_name = fresh_name name in
       let inner_bound_vars =
         S.union
           (S.of_list (module String) (arg :: captured_list))
           (match rec_flag with
            | Recursive -> S.singleton (module String) helper_name
            | Nonrecursive -> S.empty (module String))
       in
       let new_f_body_bound = S.union inner_bound_vars st.bound in
       let new_subst =
         match rec_flag with
         | Recursive -> Map.set st.subst ~key:name ~data:(ImmId helper_name)
         | Nonrecursive -> st.subst
       in
       let* new_f_body = with_new_scope new_f_body_bound new_subst (cc_aexpr f_body) in
       let helper_fun_cexpr =
         match
           List.fold_right
             captured_list
             ~init:(ACE (CFun (arg, new_f_body)))
             ~f:(fun cap_var acc_aexpr -> ACE (CFun (cap_var, acc_aexpr)))
         with
         | ACE c -> c
         | _ -> assert false
       in
       let closure_cexpr =
         CApp (ImmId helper_name, List.map captured_list ~f:(fun id -> ImmId id))
       in
       let* new_let_body = with_binding name (cc_aexpr body) in
       return
         (ALet
            ( rec_flag
            , helper_name
            , helper_fun_cexpr
            , ALet (Nonrecursive, name, closure_cexpr, new_let_body) ))
     | _ ->
       let* new_rhs = cc_cexpr rhs in
       let* new_body = with_binding name (cc_aexpr body) in
       return (ALet (rec_flag, name, new_rhs, new_body)))

and cc_cexpr_to_aexpr (cexpr : cexpr) : aexpr CCState.t =
  match cexpr with
  | CFun (arg, body) ->
    let* st = get in
    let fvs = free_vars_cexpr (CFun (arg, body)) in
    let captured_list = S.to_list (S.inter fvs st.bound) in
    let* helper_name = fresh_name "f" in
    let* closure_name = fresh_name "closure" in
    let new_body_bound =
      S.union st.bound (S.of_list (module String) (arg :: captured_list))
    in
    let* new_body = with_new_scope new_body_bound st.subst (cc_aexpr body) in
    let helper_fun_cexpr =
      match
        List.fold_right
          captured_list
          ~init:(ACE (CFun (arg, new_body)))
          ~f:(fun cap_var acc_aexpr -> ACE (CFun (cap_var, acc_aexpr)))
      with
      | ACE c -> c
      | _ -> assert false
    in
    let closure_cexpr =
      CApp (ImmId helper_name, List.map captured_list ~f:(fun id -> ImmId id))
    in
    return
      (ALet
         ( Nonrecursive
         , helper_name
         , helper_fun_cexpr
         , ALet
             (Nonrecursive, closure_name, closure_cexpr, ACE (CImm (ImmId closure_name)))
         ))
  | CApp (ImmId id, args) ->
    let* st = get in
    (match Map.find st.subst id with
     | Some (ImmId _helper_name) ->
       let f' =
         match Map.find st.subst id with
         | Some f_sub -> f_sub
         | None -> ImmId id
       in
       return (ACE (CApp (f', args)))
     | Some (ImmNum _) -> assert false
     | None -> return (ACE (CApp (ImmId id, args))))
  | CApp (f, args) -> return (ACE (CApp (f, args)))
  | CImm imm -> return (ACE (CImm imm))
  | CBinop (op, i1, i2) -> return (ACE (CBinop (op, i1, i2)))
  | CIte (i, thn, els) ->
    let* thn_aexpr = cc_aexpr thn in
    let* els_aexpr = cc_aexpr els in
    return (ACE (CIte (i, thn_aexpr, els_aexpr)))

and cc_cexpr (cexpr : cexpr) : cexpr CCState.t =
  match cexpr with
  | CApp (ImmId id, args) ->
    let* st = get in
    let f' =
      match Map.find st.subst id with
      | Some f_sub -> f_sub
      | None -> ImmId id
    in
    return (CApp (f', args))
  | CApp (f, args) -> return (CApp (f, args))
  | CImm imm -> return (CImm imm)
  | CBinop (op, i1, i2) -> return (CBinop (op, i1, i2))
  | CIte (i, thn, els) ->
    let* thn_aexpr = cc_aexpr thn in
    let* els_aexpr = cc_aexpr els in
    return (CIte (i, thn_aexpr, els_aexpr))
  | CFun (_, _) -> error "unreachable: cc_cexpr should not encounter CFun"
;;

let cc_str_item (item : astructure_item) : astructure_item list CCState.t =
  match item with
  | AStr_eval aexpr ->
    let* new_aexpr = cc_aexpr aexpr in
    return [ AStr_eval new_aexpr ]
  | AStr_value (rec_flag, name, (ACE (CFun (arg, f_body)) as func_aexpr)) ->
    let* st_before = get in
    let fvs = free_vars_aexpr func_aexpr in
    let fvs_without_self =
      match rec_flag with
      | Recursive -> S.remove fvs name
      | Nonrecursive -> fvs
    in
    let captured_list = S.to_list (S.inter fvs_without_self st_before.bound) in
    let* helper_name = fresh_name name in
    let inner_bound_vars =
      S.union
        (S.of_list (module String) (arg :: captured_list))
        (match rec_flag with
         | Recursive -> S.singleton (module String) helper_name
         | Nonrecursive -> S.empty (module String))
    in
    let new_f_body_bound = S.union inner_bound_vars st_before.bound in
    let new_subst_for_body =
      match rec_flag with
      | Recursive -> Map.set st_before.subst ~key:name ~data:(ImmId helper_name)
      | Nonrecursive -> st_before.subst
    in
    let* new_f_body =
      with_new_scope new_f_body_bound new_subst_for_body (cc_aexpr f_body)
    in
    let helper_fun_aexpr =
      match
        List.fold_right
          captured_list
          ~init:(ACE (CFun (arg, new_f_body)))
          ~f:(fun cap_var acc_aexpr -> ACE (CFun (cap_var, acc_aexpr)))
      with
      | ACE c -> ACE c
      | _ -> assert false
    in
    let closure_cexpr =
      CApp (ImmId helper_name, List.map captured_list ~f:(fun id -> ImmId id))
    in
    let helper_item = AStr_value (rec_flag, helper_name, helper_fun_aexpr) in
    let closure_item = AStr_value (Nonrecursive, name, ACE closure_cexpr) in
    let* st_after = get in
    let new_top_level_bound = S.add (S.add st_before.bound name) helper_name in
    let* () =
      put { temps = st_after.temps; bound = new_top_level_bound; subst = st_before.subst }
    in
    return [ helper_item; closure_item ]
  | AStr_value (rec_flag, name, aexpr) ->
    let* st_before = get in
    let new_bound_for_body =
      match rec_flag with
      | Recursive -> S.add st_before.bound name
      | Nonrecursive -> st_before.bound
    in
    let* new_aexpr = with_new_scope new_bound_for_body st_before.subst (cc_aexpr aexpr) in
    let* st_after = get in
    let new_top_level_bound = S.add st_before.bound name in
    let* () =
      put { temps = st_after.temps; bound = new_top_level_bound; subst = st_before.subst }
    in
    return [ AStr_value (rec_flag, name, new_aexpr) ]
;;

let cc_program (prog : aprogram) : aprogram CCState.t =
  let* lists_of_items = map_m cc_str_item prog in
  return (List.concat lists_of_items)
;;

let cc_transform (prog : aprogram) : (aprogram, string) Result.t =
  let initial_state =
    { temps = 0; bound = S.empty (module String); subst = M.empty (module String) }
  in
  match CCState.run (cc_program prog) initial_state with
  | Ok final_prog, _final_state -> Ok final_prog
  | Error msg, _final_state -> Error msg
;;
