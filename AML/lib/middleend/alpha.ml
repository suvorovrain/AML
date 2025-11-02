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
  | ACE c ->
    let* c' = convert_cexpr env c in
    return (ACE c')
  | ALet (flag, name, c, body) ->
    let* c' = convert_cexpr env c in
    let* fresh_name = fresh name in
    let env' = Map.set env ~key:name ~data:fresh_name in
    let* body' = convert_aexpr env' body in
    return (ALet (flag, fresh_name, c', body'))

and convert_cexpr env = function
  | CImm imm ->
    let* imm' = convert_imm env imm in
    return (CImm imm')
  | CBinop (op, a, b) ->
    let* a' = convert_imm env a in
    let* b' = convert_imm env b in
    return (CBinop (op, a', b'))
  | CApp (fn, args) ->
    let* fn' = convert_imm env fn in
    let* args' =
      let rec loop acc = function
        | [] -> return (List.rev acc)
        | x :: xs ->
          let* x' = convert_imm env x in
          loop (x' :: acc) xs
      in
      loop [] args
    in
    return (CApp (fn', args'))
  | CIte (cond, t, e) ->
    let* cond' = convert_imm env cond in
    let* t' = convert_aexpr env t in
    let* e' = convert_aexpr env e in
    return (CIte (cond', t', e'))
  | CFun (param, body) ->
    let* fresh_name = fresh param in
    let env' = Map.set env ~key:param ~data:fresh_name in
    let* body' = convert_aexpr env' body in
    return (CFun (fresh_name, body'))
;;

let convert_item env = function
  | AStr_value (flag, name, body) ->
    let* fresh_name = fresh name in
    let env' = Map.set env ~key:name ~data:fresh_name in
    let* body' = convert_aexpr env' body in
    return (AStr_value (flag, fresh_name, body'), env')
  | AStr_eval e ->
    let* e' = convert_aexpr env e in
    return (AStr_eval e', env)
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
