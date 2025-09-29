(** Copyright 2024, Rodion Suvorov, Dmitriy Chirkov*)

(** SPDX-License-Identifier: LGPL-3.0-or-later *)

open Ast

val parse : string -> (Structure.structure_item list, string) result
val parse_str : string -> Structure.structure_item list
