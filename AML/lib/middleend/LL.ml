(** Copyright 2025-2026, Rodion Suvorov, Dmitriy Chirkov*)

(** SPDX-License-Identifier: LGPL-3.0-or-later *)
open Base

open Anf_types

type ll_state =
  { temps : int
  ; lifted : astructure_item list
  }

module LLState = struct
  type 'a t = ll_state -> ('a, string) Result.t * ll_state

  let return x st = Ok x, st

  let bind m f st =
    match m st with
    | Error e, st' -> Error e, st'
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

  let run m = m { temps = 0; lifted = [] }
end

open LLState

let fresh_lam_name =
  let* st = get in
  let name = Printf.sprintf "llf_%d" st.temps in
  let* () = put { st with temps = st.temps + 1 } in
  return name
;;

let rec collect_cfun acc = function
  | ACE (CFun (p, body')) -> collect_cfun (p :: acc) body'
  | body -> List.rev acc, body
;;

let rec build_curried params body =
  match params with
  | [] -> body
  | p :: ps -> ACE (CFun (p, build_curried ps body))
;;

let rec ll_cexpr = function
  | CImm i -> return (CImm i)
  | CBinop (op, a, b) -> return (CBinop (op, a, b))
  | CApp (f, args) ->
    let* args' = map_m (fun x -> return x) args in
    let* f' = return f in
    return (CApp (f', args'))
  | CIte (c, th, el) ->
    let* th' = ll_aexpr th in
    let* el' = ll_aexpr el in
    return (CIte (c, th', el'))
  | CFun (p, body0) ->
    let params, core = collect_cfun [ p ] body0 in
    let* core' = ll_aexpr core in
    let* name = fresh_lam_name in
    let lifted = build_curried params core' in
    let* st = get in
    let* () =
      put { st with lifted = st.lifted @ [ AStr_value (Nonrecursive, name, lifted) ] }
    in
    return (CImm (ImmId name))

and ll_aexpr = function
  | ALet (Nonrecursive, x, CImm (ImmId y), ACE (CImm (ImmId x'))) when String.equal x x'
    -> return (ACE (CImm (ImmId y)))
  | ALet (Nonrecursive, x, CImm (ImmId f), ACE (CApp (ImmId callee, args)))
    when String.equal x callee -> return (ACE (CApp (ImmId f, args)))
  | ACE c ->
    let* c' = ll_cexpr c in
    return (ACE c')
  | ALet (rf, name, rhs, body) ->
    let* rhs' = ll_cexpr rhs in
    let* body' = ll_aexpr body in
    return (ALet (rf, name, rhs', body'))
;;

let ll_program (prog : aprogram) : aprogram LLState.t =
  let* items =
    map_m
      (function
        | AStr_value (rf, name, a) ->
          let* a' = ll_aexpr a in
          return (AStr_value (rf, name, a'))
        | AStr_eval a ->
          let* a' = ll_aexpr a in
          return (AStr_eval a'))
      prog
  in
  let* st = get in
  return (st.lifted @ items)
;;

let ll_transform (p : aprogram) : (aprogram, string) Result.t =
  match LLState.run (ll_program p) with
  | Ok out, _ -> Ok out
  | Error e, _ -> Error e
;;
