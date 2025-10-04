(** Copyright 2025-2026, Rodion Suvorov, Dmitriy Chirkov*)

(** SPDX-License-Identifier: LGPL-3.0-or-later *)

open Codegen

let s = {|
let rec fac n =
  if n <= 1
  then 1
  else let n1 = n-1 in
       let m = fac n1 in
       n*m

let main = fac 4
|}

let () = print_endline (Ast.show_program (Inferencer.Parser.parse_str s))

let () = codegen_structure Format.std_formatter (Inferencer.Parser.parse_str s)

