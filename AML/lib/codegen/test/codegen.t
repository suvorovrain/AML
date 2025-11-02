(** Copyright 2025-2026, Rodion Suvorov, Dmitriy Chirkov*)

(** SPDX-License-Identifier: LGPL-3.0-or-later *)
=================== manytests ===================
  $ ../../../bin/AML.exe ./manytests/typed/010faccps_ll.ml faccps.s
  Generated: faccps.s
 2
  $ cat faccps.s
    .text
    .globl id
    .type id, @function
  id:
    addi sp, sp, -24
    sd ra, 16(sp)
    sd s0, 8(sp)
    addi s0, sp, 24
    ld t0, 0(a1)
    sd t0, -24(s0)
    ld a0, -24(s0)
  id_end:
    ld ra, 16(sp)
    ld s0, 8(sp)
    addi sp, sp, 24
    ret
    
    .globl fresh_1
    .type fresh_1, @function
  fresh_1:
    addi sp, sp, -48
    sd ra, 40(sp)
    sd s0, 32(sp)
    addi s0, sp, 48
    ld t0, 0(a1)
    sd t0, -24(s0)
    ld t0, 8(a1)
    sd t0, -32(s0)
    ld t0, 16(a1)
    sd t0, -40(s0)
    ld t0, -40(s0)
    ld t1, -24(s0)
    mul t0, t0, t1
    sd t0, -48(s0)
    addi sp, sp, -8
    ld t0, -48(s0)
    sd t0, 0(sp)
    ld a0, -32(s0)
    li a1, 1
    addi a2, sp, 0
    call closure_apply
    addi sp, sp, 8
  fresh_1_end:
    ld ra, 40(sp)
    ld s0, 32(sp)
    addi sp, sp, 48
    ret
    
    .globl fac_cps
    .type fac_cps, @function
  fac_cps:
    addi sp, sp, -56
    sd ra, 48(sp)
    sd s0, 40(sp)
    addi s0, sp, 56
    ld t0, 0(a1)
    sd t0, -24(s0)
    ld t0, 8(a1)
    sd t0, -32(s0)
    ld t0, -24(s0)
    li t1, 1
    sub t2, t0, t1
    slt t0, x0, t2
    slt t3, t2, x0
    add t0, t0, t3
    xori t0, t0, 1
    sd t0, -40(s0)
    ld t0, -40(s0)
    beq t0, x0, .Lelse_0
    addi sp, sp, -8
    li t0, 1
    sd t0, 0(sp)
    ld a0, -32(s0)
    li a1, 1
    addi a2, sp, 0
    call closure_apply
    addi sp, sp, 8
    j .Lendif_1
  .Lelse_0:
    ld t0, -24(s0)
    li t1, 1
    sub t0, t0, t1
    sd t0, -48(s0)
    addi sp, sp, -16
    ld t0, -24(s0)
    sd t0, 0(sp)
    ld t0, -32(s0)
    sd t0, 8(sp)
    la a0, fresh_1
    li a1, 3
    call closure_alloc
    li a1, 2
    addi a2, sp, 0
    call closure_apply
    addi sp, sp, 16
    addi t0, a0, 0
    sd t0, -56(s0)
    addi sp, sp, -16
    ld t0, -48(s0)
    sd t0, 0(sp)
    ld t0, -56(s0)
    sd t0, 8(sp)
    li a0, 2
    addi a1, sp, 0
    call fac_cps
    addi sp, sp, 16
  .Lendif_1:
  fac_cps_end:
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
    addi sp, sp, -16
    li t0, 4
    sd t0, 0(sp)
    la a0, id
    li a1, 1
    call closure_alloc
    addi t0, a0, 0
    sd t0, 8(sp)
    li a0, 2
    addi a1, sp, 0
    call fac_cps
    addi sp, sp, 16
    addi t0, a0, 0
    sd t0, -24(s0)
    addi sp, sp, -8
    ld t0, -24(s0)
    sd t0, 0(sp)
    li a0, 1
    addi a1, sp, 0
    call print_int
    addi sp, sp, 8
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
  $ riscv64-linux-gnu-as -march=rv64gc faccps.s -o faccps.o
  $ riscv64-linux-gnu-gcc -static faccps.o -L../../../runtime -l:libruntime.a -o faccps.elf -Wl,--no-warnings
  $ qemu-riscv64 ./faccps.elf
  24

  $ ../../../bin/AML.exe ./manytests/typed/010fibcps_ll.ml fibcps_ll.s
  Generated: fibcps_ll.s
  $ cat fibcps_ll.s
    .text
    .globl id
    .type id, @function
  id:
    addi sp, sp, -24
    sd ra, 16(sp)
    sd s0, 8(sp)
    addi s0, sp, 24
    ld t0, 0(a1)
    sd t0, -24(s0)
    ld a0, -24(s0)
  id_end:
    ld ra, 16(sp)
    ld s0, 8(sp)
    addi sp, sp, 24
    ret
    
    .globl fresh_2
    .type fresh_2, @function
  fresh_2:
    addi sp, sp, -48
    sd ra, 40(sp)
    sd s0, 32(sp)
    addi s0, sp, 48
    ld t0, 0(a1)
    sd t0, -24(s0)
    ld t0, 8(a1)
    sd t0, -32(s0)
    ld t0, 16(a1)
    sd t0, -40(s0)
    ld t0, -24(s0)
    ld t1, -40(s0)
    add t0, t0, t1
    sd t0, -48(s0)
    addi sp, sp, -8
    ld t0, -48(s0)
    sd t0, 0(sp)
    ld a0, -32(s0)
    li a1, 1
    addi a2, sp, 0
    call closure_apply
    addi sp, sp, 8
  fresh_2_end:
    ld ra, 40(sp)
    ld s0, 32(sp)
    addi sp, sp, 48
    ret
    
    .globl fresh_1
    .type fresh_1, @function
  fresh_1:
    addi sp, sp, -64
    sd ra, 56(sp)
    sd s0, 48(sp)
    addi s0, sp, 64
    ld t0, 0(a1)
    sd t0, -24(s0)
    ld t0, 8(a1)
    sd t0, -32(s0)
    ld t0, 16(a1)
    sd t0, -40(s0)
    ld t0, 24(a1)
    sd t0, -48(s0)
    ld t0, -24(s0)
    li t1, 2
    sub t0, t0, t1
    sd t0, -56(s0)
    addi sp, sp, -16
    ld t0, -48(s0)
    sd t0, 0(sp)
    ld t0, -32(s0)
    sd t0, 8(sp)
    la a0, fresh_2
    li a1, 3
    call closure_alloc
    li a1, 2
    addi a2, sp, 0
    call closure_apply
    addi sp, sp, 16
    addi t0, a0, 0
    sd t0, -64(s0)
    addi sp, sp, -16
    ld t0, -56(s0)
    sd t0, 0(sp)
    ld t0, -64(s0)
    sd t0, 8(sp)
    ld a0, -40(s0)
    li a1, 2
    addi a2, sp, 0
    call closure_apply
    addi sp, sp, 16
  fresh_1_end:
    ld ra, 56(sp)
    ld s0, 48(sp)
    addi sp, sp, 64
    ret
    
    .globl fib
    .type fib, @function
  fib:
    addi sp, sp, -56
    sd ra, 48(sp)
    sd s0, 40(sp)
    addi s0, sp, 56
    ld t0, 0(a1)
    sd t0, -24(s0)
    ld t0, 8(a1)
    sd t0, -32(s0)
    ld t0, -24(s0)
    li t1, 2
    slt t0, t0, t1
    sd t0, -40(s0)
    ld t0, -40(s0)
    beq t0, x0, .Lelse_0
    addi sp, sp, -8
    ld t0, -24(s0)
    sd t0, 0(sp)
    ld a0, -32(s0)
    li a1, 1
    addi a2, sp, 0
    call closure_apply
    addi sp, sp, 8
    j .Lendif_1
  .Lelse_0:
    ld t0, -24(s0)
    li t1, 1
    sub t0, t0, t1
    sd t0, -48(s0)
    addi sp, sp, -24
    ld t0, -24(s0)
    sd t0, 0(sp)
    ld t0, -32(s0)
    sd t0, 8(sp)
    la a0, fib
    li a1, 2
    call closure_alloc
    addi t0, a0, 0
    sd t0, 16(sp)
    addi sp, sp, -8
    sd x0, 0(sp)
    la a0, fresh_1
    li a1, 4
    call closure_alloc
    li a1, 3
    addi a2, sp, 8
    call closure_apply
    addi sp, sp, 8
    addi sp, sp, 24
    addi t0, a0, 0
    sd t0, -56(s0)
    addi sp, sp, -16
    ld t0, -48(s0)
    sd t0, 0(sp)
    ld t0, -56(s0)
    sd t0, 8(sp)
    li a0, 2
    addi a1, sp, 0
    call fib
    addi sp, sp, 16
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
    addi sp, sp, -16
    li t0, 6
    sd t0, 0(sp)
    la a0, id
    li a1, 1
    call closure_alloc
    addi t0, a0, 0
    sd t0, 8(sp)
    li a0, 2
    addi a1, sp, 0
    call fib
    addi sp, sp, 16
    addi t0, a0, 0
    sd t0, -24(s0)
    addi sp, sp, -8
    ld t0, -24(s0)
    sd t0, 0(sp)
    li a0, 1
    addi a1, sp, 0
    call print_int
    addi sp, sp, 8
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
  $ riscv64-linux-gnu-as -march=rv64gc fibcps_ll.s -o fibcps_ll.o
  $ riscv64-linux-gnu-gcc -static fibcps_ll.o -L../../../runtime -l:libruntime.a -o fibcps_ll.elf -Wl,--no-warnings
  $ qemu-riscv64 ./fibcps_ll.elf
  8

  $ ../../../bin/AML.exe ./manytests/typed/012faccps.ml faccps.s
  Generated: faccps.s
  $ cat faccps.s
  ;; Codegen error: Codegen: function k not found in arity_map
  $ riscv64-linux-gnu-as -march=rv64gc faccps.s -o faccps.o
  faccps.s: Assembler messages:
  faccps.s:1: Error: unrecognized opcode `codegen error:Codegen:function k not found in arity_map'
  [1]
  $ riscv64-linux-gnu-gcc -static faccps.o -L../../../runtime -l:libruntime.a -o faccps.elf -Wl,--no-warnings
  collect2: error: ld returned 1 exit status
  [1]
  $ qemu-riscv64 ./faccps.elf
  [1]

  $ ../../../bin/AML.exe ./manytests/typed/012fibcps.ml fibcps.s
  Generated: fibcps.s
  $ cat fibcps.s
  ;; Codegen error: Codegen: function k not found in arity_map
  $ riscv64-linux-gnu-as -march=rv64gc fibcps.s -o fibcps.o
  fibcps.s: Assembler messages:
  fibcps.s:1: Error: unrecognized opcode `codegen error:Codegen:function k not found in arity_map'
  [1]
  $ riscv64-linux-gnu-gcc -static fibcps.o -L../../../runtime -l:libruntime.a -o fibcps.elf -Wl,--no-warnings
  collect2: error: ld returned 1 exit status
  [1]
  $ qemu-riscv64 ./fibcps.elf
  [1]

  $ ../../../bin/AML.exe ./manytests/typed/004manyargs.ml many.s
  Generated: many.s
  $ cat many.s
    .text
    .globl wrap
    .type wrap, @function
  wrap:
    addi sp, sp, -32
    sd ra, 24(sp)
    sd s0, 16(sp)
    addi s0, sp, 32
    ld t0, 0(a1)
    sd t0, -24(s0)
    li t0, 1
    li t1, 1
    sub t2, t0, t1
    slt t0, x0, t2
    slt t3, t2, x0
    add t0, t0, t3
    xori t0, t0, 1
    sd t0, -32(s0)
    ld t0, -32(s0)
    beq t0, x0, .Lelse_0
    ld a0, -24(s0)
    j .Lendif_1
  .Lelse_0:
    ld a0, -24(s0)
  .Lendif_1:
  wrap_end:
    ld ra, 24(sp)
    ld s0, 16(sp)
    addi sp, sp, 32
    ret
    
    .globl test3
    .type test3, @function
  test3:
    addi sp, sp, -88
    sd ra, 80(sp)
    sd s0, 72(sp)
    addi s0, sp, 88
    ld t0, 0(a1)
    sd t0, -24(s0)
    ld t0, 8(a1)
    sd t0, -32(s0)
    ld t0, 16(a1)
    sd t0, -40(s0)
    addi sp, sp, -8
    ld t0, -24(s0)
    sd t0, 0(sp)
    li a0, 1
    addi a1, sp, 0
    call print_int
    addi sp, sp, 8
    addi t0, a0, 0
    sd t0, -48(s0)
    ld t0, -48(s0)
    sd t0, -56(s0)
    addi sp, sp, -8
    ld t0, -32(s0)
    sd t0, 0(sp)
    li a0, 1
    addi a1, sp, 0
    call print_int
    addi sp, sp, 8
    addi t0, a0, 0
    sd t0, -64(s0)
    ld t0, -64(s0)
    sd t0, -72(s0)
    addi sp, sp, -8
    ld t0, -40(s0)
    sd t0, 0(sp)
    li a0, 1
    addi a1, sp, 0
    call print_int
    addi sp, sp, 8
    addi t0, a0, 0
    sd t0, -80(s0)
    ld t0, -80(s0)
    sd t0, -88(s0)
    li a0, 0
  test3_end:
    ld ra, 80(sp)
    ld s0, 72(sp)
    addi sp, sp, 88
    ret
    
    .globl test10
    .type test10, @function
  test10:
    addi sp, sp, -160
    sd ra, 152(sp)
    sd s0, 144(sp)
    addi s0, sp, 160
    ld t0, 0(a1)
    sd t0, -24(s0)
    ld t0, 8(a1)
    sd t0, -32(s0)
    ld t0, 16(a1)
    sd t0, -40(s0)
    ld t0, 24(a1)
    sd t0, -48(s0)
    ld t0, 32(a1)
    sd t0, -56(s0)
    ld t0, 40(a1)
    sd t0, -64(s0)
    ld t0, 48(a1)
    sd t0, -72(s0)
    ld t0, 56(a1)
    sd t0, -80(s0)
    ld t0, 64(a1)
    sd t0, -88(s0)
    ld t0, 72(a1)
    sd t0, -96(s0)
    ld t0, -24(s0)
    ld t1, -32(s0)
    add t0, t0, t1
    sd t0, -104(s0)
    ld t0, -104(s0)
    ld t1, -40(s0)
    add t0, t0, t1
    sd t0, -112(s0)
    ld t0, -112(s0)
    ld t1, -48(s0)
    add t0, t0, t1
    sd t0, -120(s0)
    ld t0, -120(s0)
    ld t1, -56(s0)
    add t0, t0, t1
    sd t0, -128(s0)
    ld t0, -128(s0)
    ld t1, -64(s0)
    add t0, t0, t1
    sd t0, -136(s0)
    ld t0, -136(s0)
    ld t1, -72(s0)
    add t0, t0, t1
    sd t0, -144(s0)
    ld t0, -144(s0)
    ld t1, -80(s0)
    add t0, t0, t1
    sd t0, -152(s0)
    ld t0, -152(s0)
    ld t1, -88(s0)
    add t0, t0, t1
    sd t0, -160(s0)
    ld t0, -160(s0)
    ld t1, -96(s0)
    add a0, t0, t1
  test10_end:
    ld ra, 152(sp)
    ld s0, 144(sp)
    addi sp, sp, 160
    ret
    
    .globl main
    .type main, @function
  main:
    addi sp, sp, -64
    sd ra, 56(sp)
    sd s0, 48(sp)
    addi s0, sp, 64
    addi sp, sp, -88
    la a0, test10
    li a1, 10
    call closure_alloc
    addi t0, a0, 0
    sd t0, 0(sp)
    li t0, 1
    sd t0, 8(sp)
    li t0, 10
    sd t0, 16(sp)
    li t0, 100
    sd t0, 24(sp)
    li t0, 1000
    sd t0, 32(sp)
    li t0, 10000
    sd t0, 40(sp)
    li t0, 100000
    sd t0, 48(sp)
    li t0, 1000000
    sd t0, 56(sp)
    li t0, 10000000
    sd t0, 64(sp)
    li t0, 100000000
    sd t0, 72(sp)
    li t0, 1000000000
    sd t0, 80(sp)
    li a0, 1
    addi a1, sp, 0
    call wrap
    addi a0, a0, 0
    li a1, 10
    addi a2, sp, 8
    call closure_apply
    addi sp, sp, 88
    addi t0, a0, 0
    sd t0, -24(s0)
    ld t0, -24(s0)
    sd t0, -32(s0)
    addi sp, sp, -8
    ld t0, -32(s0)
    sd t0, 0(sp)
    li a0, 1
    addi a1, sp, 0
    call print_int
    addi sp, sp, 8
    addi t0, a0, 0
    sd t0, -40(s0)
    ld t0, -40(s0)
    sd t0, -48(s0)
    addi sp, sp, -32
    la a0, test3
    li a1, 3
    call closure_alloc
    addi t0, a0, 0
    sd t0, 0(sp)
    li t0, 1
    sd t0, 8(sp)
    li t0, 10
    sd t0, 16(sp)
    li t0, 100
    sd t0, 24(sp)
    li a0, 1
    addi a1, sp, 0
    call wrap
    addi a0, a0, 0
    li a1, 3
    addi a2, sp, 8
    call closure_apply
    addi sp, sp, 32
    addi t0, a0, 0
    sd t0, -56(s0)
    ld t0, -56(s0)
    sd t0, -64(s0)
    li a0, 0
  main_end:
    ld ra, 56(sp)
    ld s0, 48(sp)
    addi sp, sp, 64
    li a0, 0
    li a7, 93
    ecall
  $ riscv64-linux-gnu-as -march=rv64gc many.s -o many.o
  $ riscv64-linux-gnu-gcc -static many.o -L../../../runtime -l:libruntime.a -o many.elf -Wl,--no-warnings
  $ qemu-riscv64 ./many.elf
  1111111111110100
=================== without partial ===================
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
    addi sp, sp, -64
    sd ra, 56(sp)
    sd s0, 48(sp)
    addi s0, sp, 64
    ld t0, 0(a1)
    sd t0, -24(s0)
    ld t0, -24(s0)
    li t1, 2
    slt t0, t0, t1
    sd t0, -32(s0)
    ld t0, -32(s0)
    beq t0, x0, .Lelse_0
    ld a0, -24(s0)
    j .Lendif_1
  .Lelse_0:
    ld t0, -24(s0)
    li t1, 1
    sub t0, t0, t1
    sd t0, -40(s0)
    addi sp, sp, -8
    ld t0, -40(s0)
    sd t0, 0(sp)
    li a0, 1
    addi a1, sp, 0
    call fib
    addi sp, sp, 8
    addi t0, a0, 0
    sd t0, -48(s0)
    ld t0, -24(s0)
    li t1, 2
    sub t0, t0, t1
    sd t0, -56(s0)
    addi sp, sp, -8
    ld t0, -56(s0)
    sd t0, 0(sp)
    li a0, 1
    addi a1, sp, 0
    call fib
    addi sp, sp, 8
    addi t0, a0, 0
    sd t0, -64(s0)
    ld t0, -48(s0)
    ld t1, -64(s0)
    add a0, t0, t1
  .Lendif_1:
  fib_end:
    ld ra, 56(sp)
    ld s0, 48(sp)
    addi sp, sp, 64
    ret
    
    .globl main
    .type main, @function
  main:
    addi sp, sp, -40
    sd ra, 32(sp)
    sd s0, 24(sp)
    addi s0, sp, 40
    addi sp, sp, -8
    li t0, 4
    sd t0, 0(sp)
    li a0, 1
    addi a1, sp, 0
    call fib
    addi sp, sp, 8
    addi t0, a0, 0
    sd t0, -24(s0)
    addi sp, sp, -8
    ld t0, -24(s0)
    sd t0, 0(sp)
    li a0, 1
    addi a1, sp, 0
    call print_int
    addi sp, sp, 8
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
    addi sp, sp, -32
    sd ra, 24(sp)
    sd s0, 16(sp)
    addi s0, sp, 32
    ld t0, 0(a1)
    sd t0, -24(s0)
    li t0, 0
    ld t1, -24(s0)
    sub t2, t0, t1
    slt t0, x0, t2
    slt t3, t2, x0
    add t0, t0, t3
    sd t0, -32(s0)
    ld t0, -32(s0)
    beq t0, x0, .Lelse_0
    addi sp, sp, -8
    li t0, 0
    sd t0, 0(sp)
    li a0, 1
    addi a1, sp, 0
    call print_int
    addi sp, sp, 8
    j .Lendif_1
  .Lelse_0:
    addi sp, sp, -8
    li t0, 1
    sd t0, 0(sp)
    li a0, 1
    addi a1, sp, 0
    call print_int
    addi sp, sp, 8
  .Lendif_1:
  large_end:
    ld ra, 24(sp)
    ld s0, 16(sp)
    addi sp, sp, 32
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
    addi sp, sp, -8
    ld t0, -48(s0)
    sd t0, 0(sp)
    li a0, 1
    addi a1, sp, 0
    call large
    addi sp, sp, 8
    j .Lendif_7
  .Lelse_6:
    li t0, 1
    sd t0, -56(s0)
    addi sp, sp, -8
    ld t0, -56(s0)
    sd t0, 0(sp)
    li a0, 1
    addi a1, sp, 0
    call large
    addi sp, sp, 8
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
    addi sp, sp, -8
    ld t0, -72(s0)
    sd t0, 0(sp)
    li a0, 1
    addi a1, sp, 0
    call large
    addi sp, sp, 8
    j .Lendif_9
  .Lelse_8:
    li t0, 1
    sd t0, -80(s0)
    addi sp, sp, -8
    ld t0, -80(s0)
    sd t0, 0(sp)
    li a0, 1
    addi a1, sp, 0
    call large
    addi sp, sp, 8
  .Lendif_9:
  .Lendif_5:
    j .Lendif_3
  .Lelse_2:
    addi sp, sp, -8
    li t0, 42
    sd t0, 0(sp)
    li a0, 1
    addi a1, sp, 0
    call print_int
    addi sp, sp, 8
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
    addi sp, sp, -8
    ld t0, -120(s0)
    sd t0, 0(sp)
    li a0, 1
    addi a1, sp, 0
    call large
    addi sp, sp, 8
    j .Lendif_13
  .Lelse_12:
    li t0, 1
    sd t0, -128(s0)
    addi sp, sp, -8
    ld t0, -128(s0)
    sd t0, 0(sp)
    li a0, 1
    addi a1, sp, 0
    call large
    addi sp, sp, 8
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
    addi sp, sp, -8
    ld t0, -144(s0)
    sd t0, 0(sp)
    li a0, 1
    addi a1, sp, 0
    call large
    addi sp, sp, 8
    j .Lendif_15
  .Lelse_14:
    li t0, 1
    sd t0, -152(s0)
    addi sp, sp, -8
    ld t0, -152(s0)
    sd t0, 0(sp)
    li a0, 1
    addi a1, sp, 0
    call large
    addi sp, sp, 8
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

=================== custom ===================
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
    addi sp, sp, -176
    sd ra, 168(sp)
    sd s0, 160(sp)
    addi s0, sp, 176
    ld t0, 0(a1)
    sd t0, -24(s0)
    ld t0, 8(a1)
    sd t0, -32(s0)
    ld t0, 16(a1)
    sd t0, -40(s0)
    ld t0, 24(a1)
    sd t0, -48(s0)
    ld t0, 32(a1)
    sd t0, -56(s0)
    ld t0, 40(a1)
    sd t0, -64(s0)
    ld t0, 48(a1)
    sd t0, -72(s0)
    ld t0, 56(a1)
    sd t0, -80(s0)
    ld t0, 64(a1)
    sd t0, -88(s0)
    ld t0, 72(a1)
    sd t0, -96(s0)
    ld t0, 80(a1)
    sd t0, -104(s0)
    ld t0, -24(s0)
    ld t1, -32(s0)
    add t0, t0, t1
    sd t0, -112(s0)
    ld t0, -112(s0)
    ld t1, -40(s0)
    add t0, t0, t1
    sd t0, -120(s0)
    ld t0, -120(s0)
    ld t1, -48(s0)
    add t0, t0, t1
    sd t0, -128(s0)
    ld t0, -128(s0)
    ld t1, -56(s0)
    add t0, t0, t1
    sd t0, -136(s0)
    ld t0, -136(s0)
    ld t1, -64(s0)
    add t0, t0, t1
    sd t0, -144(s0)
    ld t0, -144(s0)
    ld t1, -72(s0)
    add t0, t0, t1
    sd t0, -152(s0)
    ld t0, -152(s0)
    ld t1, -80(s0)
    add t0, t0, t1
    sd t0, -160(s0)
    ld t0, -160(s0)
    ld t1, -88(s0)
    add t0, t0, t1
    sd t0, -168(s0)
    ld t0, -168(s0)
    ld t1, -96(s0)
    add t0, t0, t1
    sd t0, -176(s0)
    ld t0, -176(s0)
    ld t1, -104(s0)
    add a0, t0, t1
  f_end:
    ld ra, 168(sp)
    ld s0, 160(sp)
    addi sp, sp, 176
    ret
    
    .globl main
    .type main, @function
  main:
    addi sp, sp, -24
    sd ra, 16(sp)
    sd s0, 8(sp)
    addi s0, sp, 24
    addi sp, sp, -88
    li t0, 0
    sd t0, 0(sp)
    li t0, 1
    sd t0, 8(sp)
    li t0, 2
    sd t0, 16(sp)
    li t0, 3
    sd t0, 24(sp)
    li t0, 4
    sd t0, 32(sp)
    li t0, 5
    sd t0, 40(sp)
    li t0, 6
    sd t0, 48(sp)
    li t0, 7
    sd t0, 56(sp)
    li t0, 8
    sd t0, 64(sp)
    li t0, 9
    sd t0, 72(sp)
    li t0, 10
    sd t0, 80(sp)
    li a0, 11
    addi a1, sp, 0
    call f
    addi sp, sp, 88
    addi t0, a0, 0
    sd t0, -24(s0)
    addi sp, sp, -8
    ld t0, -24(s0)
    sd t0, 0(sp)
    li a0, 1
    addi a1, sp, 0
    call print_int
    addi sp, sp, 8
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

=================== custom (before cc + ll) ===================
  $ cat >many_args_pa.ml <<EOF
  > let wrap f = if 1 = 1 then f else f
  > 
  > let test3 a b c =
  > let a = print_int a in
  > let b = print_int b in
  > let c = print_int c in
  > 0
  > 
  > let test10 a b c d e f g h i j = a + b + c + d + e + f + g + h + i + j
  > 
  > let main =
  > let rez =
  >     (wrap test10 1 10 100 1000 10000 100000 1000000 10000000 100000000
  >        1000000000)
  > in
  > let () = print_int rez in
  > let temp2 = wrap test3 1 10 100 in
  > 0
  > EOF
  $ ../../../bin/AML.exe many_args_pa.ml many_args_pa.s
  Generated: many_args_pa.s
  $ cat many_args_pa.s
    .text
    .globl wrap
    .type wrap, @function
  wrap:
    addi sp, sp, -32
    sd ra, 24(sp)
    sd s0, 16(sp)
    addi s0, sp, 32
    ld t0, 0(a1)
    sd t0, -24(s0)
    li t0, 1
    li t1, 1
    sub t2, t0, t1
    slt t0, x0, t2
    slt t3, t2, x0
    add t0, t0, t3
    xori t0, t0, 1
    sd t0, -32(s0)
    ld t0, -32(s0)
    beq t0, x0, .Lelse_0
    ld a0, -24(s0)
    j .Lendif_1
  .Lelse_0:
    ld a0, -24(s0)
  .Lendif_1:
  wrap_end:
    ld ra, 24(sp)
    ld s0, 16(sp)
    addi sp, sp, 32
    ret
    
    .globl test3
    .type test3, @function
  test3:
    addi sp, sp, -88
    sd ra, 80(sp)
    sd s0, 72(sp)
    addi s0, sp, 88
    ld t0, 0(a1)
    sd t0, -24(s0)
    ld t0, 8(a1)
    sd t0, -32(s0)
    ld t0, 16(a1)
    sd t0, -40(s0)
    addi sp, sp, -8
    ld t0, -24(s0)
    sd t0, 0(sp)
    li a0, 1
    addi a1, sp, 0
    call print_int
    addi sp, sp, 8
    addi t0, a0, 0
    sd t0, -48(s0)
    ld t0, -48(s0)
    sd t0, -56(s0)
    addi sp, sp, -8
    ld t0, -32(s0)
    sd t0, 0(sp)
    li a0, 1
    addi a1, sp, 0
    call print_int
    addi sp, sp, 8
    addi t0, a0, 0
    sd t0, -64(s0)
    ld t0, -64(s0)
    sd t0, -72(s0)
    addi sp, sp, -8
    ld t0, -40(s0)
    sd t0, 0(sp)
    li a0, 1
    addi a1, sp, 0
    call print_int
    addi sp, sp, 8
    addi t0, a0, 0
    sd t0, -80(s0)
    ld t0, -80(s0)
    sd t0, -88(s0)
    li a0, 0
  test3_end:
    ld ra, 80(sp)
    ld s0, 72(sp)
    addi sp, sp, 88
    ret
    
    .globl test10
    .type test10, @function
  test10:
    addi sp, sp, -160
    sd ra, 152(sp)
    sd s0, 144(sp)
    addi s0, sp, 160
    ld t0, 0(a1)
    sd t0, -24(s0)
    ld t0, 8(a1)
    sd t0, -32(s0)
    ld t0, 16(a1)
    sd t0, -40(s0)
    ld t0, 24(a1)
    sd t0, -48(s0)
    ld t0, 32(a1)
    sd t0, -56(s0)
    ld t0, 40(a1)
    sd t0, -64(s0)
    ld t0, 48(a1)
    sd t0, -72(s0)
    ld t0, 56(a1)
    sd t0, -80(s0)
    ld t0, 64(a1)
    sd t0, -88(s0)
    ld t0, 72(a1)
    sd t0, -96(s0)
    ld t0, -24(s0)
    ld t1, -32(s0)
    add t0, t0, t1
    sd t0, -104(s0)
    ld t0, -104(s0)
    ld t1, -40(s0)
    add t0, t0, t1
    sd t0, -112(s0)
    ld t0, -112(s0)
    ld t1, -48(s0)
    add t0, t0, t1
    sd t0, -120(s0)
    ld t0, -120(s0)
    ld t1, -56(s0)
    add t0, t0, t1
    sd t0, -128(s0)
    ld t0, -128(s0)
    ld t1, -64(s0)
    add t0, t0, t1
    sd t0, -136(s0)
    ld t0, -136(s0)
    ld t1, -72(s0)
    add t0, t0, t1
    sd t0, -144(s0)
    ld t0, -144(s0)
    ld t1, -80(s0)
    add t0, t0, t1
    sd t0, -152(s0)
    ld t0, -152(s0)
    ld t1, -88(s0)
    add t0, t0, t1
    sd t0, -160(s0)
    ld t0, -160(s0)
    ld t1, -96(s0)
    add a0, t0, t1
  test10_end:
    ld ra, 152(sp)
    ld s0, 144(sp)
    addi sp, sp, 160
    ret
    
    .globl main
    .type main, @function
  main:
    addi sp, sp, -64
    sd ra, 56(sp)
    sd s0, 48(sp)
    addi s0, sp, 64
    addi sp, sp, -88
    la a0, test10
    li a1, 10
    call closure_alloc
    addi t0, a0, 0
    sd t0, 0(sp)
    li t0, 1
    sd t0, 8(sp)
    li t0, 10
    sd t0, 16(sp)
    li t0, 100
    sd t0, 24(sp)
    li t0, 1000
    sd t0, 32(sp)
    li t0, 10000
    sd t0, 40(sp)
    li t0, 100000
    sd t0, 48(sp)
    li t0, 1000000
    sd t0, 56(sp)
    li t0, 10000000
    sd t0, 64(sp)
    li t0, 100000000
    sd t0, 72(sp)
    li t0, 1000000000
    sd t0, 80(sp)
    li a0, 1
    addi a1, sp, 0
    call wrap
    addi a0, a0, 0
    li a1, 10
    addi a2, sp, 8
    call closure_apply
    addi sp, sp, 88
    addi t0, a0, 0
    sd t0, -24(s0)
    ld t0, -24(s0)
    sd t0, -32(s0)
    addi sp, sp, -8
    ld t0, -32(s0)
    sd t0, 0(sp)
    li a0, 1
    addi a1, sp, 0
    call print_int
    addi sp, sp, 8
    addi t0, a0, 0
    sd t0, -40(s0)
    ld t0, -40(s0)
    sd t0, -48(s0)
    addi sp, sp, -32
    la a0, test3
    li a1, 3
    call closure_alloc
    addi t0, a0, 0
    sd t0, 0(sp)
    li t0, 1
    sd t0, 8(sp)
    li t0, 10
    sd t0, 16(sp)
    li t0, 100
    sd t0, 24(sp)
    li a0, 1
    addi a1, sp, 0
    call wrap
    addi a0, a0, 0
    li a1, 3
    addi a2, sp, 8
    call closure_apply
    addi sp, sp, 32
    addi t0, a0, 0
    sd t0, -56(s0)
    ld t0, -56(s0)
    sd t0, -64(s0)
    li a0, 0
  main_end:
    ld ra, 56(sp)
    ld s0, 48(sp)
    addi sp, sp, 64
    li a0, 0
    li a7, 93
    ecall

  $ riscv64-linux-gnu-as -march=rv64gc many_args_pa.s -o many_args_pa.o
  $ riscv64-linux-gnu-gcc -static many_args_pa.o -L../../../runtime -l:libruntime.a -o many_args_pa.elf -Wl,--no-warnings
  $ qemu-riscv64 ./many_args_pa.elf
  1111111111110100


=================== custom (partial application 4) ===================
  $ cat >many_args_pa.ml <<EOF
  > let f a0 a1 a2 a3 a4 = a0 a1 a2 a3 a4 
  > let add4 a1 a2 a3 a4  = a1+a2+a3+a4
  > let g a = (f add4) a 
  > let main = print_int (g 1 1 1 1)
  > EOF
  $ ../../../bin/AML.exe --dump-cc-ll-anf many_args_pa.ml
  let t_14 =
    fun a4__5 ->
      a0__1 a1__2 a2__3 a3__4 a4__5
  
  let t_13 =
    fun a3__4 ->
      t_14
  
  let t_12 =
    fun a2__3 ->
      t_13
  
  let t_11 =
    fun a1__2 ->
      t_12
  
  let t_10 =
    fun a0__1 ->
      t_11
  
  let t_9 =
    fun a3__4 ->
      let f_cc_7 = t_10 in
      let closure_cc_8 = f_cc_7 a0__1 a1__2 a2__3 a3__4 in
      closure_cc_8
  
  let t_8 =
    fun a2__3 ->
      t_9
  
  let t_7 =
    fun a1__2 ->
      t_8
  
  let t_6 =
    fun a0__1 ->
      t_7
  
  let t_5 =
    fun a2__3 ->
      let f_cc_5 = t_6 in
      let closure_cc_6 = f_cc_5 a0__1 a1__2 a2__3 in
      closure_cc_6
  
  let t_4 =
    fun a1__2 ->
      t_5
  
  let t_3 =
    fun a0__1 ->
      t_4
  
  let t_2 =
    fun a1__2 ->
      let f_cc_3 = t_3 in
      let closure_cc_4 = f_cc_3 a0__1 a1__2 in
      closure_cc_4
  
  let t_1 =
    fun a0__1 ->
      t_2
  
  let t_0 =
    fun a0__1 ->
      let f_cc_1 = t_1 in
      let closure_cc_2 = f_cc_1 a0__1 in
      closure_cc_2
  
  let t_24 =
    fun a4__10 ->
      let t_2__11 = a1__7 + a2__8 in
      let t_3__12 = t_2__11 + a3__9 in
      t_3__12 + a4__10
  
  let t_23 =
    fun a3__9 ->
      t_24
  
  let t_22 =
    fun a2__8 ->
      t_23
  
  let t_21 =
    fun a1__7 ->
      t_22
  
  let t_20 =
    fun a3__9 ->
      let f_cc_14 = t_21 in
      let closure_cc_15 = f_cc_14 a1__7 a2__8 a3__9 in
      closure_cc_15
  
  let t_19 =
    fun a2__8 ->
      t_20
  
  let t_18 =
    fun a1__7 ->
      t_19
  
  let t_17 =
    fun a2__8 ->
      let f_cc_12 = t_18 in
      let closure_cc_13 = f_cc_12 a1__7 a2__8 in
      closure_cc_13
  
  let t_16 =
    fun a1__7 ->
      t_17
  
  let t_15 =
    fun a1__7 ->
      let f_cc_10 = t_16 in
      let closure_cc_11 = f_cc_10 a1__7 in
      closure_cc_11
  
  let t_27 =
    fun a__14 ->
      f__0 add4__6 a__14
  
  let t_26 =
    fun f__0 ->
      t_27
  
  let t_25 =
    fun add4__6 ->
      t_26
  
  let f__0_cc_0 =
    t_0
  
  let f__0 =
    f__0_cc_0
  
  let add4__6_cc_9 =
    t_15
  
  let add4__6 =
    add4__6_cc_9
  
  let g__13_cc_16 =
    t_25
  
  let g__13 =
    g__13_cc_16 add4__6 f__0
  
  let main__15 =
    let t_8__16 = g__13 1 1 1 1 in
    print_int t_8__16
  $ ../../../bin/AML.exe many_args_pa.ml many_args_pa.s
  Generated: many_args_pa.s
  $ cat many_args_pa.s
    .text
    .globl f
    .type f, @function
  f:
    addi sp, sp, -56
    sd ra, 48(sp)
    sd s0, 40(sp)
    addi s0, sp, 56
    ld t0, 0(a1)
    sd t0, -24(s0)
    ld t0, 8(a1)
    sd t0, -32(s0)
    ld t0, 16(a1)
    sd t0, -40(s0)
    ld t0, 24(a1)
    sd t0, -48(s0)
    ld t0, 32(a1)
    sd t0, -56(s0)
    addi sp, sp, -32
    ld t0, -32(s0)
    sd t0, 0(sp)
    ld t0, -40(s0)
    sd t0, 8(sp)
    ld t0, -48(s0)
    sd t0, 16(sp)
    ld t0, -56(s0)
    sd t0, 24(sp)
    ld a0, -24(s0)
    li a1, 4
    addi a2, sp, 0
    call closure_apply
    addi sp, sp, 32
  f_end:
    ld ra, 48(sp)
    ld s0, 40(sp)
    addi sp, sp, 56
    ret
    
    .globl add4
    .type add4, @function
  add4:
    addi sp, sp, -64
    sd ra, 56(sp)
    sd s0, 48(sp)
    addi s0, sp, 64
    ld t0, 0(a1)
    sd t0, -24(s0)
    ld t0, 8(a1)
    sd t0, -32(s0)
    ld t0, 16(a1)
    sd t0, -40(s0)
    ld t0, 24(a1)
    sd t0, -48(s0)
    ld t0, -24(s0)
    ld t1, -32(s0)
    add t0, t0, t1
    sd t0, -56(s0)
    ld t0, -56(s0)
    ld t1, -40(s0)
    add t0, t0, t1
    sd t0, -64(s0)
    ld t0, -64(s0)
    ld t1, -48(s0)
    add a0, t0, t1
  add4_end:
    ld ra, 56(sp)
    ld s0, 48(sp)
    addi sp, sp, 64
    ret
    
    .globl g
    .type g, @function
  g:
    addi sp, sp, -24
    sd ra, 16(sp)
    sd s0, 8(sp)
    addi s0, sp, 24
    ld t0, 0(a1)
    sd t0, -24(s0)
    addi sp, sp, -16
    la a0, add4
    li a1, 4
    call closure_alloc
    addi t0, a0, 0
    sd t0, 0(sp)
    ld t0, -24(s0)
    sd t0, 8(sp)
    la a0, f
    li a1, 5
    call closure_alloc
    li a1, 2
    addi a2, sp, 0
    call closure_apply
    addi sp, sp, 16
  g_end:
    ld ra, 16(sp)
    ld s0, 8(sp)
    addi sp, sp, 24
    ret
    
    .globl main
    .type main, @function
  main:
    addi sp, sp, -24
    sd ra, 16(sp)
    sd s0, 8(sp)
    addi s0, sp, 24
    addi sp, sp, -32
    li t0, 1
    sd t0, 0(sp)
    li t0, 1
    sd t0, 8(sp)
    li t0, 1
    sd t0, 16(sp)
    li t0, 1
    sd t0, 24(sp)
    li a0, 1
    addi a1, sp, 0
    call g
    addi a0, a0, 0
    li a1, 3
    addi a2, sp, 8
    call closure_apply
    addi sp, sp, 32
    addi t0, a0, 0
    sd t0, -24(s0)
    addi sp, sp, -8
    ld t0, -24(s0)
    sd t0, 0(sp)
    li a0, 1
    addi a1, sp, 0
    call print_int
    addi sp, sp, 8
  main_end:
    ld ra, 16(sp)
    ld s0, 8(sp)
    addi sp, sp, 24
    li a0, 0
    li a7, 93
    ecall

  $ riscv64-linux-gnu-as -march=rv64gc many_args_pa.s -o many_args_pa.o
  $ riscv64-linux-gnu-gcc -static many_args_pa.o -L../../../runtime -l:libruntime.a -o many_args_pa.elf -Wl,--no-warnings
  $ qemu-riscv64 ./many_args_pa.elf
  4


=================== custom (partial application 10) ===================
  $ cat >many_args_pam.ml <<EOF
  > let f a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 = a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10
  > let add10 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 = a1+a2+a3+a4+a5+a6+a7+a8+a9+a10
  > let g a = (f add10) a 
  > let main = print_int (g 1 1 1 1 1 1 1 1 1 1)
  > EOF
  $ ../../../bin/AML.exe many_args_pam.ml many_args_pam.s
  Generated: many_args_pam.s
  $ cat many_args_pam.s
    .text
    .globl f
    .type f, @function
  f:
    addi sp, sp, -104
    sd ra, 96(sp)
    sd s0, 88(sp)
    addi s0, sp, 104
    ld t0, 0(a1)
    sd t0, -24(s0)
    ld t0, 8(a1)
    sd t0, -32(s0)
    ld t0, 16(a1)
    sd t0, -40(s0)
    ld t0, 24(a1)
    sd t0, -48(s0)
    ld t0, 32(a1)
    sd t0, -56(s0)
    ld t0, 40(a1)
    sd t0, -64(s0)
    ld t0, 48(a1)
    sd t0, -72(s0)
    ld t0, 56(a1)
    sd t0, -80(s0)
    ld t0, 64(a1)
    sd t0, -88(s0)
    ld t0, 72(a1)
    sd t0, -96(s0)
    ld t0, 80(a1)
    sd t0, -104(s0)
    addi sp, sp, -80
    ld t0, -32(s0)
    sd t0, 0(sp)
    ld t0, -40(s0)
    sd t0, 8(sp)
    ld t0, -48(s0)
    sd t0, 16(sp)
    ld t0, -56(s0)
    sd t0, 24(sp)
    ld t0, -64(s0)
    sd t0, 32(sp)
    ld t0, -72(s0)
    sd t0, 40(sp)
    ld t0, -80(s0)
    sd t0, 48(sp)
    ld t0, -88(s0)
    sd t0, 56(sp)
    ld t0, -96(s0)
    sd t0, 64(sp)
    ld t0, -104(s0)
    sd t0, 72(sp)
    ld a0, -24(s0)
    li a1, 10
    addi a2, sp, 0
    call closure_apply
    addi sp, sp, 80
  f_end:
    ld ra, 96(sp)
    ld s0, 88(sp)
    addi sp, sp, 104
    ret
    
    .globl add10
    .type add10, @function
  add10:
    addi sp, sp, -160
    sd ra, 152(sp)
    sd s0, 144(sp)
    addi s0, sp, 160
    ld t0, 0(a1)
    sd t0, -24(s0)
    ld t0, 8(a1)
    sd t0, -32(s0)
    ld t0, 16(a1)
    sd t0, -40(s0)
    ld t0, 24(a1)
    sd t0, -48(s0)
    ld t0, 32(a1)
    sd t0, -56(s0)
    ld t0, 40(a1)
    sd t0, -64(s0)
    ld t0, 48(a1)
    sd t0, -72(s0)
    ld t0, 56(a1)
    sd t0, -80(s0)
    ld t0, 64(a1)
    sd t0, -88(s0)
    ld t0, 72(a1)
    sd t0, -96(s0)
    ld t0, -24(s0)
    ld t1, -32(s0)
    add t0, t0, t1
    sd t0, -104(s0)
    ld t0, -104(s0)
    ld t1, -40(s0)
    add t0, t0, t1
    sd t0, -112(s0)
    ld t0, -112(s0)
    ld t1, -48(s0)
    add t0, t0, t1
    sd t0, -120(s0)
    ld t0, -120(s0)
    ld t1, -56(s0)
    add t0, t0, t1
    sd t0, -128(s0)
    ld t0, -128(s0)
    ld t1, -64(s0)
    add t0, t0, t1
    sd t0, -136(s0)
    ld t0, -136(s0)
    ld t1, -72(s0)
    add t0, t0, t1
    sd t0, -144(s0)
    ld t0, -144(s0)
    ld t1, -80(s0)
    add t0, t0, t1
    sd t0, -152(s0)
    ld t0, -152(s0)
    ld t1, -88(s0)
    add t0, t0, t1
    sd t0, -160(s0)
    ld t0, -160(s0)
    ld t1, -96(s0)
    add a0, t0, t1
  add10_end:
    ld ra, 152(sp)
    ld s0, 144(sp)
    addi sp, sp, 160
    ret
    
    .globl g
    .type g, @function
  g:
    addi sp, sp, -24
    sd ra, 16(sp)
    sd s0, 8(sp)
    addi s0, sp, 24
    ld t0, 0(a1)
    sd t0, -24(s0)
    addi sp, sp, -16
    la a0, add10
    li a1, 10
    call closure_alloc
    addi t0, a0, 0
    sd t0, 0(sp)
    ld t0, -24(s0)
    sd t0, 8(sp)
    la a0, f
    li a1, 11
    call closure_alloc
    li a1, 2
    addi a2, sp, 0
    call closure_apply
    addi sp, sp, 16
  g_end:
    ld ra, 16(sp)
    ld s0, 8(sp)
    addi sp, sp, 24
    ret
    
    .globl main
    .type main, @function
  main:
    addi sp, sp, -24
    sd ra, 16(sp)
    sd s0, 8(sp)
    addi s0, sp, 24
    addi sp, sp, -80
    li t0, 1
    sd t0, 0(sp)
    li t0, 1
    sd t0, 8(sp)
    li t0, 1
    sd t0, 16(sp)
    li t0, 1
    sd t0, 24(sp)
    li t0, 1
    sd t0, 32(sp)
    li t0, 1
    sd t0, 40(sp)
    li t0, 1
    sd t0, 48(sp)
    li t0, 1
    sd t0, 56(sp)
    li t0, 1
    sd t0, 64(sp)
    li t0, 1
    sd t0, 72(sp)
    li a0, 1
    addi a1, sp, 0
    call g
    addi a0, a0, 0
    li a1, 9
    addi a2, sp, 8
    call closure_apply
    addi sp, sp, 80
    addi t0, a0, 0
    sd t0, -24(s0)
    addi sp, sp, -8
    ld t0, -24(s0)
    sd t0, 0(sp)
    li a0, 1
    addi a1, sp, 0
    call print_int
    addi sp, sp, 8
  main_end:
    ld ra, 16(sp)
    ld s0, 8(sp)
    addi sp, sp, 24
    li a0, 0
    li a7, 93
    ecall

  $ riscv64-linux-gnu-as -march=rv64gc many_args_pam.s -o many_args_pam.o
  $ riscv64-linux-gnu-gcc -static many_args_pam.o -L../../../runtime -l:libruntime.a -o many_args_pam.elf -Wl,--no-warnings
  $ qemu-riscv64 ./many_args_pam.elf
  10

 
