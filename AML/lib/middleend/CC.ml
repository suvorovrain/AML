(** Copyright 2025-2026, Rodion Suvorov, Dmitriy Chirkov*)

(** SPDX-License-Identifier: LGPL-3.0-or-later *)

open Anf_types
module SS = Set.Make (String)
module SM = Map.Make (String)

(* ---------------- State/monad ---------------- *)

type cc_state =
  { temps : int
  ; bound : SS.t
  ; subst : immexpr SM.t
  }

module CCState = struct
  type 'a t = cc_state -> ('a, string) result * cc_state

  let return x st = Ok x, st
  let error msg st = Error msg, st

  let bind (m : 'a t) (f : 'a -> 'b t) : 'b t =
    fun st ->
    match m st with
    | Error msg, st' -> Error msg, st'
    | Ok a, st' -> f a st'
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

let free_vars_imm = function
  | ImmNum _ -> SS.empty
  | ImmId id -> SS.singleton id
;;

let rec free_vars_cexpr = function
  | CImm imm -> free_vars_imm imm
  | CBinop (_, i1, i2) -> SS.union (free_vars_imm i1) (free_vars_imm i2)
  | CApp (f, args) ->
    List.fold_left (fun acc a -> SS.union acc (free_vars_imm a)) (free_vars_imm f) args
  | CIte (i, thn, els) ->
    SS.union (free_vars_imm i) (SS.union (free_vars_aexpr thn) (free_vars_aexpr els))
  | CFun (arg, body) -> SS.remove arg (free_vars_aexpr body)

and free_vars_aexpr = function
  | ACE cexpr -> free_vars_cexpr cexpr
  | ALet (Nonrecursive, name, rhs, body) ->
    let rhs_fvs = free_vars_cexpr rhs in
    let body_fvs = SS.remove name (free_vars_aexpr body) in
    SS.union rhs_fvs body_fvs
  | ALet (Recursive, name, rhs, body) ->
    let rhs_fvs = SS.remove name (free_vars_cexpr rhs) in
    let body_fvs = SS.remove name (free_vars_aexpr body) in
    SS.union rhs_fvs body_fvs
;;

let with_new_scope (new_bound : SS.t) (new_subst : immexpr SM.t) (comp : 'a CCState.t) =
  let* old_st = get in
  let* () = put { old_st with bound = new_bound; subst = new_subst } in
  let* res = comp in
  let* new_st = get in
  (* вернуть temps, чтобы счётчик не терялся *)
  let* () = put { old_st with temps = new_st.temps } in
  return res
;;

let with_binding (name : string) (comp : 'a CCState.t) =
  let* st = get in
  let new_bound = SS.add name st.bound in
  with_new_scope new_bound st.subst comp
;;

let rec mk_fun (params : string list) (body : aexpr) : aexpr =
  match params with
  | [] -> body
  | p :: ps -> ACE (CFun (p, mk_fun ps body))
;;

let rec cc_aexpr = function
  | ACE cexpr -> cc_cexpr_to_aexpr cexpr
  | ALet (rec_flag, name, rhs, body) ->
    (match rhs with
     | CFun (arg, f_body) ->
       let* st = get in
       let fvs = free_vars_cexpr (CFun (arg, f_body)) in
       let captured = SS.elements (SS.inter fvs st.bound) in
       if captured = []
       then (
         let inner_bound =
           match rec_flag with
           | Recursive -> SS.add arg (SS.add name st.bound)
           | Nonrecursive -> SS.add arg st.bound
         in
         let* new_body = with_new_scope inner_bound st.subst (cc_aexpr f_body) in
         let* new_body' = with_binding name (cc_aexpr body) in
         return (ALet (rec_flag, name, CFun (arg, new_body), new_body')))
       else
         let* helper = fresh_name name in
         let helper_params =
           match rec_flag with
           | Recursive -> name :: (captured @ [ arg ])
           | Nonrecursive -> captured @ [ arg ]
         in
         let inner_bound =
           List.fold_left (fun acc p -> SS.add p acc) st.bound helper_params
         in
         let* new_body = with_new_scope inner_bound st.subst (cc_aexpr f_body) in
         let helper_fun = mk_fun helper_params new_body in
         let helper_cexpr =
           match helper_fun with
           | ACE c -> c
           | _ -> assert false
         in
         let clos_args =
           match rec_flag with
           | Recursive -> ImmId name :: List.map (fun x -> ImmId x) captured
           | Nonrecursive -> List.map (fun x -> ImmId x) captured
         in
         let closure = CApp (ImmId helper, clos_args) in
         let* new_body' = with_binding name (cc_aexpr body) in
         return
           (ALet
              ( Nonrecursive
              , helper
              , helper_cexpr
              , ALet (rec_flag, name, closure, new_body') ))
     | _ ->
       let* rhs' = cc_cexpr rhs in
       let* body' = with_binding name (cc_aexpr body) in
       return (ALet (rec_flag, name, rhs', body')))

and cc_cexpr_to_aexpr = function
  | CFun (arg, body) ->
    let* st = get in
    let fvs = free_vars_cexpr (CFun (arg, body)) in
    let captured = SS.elements (SS.inter fvs st.bound) in
    if captured = []
    then (
      let inner = SS.add arg st.bound in
      let* body' = with_new_scope inner st.subst (cc_aexpr body) in
      return (ACE (CFun (arg, body'))))
    else
      let* helper = fresh_name "f" in
      let inner =
        List.fold_left (fun acc p -> SS.add p acc) st.bound (captured @ [ arg ])
      in
      let* body' = with_new_scope inner st.subst (cc_aexpr body) in
      let helper_fun = mk_fun (captured @ [ arg ]) body' in
      let helper_cexpr =
        match helper_fun with
        | ACE c -> c
        | _ -> assert false
      in
      let closure = CApp (ImmId helper, List.map (fun x -> ImmId x) captured) in
      return (ALet (Nonrecursive, helper, helper_cexpr, ACE closure))
  | CApp (ImmId id, args) ->
    let* st = get in
    let f' =
      match SM.find_opt id st.subst with
      | Some v -> v
      | None -> ImmId id
    in
    return (ACE (CApp (f', args)))
  | CApp (f, args) -> return (ACE (CApp (f, args)))
  | CImm imm -> return (ACE (CImm imm))
  | CBinop (op, i1, i2) -> return (ACE (CBinop (op, i1, i2)))
  | CIte (i, thn, els) ->
    let* thn' = cc_aexpr thn in
    let* els' = cc_aexpr els in
    return (ACE (CIte (i, thn', els')))

and cc_cexpr = function
  | CApp (ImmId id, args) ->
    let* st = get in
    let f' =
      match SM.find_opt id st.subst with
      | Some v -> v
      | None -> ImmId id
    in
    return (CApp (f', args))
  | CApp (f, args) -> return (CApp (f, args))
  | CImm imm -> return (CImm imm)
  | CBinop (op, i1, i2) -> return (CBinop (op, i1, i2))
  | CIte (i, thn, els) ->
    let* thn' = cc_aexpr thn in
    let* els' = cc_aexpr els in
    return (CIte (i, thn', els'))
  | CFun _ -> error "unreachable: cc_cexpr should not encounter CFun"
;;

let cc_str_item = function
  | AStr_eval aexpr ->
    let* a' = cc_aexpr aexpr in
    return [ AStr_eval a' ]
  | AStr_value (rec_flag, name, (ACE (CFun (arg, f_body)) as func)) ->
    let* st = get in
    let fvs = free_vars_aexpr func in
    let captured = SS.elements (SS.inter fvs st.bound) in
    if captured = []
    then (
      let inner =
        match rec_flag with
        | Recursive -> SS.add arg (SS.add name st.bound)
        | Nonrecursive -> SS.add arg st.bound
      in
      let* body' = with_new_scope inner st.subst (cc_aexpr f_body) in
      let* st' = get in
      let new_top = SS.add name st.bound in
      let* () = put { temps = st'.temps; bound = new_top; subst = st.subst } in
      return [ AStr_value (rec_flag, name, ACE (CFun (arg, body'))) ])
    else
      let* helper = fresh_name name in
      let helper_params =
        match rec_flag with
        | Recursive -> name :: (captured @ [ arg ])
        | Nonrecursive -> captured @ [ arg ]
      in
      let inner = List.fold_left (fun acc p -> SS.add p acc) st.bound helper_params in
      let* body' = with_new_scope inner st.subst (cc_aexpr f_body) in
      let helper_fun = mk_fun helper_params body' in
      let helper_item =
        match helper_fun with
        | ACE c -> AStr_value (Nonrecursive, helper, ACE c)
        | _ -> assert false
      in
      let closure_item =
        match rec_flag with
        | Nonrecursive ->
          let clos = CApp (ImmId helper, List.map (fun x -> ImmId x) captured) in
          AStr_value (Nonrecursive, name, ACE clos)
        | Recursive ->
          let clos_args = ImmId name :: List.map (fun x -> ImmId x) captured in
          let wrapper =
            ACE (CFun (arg, ACE (CApp (ImmId helper, clos_args @ [ ImmId arg ]))))
          in
          AStr_value (Recursive, name, wrapper)
      in
      let* st' = get in
      let new_top = SS.add helper (SS.add name st.bound) in
      let* () = put { temps = st'.temps; bound = new_top; subst = st.subst } in
      return [ helper_item; closure_item ]
  | AStr_value (rec_flag, name, aexpr) ->
    let* st = get in
    let inner =
      match rec_flag with
      | Recursive -> SS.add name st.bound
      | Nonrecursive -> st.bound
    in
    let* a' = with_new_scope inner st.subst (cc_aexpr aexpr) in
    let* st' = get in
    let new_top = SS.add name st.bound in
    let* () = put { temps = st'.temps; bound = new_top; subst = st.subst } in
    return [ AStr_value (rec_flag, name, a') ]
;;

let cc_program (prog : aprogram) : aprogram CCState.t =
  let* lists = CCState.map_m cc_str_item prog in
  return (List.concat lists)
;;

let cc_transform (prog : aprogram) : (aprogram, string) result =
  let initial = { temps = 0; bound = SS.empty; subst = SM.empty } in
  match CCState.run (cc_program prog) initial with
  | Ok p, _ -> Ok p
  | Error e, _ -> Error e
;;
