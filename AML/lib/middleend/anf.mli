(** Copyright 2025-2026, Rodion Suvorov, Dmitriy Chirkov*)

(** SPDX-License-Identifier: LGPL-3.0-or-later *)

open Ast
open Ast.Expression
open Base

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
  | CFun of ident * aexpr

and aexpr =
  | ACE of cexpr
  | ALet of rec_flag * ident * cexpr * aexpr

type astructure_item =
  | AStr_value of rec_flag * ident * aexpr
  | AStr_eval of aexpr

type aprogram = astructure_item list
type anf_state =
  { temps : int
  ; arity_map : (ident, int, String.comparator_witness) Map.t
  }

val show_aprogram : aprogram -> string
val anf_transform : Ast.program -> (astructure_item list * (ident, int, String.comparator_witness) Map.t, string) Result.t
