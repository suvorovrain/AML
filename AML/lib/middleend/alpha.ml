(** Copyright 2025-2026, Rodion Suvorov, Dmitriy Chirkov*)

(** SPDX-License-Identifier: LGPL-3.0-or-later *)

open Base
open Anf_types
open Ast

type alpha_state =
  { counter : int
  ; env : (ident, ident, String.comparator_witness) Map.t
  }

module M = struct
  type 'a t = alpha_state -> 'a * alpha_state

  let return x st = x, st

  let bind m f st =
    let x, st' = m st in
    f x st'
  ;;

  let ( let* ) = bind
  let get st = st, st
  let put st _ = (), st
end

open M

let fresh base =
  let* st = get in
  let name = Printf.sprintf "%s__%d" base st.counter in
  let new_st = { st with counter = st.counter + 1 } in
  let* () = put new_st in
  return name
;;

let lookup env x = Map.find env x |> Option.value ~default:x

let convert_imm env = function
  | ImmNum n -> return (ImmNum n)
  | ImmId x -> return (ImmId (lookup env x))
;;

let rec convert_aexpr env = function
  | ACE exp ->
    let* exp_res = convert_cexpr env exp in
    return (ACE exp_res )
  | ALet (flag, name, exp, body) ->
    let* exp_res = convert_cexpr env exp in
    let* fresh_name = fresh name in
    let env' = Map.set env ~key:name ~data:fresh_name in
    let* body' = convert_aexpr env' body in
    return (ALet (flag, fresh_name, exp_res, body'))

and convert_cexpr env = function
  | CImm imm ->
    let* imm_res = convert_imm env imm in
    return (CImm imm_res)
  | CBinop (op, exp1, exp2) ->
    let* exp1_res = convert_imm env exp1 in
    let* exp2_res = convert_imm env exp2 in
    return (CBinop (op, exp1_res, exp2_res))
  | CApp (fn, args) ->
    let* fn_res = convert_imm env fn in
    let* args' =
      let rec loop acc = function
        | [] -> return (List.rev acc)
        | x :: xs ->
          let* x' = convert_imm env x in
          loop (x' :: acc) xs
      in
      loop [] args
    in
    return (CApp (fn_res, args'))
  | CIte (cond, thenb, elseb) ->
    let* cond_res = convert_imm env cond in
    let* thenb_res = convert_aexpr env thenb in
    let* elseb_res = convert_aexpr env elseb in
    return (CIte (cond_res, thenb_res, elseb_res))
  | CFun (param, body) ->
    let* fresh_name = fresh param in
    let new_env = Map.set env ~key:param ~data:fresh_name in
    let* body_res = convert_aexpr new_env body in
    return (CFun (fresh_name, body_res))
;;

let convert_item env = function
  | AStr_value (flag, name, body) ->
    let* fresh_name = fresh name in
    let new_env = Map.set env ~key:name ~data:fresh_name in
    let* body_res = convert_aexpr new_env body in
    return (AStr_value (flag, fresh_name, body_res), new_env)
  | AStr_eval exp->
    let* exp_res = convert_aexpr env exp in
    return (AStr_eval exp_res, env)
;;

let rec convert_program_aux env = function
  | [] -> return []
  | x :: xs ->
    let* x', env' = convert_item env x in
    let* xs' = convert_program_aux env' xs in
    return (x' :: xs')
;;

let convert_program (prog : aprogram) : aprogram =
  let initial_env = Map.empty (module String) in
  let initial_state = { counter = 0; env = initial_env } in
  let res, _ = convert_program_aux initial_env prog initial_state in
  res
;;
