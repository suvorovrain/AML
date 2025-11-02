open Base
open Anf_types

type ll_state =
  { temps : int
  ; lifted : astructure_item list
  }

module LLState = struct
  type 'a t = ll_state -> ('a, string) Result.t * ll_state

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

  let rec fold_right_m f xs acc =
    match xs with
    | [] -> return acc
    | x :: xs' ->
      let* acc' = fold_right_m f xs' acc in
      f x acc'
  ;;

  let run m = m { temps = 0; lifted = [] }
end

open LLState
module S = Set

let fresh_temp =
  let* st = get in
  let name = Printf.sprintf "t_%d" st.temps in
  let* () = put { temps = st.temps + 1; lifted = st.lifted } in
  return name
;;

let is_binop op = Stdlib.List.mem op [ Add; Sub; Mul; Le; Lt; Eq; Neq ]
let ll_immexpr x = return x

let fv_imm = function
  | ImmNum _ -> S.empty (module String)
  | ImmId x -> S.singleton (module String) x
;;

let rec fv_cexpr = function
  | CImm i -> fv_imm i
  | CBinop (_, a, b) -> S.union (fv_imm a) (fv_imm b)
  | CApp (f, args) ->
    List.fold args ~init:(fv_imm f) ~f:(fun acc i -> S.union acc (fv_imm i))
  | CIte (i, th, el) -> S.union (fv_imm i) (S.union (fv_aexpr th) (fv_aexpr el))
  | CFun (x, body) -> S.remove (fv_aexpr body) x

and fv_aexpr = function
  | ACE c -> fv_cexpr c
  | ALet (Nonrecursive, x, rhs, body) ->
    S.union (fv_cexpr rhs) (S.remove (fv_aexpr body) x)
  | ALet (Recursive, x, rhs, body) ->
    let rhs_fv = S.remove (fv_cexpr rhs) x in
    let body_fv = S.remove (fv_aexpr body) x in
    S.union rhs_fv body_fv
;;

let rec collect_cfun (params : string list) (body : aexpr) : string list * aexpr =
  match body with
  | ACE (CFun (p, body')) -> collect_cfun (p :: params) body'
  | other -> List.rev params, other
;;

let rec build_curried (params : string list) (body : aexpr) : aexpr =
  match params with
  | [] -> body
  | p :: ps -> ACE (CFun (p, build_curried ps body))
;;

let rec ll_cexpr = function
  | CImm exp ->
    let* exp' = ll_immexpr exp in
    return (CImm exp')
  | CBinop (op, exp1, exp2) when is_binop op ->
    let* exp1_res = ll_immexpr exp1 in
    let* exp2_res = ll_immexpr exp2 in
    return (CBinop (op, exp1_res, exp2_res))
  | CApp (fn, args) ->
    let* fn_res = ll_immexpr fn in
    let* args_res = map_m ll_immexpr args in
    return (CApp (fn_res, args_res))
  | CIte (cond, thenb, elseb) ->
    let* lcond = ll_immexpr cond in
    let* lthenb = ll_aexpr thenb in
    let* lelseb = ll_aexpr elseb in
    return (CIte (lcond, lthenb, lelseb))
  | CFun (p, body0) ->
    let params, core_body = collect_cfun [ p ] body0 in
    let fun_aexpr = build_curried params core_body in
    let fv = fv_aexpr fun_aexpr in
    if S.is_empty fv
    then
      let* fresh_fun = fresh_temp in
      let* lifted_core = ll_aexpr core_body in
      let lifted_def =
        AStr_value (Nonrecursive, fresh_fun, build_curried params lifted_core)
      in
      let* st = get in
      let* () = put { st with lifted = st.lifted @ [ lifted_def ] } in
      return (CImm (ImmId fresh_fun))
    else
      let* body' = ll_aexpr body0 in
      return (CFun (p, body'))
  | _ -> error "todo"

and ll_aexpr = function
  | ACE cexpr ->
    let* cexpr_res = ll_cexpr cexpr in
    return (ACE cexpr_res)
  | ALet (flag, id, cexpr, body) ->
    let* cexpr_res = ll_cexpr cexpr in
    let* body_res = ll_aexpr body in
    return (ALet (flag, id, cexpr_res, body_res))
;;

let ll_program (prog : aprogram) : aprogram LLState.t =
  let* items =
    map_m
      (function
        | AStr_value (flag, id, aexpr) ->
          let* aexpr_res = ll_aexpr aexpr in
          return (AStr_value (flag, id, aexpr_res))
        | AStr_eval aexpr ->
          let* aexpr_res = ll_aexpr aexpr in
          return (AStr_eval aexpr_res))
      prog
  in
  return items
;;

let ll_transform (p : aprogram) : (aprogram, string) Result.t =
  match LLState.run (ll_program p) with
  | Ok transformed_prog, { lifted; _ } -> Ok (lifted @ transformed_prog)
  | Error msg, _ -> Error msg
;;
