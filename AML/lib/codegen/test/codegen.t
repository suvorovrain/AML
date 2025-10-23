(** Copyright 2025-2026, Rodion Suvorov, Dmitriy Chirkov*)

(** SPDX-License-Identifier: LGPL-3.0-or-later *)
  $ cat >fac.ml <<EOF
  > let rec fac n =
  >   if n <= 1
  >   then 1
  >   else (let n1 = n-1 in
  >      let m = fac n1 in
  >      n*m)
  > 
  > let main = print_int (fac 4)
  > EOF
  $ ../../../bin/AML.exe fac.ml fac.s
  Generated: fac.s
  $ cat fac.s
    .text
    .globl fac
    .type fac, @function
  fac:
    addi sp, sp, -56
    sd ra, 48(sp)
    sd s0, 40(sp)
    addi s0, sp, 56
    addi t0, a0, 0
    li t1, 1
    slt t0, t1, t0
    xori t0, t0, 1
    sd t0, -24(s0)
    ld t0, -24(s0)
    beq t0, x0, .Lelse_0
    li a0, 1
    j .Lendif_1
  .Lelse_0:
    addi t0, a0, 0
    li t1, 1
    sub t0, t0, t1
    sd t0, -32(s0)
    ld t0, -32(s0)
    sd t0, -40(s0)
    addi sp, sp, -8
    sd a0, 0(sp)
    ld a0, -40(s0)
    call fac
    addi t0, a0, 0
    ld a0, 0(sp)
    addi sp, sp, 8
    sd t0, -48(s0)
    ld t0, -48(s0)
    sd t0, -56(s0)
    addi t0, a0, 0
    ld t1, -56(s0)
    mul a0, t0, t1
  .Lendif_1:
  fac_end:
    ld ra, 48(sp)
    ld s0, 40(sp)
    addi sp, sp, 56
    ret
    
    .globl main
    .type main, @function
  main:
    addi sp, sp, -24
    sd ra, 16(sp)
    sd s0, 8(sp)
    addi s0, sp, 24
    li a0, 4
    call fac
    addi t0, a0, 0
    sd t0, -24(s0)
    ld a0, -24(s0)
    call print_int
  main_end:
    ld ra, 16(sp)
    ld s0, 8(sp)
    addi sp, sp, 24
    li a0, 0
    li a7, 93
    ecall
  $ riscv64-linux-gnu-as -march=rv64gc fac.s -o fac.o
  $ riscv64-linux-gnu-gcc -static fac.o -L../../../runtime -l:libruntime.a -o fac.elf -Wl,--no-warnings
  $ qemu-riscv64 ./fac.elf
  24

  $ cat >fib.ml <<EOF
  > let rec fib n = if n < 2 then n else fib (n - 1) + fib (n - 2)
  > let main = let () = print_int (fib 4) in 0
  > EOF
  $ ../../../bin/AML.exe fib.ml fib.s
  Generated: fib.s
  $ cat fib.s
    .text
    .globl fib
    .type fib, @function
  fib:
    addi sp, sp, -56
    sd ra, 48(sp)
    sd s0, 40(sp)
    addi s0, sp, 56
    addi t0, a0, 0
    li t1, 2
    slt t0, t0, t1
    sd t0, -24(s0)
    ld t0, -24(s0)
    beq t0, x0, .Lelse_0
    addi a0, a0, 0
    j .Lendif_1
  .Lelse_0:
    addi t0, a0, 0
    li t1, 1
    sub t0, t0, t1
    sd t0, -32(s0)
    addi sp, sp, -8
    sd a0, 0(sp)
    ld a0, -32(s0)
    call fib
    addi t0, a0, 0
    ld a0, 0(sp)
    addi sp, sp, 8
    sd t0, -40(s0)
    addi t0, a0, 0
    li t1, 2
    sub t0, t0, t1
    sd t0, -48(s0)
    addi sp, sp, -8
    sd a0, 0(sp)
    ld a0, -48(s0)
    call fib
    addi t0, a0, 0
    ld a0, 0(sp)
    addi sp, sp, 8
    sd t0, -56(s0)
    ld t0, -40(s0)
    ld t1, -56(s0)
    add a0, t0, t1
  .Lendif_1:
  fib_end:
    ld ra, 48(sp)
    ld s0, 40(sp)
    addi sp, sp, 56
    ret
    
    .globl main
    .type main, @function
  main:
    addi sp, sp, -40
    sd ra, 32(sp)
    sd s0, 24(sp)
    addi s0, sp, 40
    li a0, 4
    call fib
    addi t0, a0, 0
    sd t0, -24(s0)
    ld a0, -24(s0)
    call print_int
    addi t0, a0, 0
    sd t0, -32(s0)
    ld t0, -32(s0)
    sd t0, -40(s0)
    li a0, 0
  main_end:
    ld ra, 32(sp)
    ld s0, 24(sp)
    addi sp, sp, 40
    li a0, 0
    li a7, 93
    ecall
  $ riscv64-linux-gnu-as -march=rv64gc fib.s -o fib.o
  $ riscv64-linux-gnu-gcc -static fib.o -L../../../runtime -l:libruntime.a -o fib.elf -Wl,--no-warnings
  $ qemu-riscv64 ./fib.elf
  3

  $ cat >ite.ml <<EOF
  > let large x = if 0<>x then print_int 0 else print_int 1
  >   let main =
  >      let x = if (if (if 0=1
  >                      then 0 else (let t42 = print_int 42 in 1))=1
  >                  then 0 else 1)=1
  >              then 0 else 1 in
  >      large x
  > EOF
  $ ../../../bin/AML.exe ite.ml ite.s
  Generated: ite.s
  $ cat ite.s
    .text
    .globl large
    .type large, @function
  large:
    addi sp, sp, -24
    sd ra, 16(sp)
    sd s0, 8(sp)
    addi s0, sp, 24
    li t0, 0
    addi t1, a0, 0
    sub t2, t0, t1
    slt t0, x0, t2
    slt t3, t2, x0
    add t0, t0, t3
    sd t0, -24(s0)
    ld t0, -24(s0)
    beq t0, x0, .Lelse_0
    addi sp, sp, -8
    sd a0, 0(sp)
    li a0, 0
    call print_int
    ld a0, 0(sp)
    addi sp, sp, 8
    j .Lendif_1
  .Lelse_0:
    addi sp, sp, -8
    sd a0, 0(sp)
    li a0, 1
    call print_int
    ld a0, 0(sp)
    addi sp, sp, 8
  .Lendif_1:
  large_end:
    ld ra, 16(sp)
    ld s0, 8(sp)
    addi sp, sp, 24
    ret
    
    .globl main
    .type main, @function
  main:
    addi sp, sp, -64
    sd ra, 56(sp)
    sd s0, 48(sp)
    addi s0, sp, 64
    li t0, 0
    li t1, 1
    sub t2, t0, t1
    slt t0, x0, t2
    slt t3, t2, x0
    add t0, t0, t3
    xori t0, t0, 1
    sd t0, -24(s0)
    ld t0, -24(s0)
    beq t0, x0, .Lelse_2
    li t0, 0
    li t1, 1
    sub t2, t0, t1
    slt t0, x0, t2
    slt t3, t2, x0
    add t0, t0, t3
    xori t0, t0, 1
    sd t0, -32(s0)
    ld t0, -32(s0)
    beq t0, x0, .Lelse_4
    li t0, 0
    li t1, 1
    sub t2, t0, t1
    slt t0, x0, t2
    slt t3, t2, x0
    add t0, t0, t3
    xori t0, t0, 1
    sd t0, -40(s0)
    ld t0, -40(s0)
    beq t0, x0, .Lelse_6
    li t0, 0
    sd t0, -48(s0)
    ld a0, -48(s0)
    call large
    j .Lendif_7
  .Lelse_6:
    li t0, 1
    sd t0, -56(s0)
    ld a0, -56(s0)
    call large
  .Lendif_7:
    j .Lendif_5
  .Lelse_4:
    li t0, 1
    li t1, 1
    sub t2, t0, t1
    slt t0, x0, t2
    slt t3, t2, x0
    add t0, t0, t3
    xori t0, t0, 1
    sd t0, -64(s0)
    ld t0, -64(s0)
    beq t0, x0, .Lelse_8
    li t0, 0
    sd t0, -72(s0)
    ld a0, -72(s0)
    call large
    j .Lendif_9
  .Lelse_8:
    li t0, 1
    sd t0, -80(s0)
    ld a0, -80(s0)
    call large
  .Lendif_9:
  .Lendif_5:
    j .Lendif_3
  .Lelse_2:
    li a0, 42
    call print_int
    addi t0, a0, 0
    sd t0, -88(s0)
    ld t0, -88(s0)
    sd t0, -96(s0)
    li t0, 1
    li t1, 1
    sub t2, t0, t1
    slt t0, x0, t2
    slt t3, t2, x0
    add t0, t0, t3
    xori t0, t0, 1
    sd t0, -104(s0)
    ld t0, -104(s0)
    beq t0, x0, .Lelse_10
    li t0, 0
    li t1, 1
    sub t2, t0, t1
    slt t0, x0, t2
    slt t3, t2, x0
    add t0, t0, t3
    xori t0, t0, 1
    sd t0, -112(s0)
    ld t0, -112(s0)
    beq t0, x0, .Lelse_12
    li t0, 0
    sd t0, -120(s0)
    ld a0, -120(s0)
    call large
    j .Lendif_13
  .Lelse_12:
    li t0, 1
    sd t0, -128(s0)
    ld a0, -128(s0)
    call large
  .Lendif_13:
    j .Lendif_11
  .Lelse_10:
    li t0, 1
    li t1, 1
    sub t2, t0, t1
    slt t0, x0, t2
    slt t3, t2, x0
    add t0, t0, t3
    xori t0, t0, 1
    sd t0, -136(s0)
    ld t0, -136(s0)
    beq t0, x0, .Lelse_14
    li t0, 0
    sd t0, -144(s0)
    ld a0, -144(s0)
    call large
    j .Lendif_15
  .Lelse_14:
    li t0, 1
    sd t0, -152(s0)
    ld a0, -152(s0)
    call large
  .Lendif_15:
  .Lendif_11:
  .Lendif_3:
  main_end:
    ld ra, 56(sp)
    ld s0, 48(sp)
    addi sp, sp, 64
    li a0, 0
    li a7, 93
    ecall
  $ riscv64-linux-gnu-as -march=rv64gc ite.s -o ite.o
  $ riscv64-linux-gnu-gcc -static ite.o -L../../../runtime -l:libruntime.a -o ite.elf -Wl,--no-warnings
  $ qemu-riscv64 ./ite.elf
  420

  $ cat >many_args.ml <<EOF
  > let f a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 = a0+a1+a2+a3+a4+a5+a6+a7+a8+a9+a10
  > let main = print_int (f 0 1 2 3 4 5 6 7 8 9 10)
  > EOF
  $ ../../../bin/AML.exe many_args.ml many_args.s
  Generated: many_args.s
  $ cat many_args.s
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
    ret
    
    .globl main
    .type main, @function
  main:
    addi sp, sp, -24
    sd ra, 16(sp)
    sd s0, 8(sp)
    addi s0, sp, 24
    li t0, 10
    addi sp, sp, -8
    sd t0, 0(sp)
    li t0, 9
    addi sp, sp, -8
    sd t0, 0(sp)
    li t0, 8
    addi sp, sp, -8
    sd t0, 0(sp)
    li a0, 0
    li a1, 1
    li a2, 2
    li a3, 3
    li a4, 4
    li a5, 5
    li a6, 6
    li a7, 7
    call f
    addi t0, a0, 0
    addi sp, sp, 24
    sd t0, -24(s0)
    ld a0, -24(s0)
    call print_int
  main_end:
    ld ra, 16(sp)
    ld s0, 8(sp)
    addi sp, sp, 24
    li a0, 0
    li a7, 93
    ecall

  $ riscv64-linux-gnu-as -march=rv64gc many_args.s -o many_args.o
  $ riscv64-linux-gnu-gcc -static many_args.o -L../../../runtime -l:libruntime.a -o many_args.elf -Wl,--no-warnings
  $ qemu-riscv64 ./many_args.elf
  55

  $ cat >faccps_ll.ml <<EOF
  > let id x = x
  > let fresh_1 n k p = k (p * n)
  > 
  > let rec fac_cps n k =
  >   if n = 1
  >   then k 1
  >  else fac_cps (n-1) (fresh_1 n k)
  > 
  > let main =
  >   let () = print_int (fac_cps 4 id) in
  >   0
  > EOF
  $ ../../../bin/AML.exe faccps_ll.ml faccps_ll.s
  Generated: faccps_ll.s
  $ cat faccps_ll.s
    .text
    .globl id
    .type id, @function
  id:
    addi sp, sp, -16
    sd ra, 8(sp)
    sd s0, 0(sp)
    addi s0, sp, 16
    addi a0, a0, 0
  id_end:
    ld ra, 8(sp)
    ld s0, 0(sp)
    addi sp, sp, 16
    ret
    
    .globl fresh_1
    .type fresh_1, @function
  fresh_1:
    addi sp, sp, -24
    sd ra, 16(sp)
    sd s0, 8(sp)
    addi s0, sp, 24
    addi t0, a2, 0
    addi t1, a0, 0
    mul t0, t0, t1
    sd t0, -24(s0)
    addi sp, sp, -8
    sd a0, 0(sp)
    addi sp, sp, -8
    sd a1, 0(sp)
    addi sp, sp, -8
    sd a2, 0(sp)
    ld a0, -24(s0)
    jalr a1
    ld a2, 0(sp)
    addi sp, sp, 8
    ld a1, 0(sp)
    addi sp, sp, 8
    ld a0, 0(sp)
    addi sp, sp, 8
  fresh_1_end:
    ld ra, 16(sp)
    ld s0, 8(sp)
    addi sp, sp, 24
    ret
    
    .globl fac_cps
    .type fac_cps, @function
  fac_cps:
    addi sp, sp, -40
    sd ra, 32(sp)
    sd s0, 24(sp)
    addi s0, sp, 40
    addi t0, a0, 0
    li t1, 1
    sub t2, t0, t1
    slt t0, x0, t2
    slt t3, t2, x0
    add t0, t0, t3
    xori t0, t0, 1
    sd t0, -24(s0)
    ld t0, -24(s0)
    beq t0, x0, .Lelse_0
    addi sp, sp, -8
    sd a0, 0(sp)
    addi sp, sp, -8
    sd a1, 0(sp)
    li a0, 1
    jalr a1
    ld a1, 0(sp)
    addi sp, sp, 8
    ld a0, 0(sp)
    addi sp, sp, 8
    j .Lendif_1
  .Lelse_0:
    addi t0, a0, 0
    li t1, 1
    sub t0, t0, t1
    sd t0, -32(s0)
    addi sp, sp, -8
    sd a0, 0(sp)
    addi sp, sp, -8
    sd a1, 0(sp)
    addi a0, a0, 0
    addi a1, a1, 0
    call fresh_1
    addi t0, a0, 0
    ld a1, 0(sp)
    addi sp, sp, 8
    ld a0, 0(sp)
    addi sp, sp, 8
    sd t0, -40(s0)
    addi sp, sp, -8
    sd a0, 0(sp)
    addi sp, sp, -8
    sd a1, 0(sp)
    ld a0, -32(s0)
    ld a1, -40(s0)
    call fac_cps
    ld a1, 0(sp)
    addi sp, sp, 8
    ld a0, 0(sp)
    addi sp, sp, 8
  .Lendif_1:
  fac_cps_end:
    ld ra, 32(sp)
    ld s0, 24(sp)
    addi sp, sp, 40
    ret
    
    .globl main
    .type main, @function
  main:
    addi sp, sp, -40
    sd ra, 32(sp)
    sd s0, 24(sp)
    addi s0, sp, 40
    li a0, 4
    la a1, id
    call fac_cps
    addi t0, a0, 0
    sd t0, -24(s0)
    ld a0, -24(s0)
    call print_int
    addi t0, a0, 0
    sd t0, -32(s0)
    ld t0, -32(s0)
    sd t0, -40(s0)
    li a0, 0
  main_end:
    ld ra, 32(sp)
    ld s0, 24(sp)
    addi sp, sp, 40
    li a0, 0
    li a7, 93
    ecall
  $ riscv64-linux-gnu-as -march=rv64gc faccps_ll.s -o faccps_ll.o
  $ riscv64-linux-gnu-gcc -static faccps_ll.o -L../../../runtime -l:libruntime.a -o faccps_ll.elf -Wl,--no-warnings
  $ qemu-riscv64 ./faccps_ll.elf
  Segmentation fault (core dumped)
  [139]
