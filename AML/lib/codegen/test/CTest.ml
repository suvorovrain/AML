(** Copyright 2025-2026, Rodion Suvorov, Dmitriy Chirkov*)

(** SPDX-License-Identifier: LGPL-3.0-or-later *)

open Parser
open Codegen
open Inferencer.Infer
open Middle.Anf

let run str =
  match parse_str str with
  | str ->
    (match run_infer_program str env_with_things with
     | Ok _ -> Format.printf "%a\n%!" codegen (anf_transform str)
     | Error _ -> Format.printf "Parsing error\n")
;;

let%expect_test "binary operations" =
  run
    {|
  let f =
    let x = 52 + 52 in
    let y = 52 - 52 in
    let z = 52 * 52 in
    let w = 52 <= 52 in
    x
  ;;
  |};
  [%expect
    {|
      .text
      .globl f
      .type f, @function
    f:
      addi sp, sp, -80
      sd ra, 72(sp)
      sd s0, 64(sp)
      addi s0, sp, 80
      li t0, 52
      li t1, 52
      add t0, t0, t1
      sd t0, -24(s0)
      ld t0, -24(s0)
      sd t0, -32(s0)
      li t0, 52
      li t1, 52
      sub t0, t0, t1
      sd t0, -40(s0)
      ld t0, -40(s0)
      sd t0, -48(s0)
      li t0, 52
      li t1, 52
      mul t0, t0, t1
      sd t0, -56(s0)
      ld t0, -56(s0)
      sd t0, -64(s0)
      li t0, 52
      li t1, 52
      slt t0, t1, t0
      xori t0, t0, 1
      sd t0, -72(s0)
      ld t0, -72(s0)
      sd t0, -80(s0)
      ld a0, -32(s0)
    f_end:
      ld ra, 72(sp)
      ld s0, 64(sp)
      addi sp, sp, 80
      ret |}]
;;

let%expect_test "some branches" =
  run
    {|
  let f =
    let x = 5 in
    let y = 2 in
    let z = 3 in
    let w = 4 in
    if x <= y then z else w
  ;;
  |};
  [%expect
    {|
      .text
      .globl f
      .type f, @function
    f:
      addi sp, sp, -56
      sd ra, 48(sp)
      sd s0, 40(sp)
      addi s0, sp, 56
      li t0, 5
      sd t0, -24(s0)
      li t0, 2
      sd t0, -32(s0)
      li t0, 3
      sd t0, -40(s0)
      li t0, 4
      sd t0, -48(s0)
      ld t0, -24(s0)
      ld t1, -32(s0)
      slt t0, t1, t0
      xori t0, t0, 1
      sd t0, -56(s0)
      ld t0, -56(s0)
      beq t0, x0, .Lelse_0
      ld a0, -40(s0)
      j .Lendif_1
    .Lelse_0:
      ld a0, -48(s0)
    .Lendif_1:
    f_end:
      ld ra, 48(sp)
      ld s0, 40(sp)
      addi sp, sp, 56
      ret |}]
;;


let%expect_test "many args" =
  run
    {|
  let f a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 =
    a0+a1+a2+a3+a4+a5+a6+a7+a8+a9+a10
  ;;
  |};
  [%expect
    {|
      .text
      .globl f
      .type f, @function
    f:
      addi sp, sp, -88
      sd ra, 80(sp)
      sd s0, 72(sp)
      addi s0, sp, 88
      addi t0, a0, 0
      addi t1, a1, 0
      add t0, t0, t1
      sd t0, -24(s0)
      ld t0, -24(s0)
      addi t1, a2, 0
      add t0, t0, t1
      sd t0, -32(s0)
      ld t0, -32(s0)
      addi t1, a3, 0
      add t0, t0, t1
      sd t0, -40(s0)
      ld t0, -40(s0)
      addi t1, a4, 0
      add t0, t0, t1
      sd t0, -48(s0)
      ld t0, -48(s0)
      addi t1, a5, 0
      add t0, t0, t1
      sd t0, -56(s0)
      ld t0, -56(s0)
      addi t1, a6, 0
      add t0, t0, t1
      sd t0, -64(s0)
      ld t0, -64(s0)
      addi t1, a7, 0
      add t0, t0, t1
      sd t0, -72(s0)
      ld t0, -72(s0)
      ld t1, 0(s0)
      add t0, t0, t1
      sd t0, -80(s0)
      ld t0, -80(s0)
      ld t1, 8(s0)
      add t0, t0, t1
      sd t0, -88(s0)
      ld t0, -88(s0)
      ld t1, 16(s0)
      add a0, t0, t1
    f_end:
      ld ra, 80(sp)
      ld s0, 72(sp)
      addi sp, sp, 88
      ret |}]
;;

