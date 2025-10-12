(** Copyright 2025-2026, Rodion Suvorov, Dmitriy Chirkov*)

(** SPDX-License-Identifier: LGPL-3.0-or-later *)
open Ast.Expression

open Ast

type immexpr =
  | ImmNum of int
  | ImmId of ident

type binop =
  | Add
  | Sub
  | Mul
  | Le
  | Lt
  | Eq
  | Neq

type cexpr =
  | CImm of immexpr
  | CBinop of binop * immexpr * immexpr
  | CApp of immexpr * immexpr list
  | CIte of immexpr * aexpr * aexpr

and aexpr =
  | ACE of cexpr
  | ALet of rec_flag * ident * cexpr * aexpr

type anfState = { temps : int }

module ANFState = struct
  type 'a t = anfState -> 'a * anfState

  let return x st = x, st

  let bind : 'a t -> ('a -> 'b t) -> 'b t =
    fun t f st ->
    let a, tran_st = t st in
    let b, fin_st = f a tran_st in
    b, fin_st
  ;;

  let ( let* ) x f = bind x f
  let get st = st, st
  let put st _ = (), st
  let run m init_state = m init_state
end

open ANFState

let fresh_temp =
  let* st = get in
  let name = Printf.sprintf "t_%d" st.temps in
  let* () = put { temps = st.temps + 1 } in
  return name
;;

let rec app_args_to_list = function
  | Exp_apply (f, arg) ->
    let args, fn = app_args_to_list f in
    args @ [ arg ], fn
  | e -> [], e
;;

let is_binop op =
  List.mem op [ "+"; "-"; "*"; "/"; "<"; "<="; ">"; ">="; "="; "<>"; "||"; "&&" ]
;;

let define_binop = function
  | "+" -> Add
  | "-" -> Sub
  | "*" -> Mul
  | "<" -> Lt
  | "<=" -> Le
  | "=" -> Eq
  | "<>" -> Neq
  | s -> failwith ("unsupported binop: " ^ s)
;;

let rec transform_expr : Expression.t -> (immexpr -> aexpr ANFState.t) -> aexpr ANFState.t
  =
  fun expr k ->
  match expr with
  | Exp_constant (Constant.Const_integer exp) -> k @@ ImmNum exp
  | Exp_ident exp -> k @@ ImmId exp
  (* | Exp_apply (Exp_ident op, Exp_tuple (exp1, exp2, [])) when is_binop op -> failwith "todo" *)
  (* | Exp_apply (exp1, exp2) -> failwith "todo" *)
  | Exp_let (flag, ({ pat = Pattern.Pat_var pat; expr }, _), exp) ->
    transform_expr expr (fun a ->
      let* res = transform_expr exp k in
      return (ALet (flag, pat, CImm a, res)))
  | Exp_if (cond, then_expr, Some else_expr) ->
    transform_expr cond (fun cond_res ->
      let* then_res = transform_expr then_expr k in
      let* else_res = transform_expr else_expr k in
      return (ACE (CIte (cond_res, then_res, else_res))))
  (* | Exp_fun (exp1, exp2) -> failwith "todo" *)
  | _ -> failwith "other expression in future versions"
;;

(*
   let rec fac n = if n <= 1 then 1 else n * fac (n - 1)

let main =
  let () = print_int (fac 4) in
  0
;;

let x = a f in



let rec fib n = if n < 2 then n else fib (n - 1) + fib (n - 2)

let main =
  let () = print_int (fib 4) in
  0
;; *)
