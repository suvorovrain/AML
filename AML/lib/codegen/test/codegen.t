=== task 5 ===
  $ cat >gc1.ml <<EOF
  > let f x y = x + y 
  > let g = f 3
  > let main = let _ = print_gc_status () in let _ = print_int (g 2) in let _ = print_gc_status () in let _ = collect () in let _ = print_gc_status () in 0
  > EOF
  $ ../../../bin/AML.exe gc1.ml gc1.s
  Generated: gc1.s
  $ cat gc1.s
    .text
    .globl llf_0
    .type llf_0, @function
  llf_0:
    addi sp, sp, -32
    sd ra, 24(sp)
    sd s0, 16(sp)
    addi s0, sp, 32
    ld t0, 0(a1)
    sd t0, -24(s0)
    ld t0, 8(a1)
    sd t0, -32(s0)
    ld t0, -24(s0)
    ld t1, -32(s0)
    add a0, t0, t1
    addi a0, a0, -1
    ld ra, 24(sp)
    ld s0, 16(sp)
    addi sp, sp, 32
    ret
    
    .globl llf_1
    .type llf_1, @function
  llf_1:
    addi sp, sp, -32
    sd ra, 24(sp)
    sd s0, 16(sp)
    addi s0, sp, 32
    ld t0, 0(a1)
    sd t0, -24(s0)
    la a0, llf_0
    li a1, 2
    call closure_alloc
    addi t0, a0, 0
    sd t0, -32(s0)
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -8
    ld t0, -24(s0)
    sd t0, 0(sp)
    addi a2, sp, 0
    ld a0, -32(s0)
    li a1, 1
    call closure_apply
    addi sp, sp, 8
    addi sp, sp, 8
    ld ra, 24(sp)
    ld s0, 16(sp)
    addi sp, sp, 32
    ret
    
    .globl f
    .type f, @function
  f:
    addi sp, sp, -16
    sd ra, 8(sp)
    sd s0, 0(sp)
    addi s0, sp, 16
    la a0, llf_1
    li a1, 1
    call closure_alloc
    ld ra, 8(sp)
    ld s0, 0(sp)
    addi sp, sp, 16
    ret
    
    .globl g
    .type g, @function
  g:
    addi sp, sp, -16
    sd ra, 8(sp)
    sd s0, 0(sp)
    addi s0, sp, 16
    addi sp, sp, 0
    addi a1, sp, 0
    li a0, 0
    call f
    addi sp, sp, 0
    addi t3, a0, 0
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -8
    li t0, 7
    sd t0, 0(sp)
    addi a2, sp, 0
    addi a0, t3, 0
    li a1, 1
    call closure_apply
    addi sp, sp, 8
    addi sp, sp, 8
    ld ra, 8(sp)
    ld s0, 0(sp)
    addi sp, sp, 16
    ret
    
    .globl main
    .type main, @function
  main:
    addi sp, sp, -112
    sd ra, 104(sp)
    sd s0, 96(sp)
    addi s0, sp, 112
    call heap_init
    la t0, ML_STACK_BASE
    sd s0, 0(t0)
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -8
    li t0, 1
    sd t0, 0(sp)
    addi a1, sp, 0
    li a0, 1
    call print_gc_status
    addi sp, sp, 8
    addi sp, sp, 8
    addi t0, a0, 0
    sd t0, -24(s0)
    ld t0, -24(s0)
    sd t0, -32(s0)
    addi sp, sp, 0
    addi a1, sp, 0
    li a0, 0
    call g
    addi sp, sp, 0
    addi t3, a0, 0
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -8
    li t0, 5
    sd t0, 0(sp)
    addi a2, sp, 0
    addi a0, t3, 0
    li a1, 1
    call closure_apply
    addi sp, sp, 8
    addi sp, sp, 8
    addi t0, a0, 0
    sd t0, -40(s0)
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -8
    ld t0, -40(s0)
    sd t0, 0(sp)
    addi a1, sp, 0
    li a0, 1
    call print_int
    addi sp, sp, 8
    addi sp, sp, 8
    addi t0, a0, 0
    sd t0, -48(s0)
    ld t0, -48(s0)
    sd t0, -56(s0)
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -8
    li t0, 1
    sd t0, 0(sp)
    addi a1, sp, 0
    li a0, 1
    call print_gc_status
    addi sp, sp, 8
    addi sp, sp, 8
    addi t0, a0, 0
    sd t0, -64(s0)
    ld t0, -64(s0)
    sd t0, -72(s0)
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -8
    li t0, 1
    sd t0, 0(sp)
    addi a1, sp, 0
    li a0, 1
    call collect
    addi sp, sp, 8
    addi sp, sp, 8
    addi t0, a0, 0
    sd t0, -80(s0)
    ld t0, -80(s0)
    sd t0, -88(s0)
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -8
    li t0, 1
    sd t0, 0(sp)
    addi a1, sp, 0
    li a0, 1
    call print_gc_status
    addi sp, sp, 8
    addi sp, sp, 8
    addi t0, a0, 0
    sd t0, -96(s0)
    ld t0, -96(s0)
    sd t0, -104(s0)
    li a0, 1
    ld ra, 104(sp)
    ld s0, 96(sp)
    addi sp, sp, 112
    li a0, 0
    li a7, 93
    ecall
  $ riscv64-linux-gnu-as -march=rv64gc gc1.s -o gc1.o
  $ riscv64-linux-gnu-gcc -static gc1.o -L../../../runtime -l:libruntime.a -o gc1.elf -Wl,--no-warnings
  $ qemu-riscv64 ./gc1.elf
   
  === GC STATUS ===
  old space start:  0x19a320
  old space end:    0x29a320
  alloc pointer:    0x19a320
  new space start:  0x29a320
  heap size: 1048576 bytes
  used (old space): 0 bytes
  collects count: 0
  allocations in total: 0 bytes
  =================
  5 
  === GC STATUS ===
  old space start:  0x19a320
  old space end:    0x29a320
  alloc pointer:    0x19a388
  new space start:  0x29a320
  heap size: 1048576 bytes
  used (old space): 104 bytes
  collects count: 0
  allocations in total: 104 bytes
  =================
   
  === GC STATUS ===
  old space start:  0x29a320
  old space end:    0x39a320
  alloc pointer:    0x29a320
  new space start:  0x19a320
  heap size: 1048576 bytes
  used (old space): 0 bytes
  collects count: 1
  allocations in total: 104 bytes
  =================


  $ cat >gc2.ml <<EOF
  > let f x y = x + y 
  > let g = f 3
  > let main = 
  >   let _ = print_gc_status () in 
  > 
  >   let g = f 3 in 
  >   let _ = print_gc_status () in 
  > 
  >   let _ = collect () in
  >   let _ = print_gc_status () in
  > 
  >   let _ = print_int (g 2) in
  > 
  >   let _ = print_gc_status () in
  > 0
  > EOF
  $ ../../../bin/AML.exe gc2.ml gc2.s
  Generated: gc2.s
  $ cat gc2.s
    .text
    .globl llf_0
    .type llf_0, @function
  llf_0:
    addi sp, sp, -32
    sd ra, 24(sp)
    sd s0, 16(sp)
    addi s0, sp, 32
    ld t0, 0(a1)
    sd t0, -24(s0)
    ld t0, 8(a1)
    sd t0, -32(s0)
    ld t0, -24(s0)
    ld t1, -32(s0)
    add a0, t0, t1
    addi a0, a0, -1
    ld ra, 24(sp)
    ld s0, 16(sp)
    addi sp, sp, 32
    ret
    
    .globl llf_1
    .type llf_1, @function
  llf_1:
    addi sp, sp, -32
    sd ra, 24(sp)
    sd s0, 16(sp)
    addi s0, sp, 32
    ld t0, 0(a1)
    sd t0, -24(s0)
    la a0, llf_0
    li a1, 2
    call closure_alloc
    addi t0, a0, 0
    sd t0, -32(s0)
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -8
    ld t0, -24(s0)
    sd t0, 0(sp)
    addi a2, sp, 0
    ld a0, -32(s0)
    li a1, 1
    call closure_apply
    addi sp, sp, 8
    addi sp, sp, 8
    ld ra, 24(sp)
    ld s0, 16(sp)
    addi sp, sp, 32
    ret
    
    .globl f
    .type f, @function
  f:
    addi sp, sp, -16
    sd ra, 8(sp)
    sd s0, 0(sp)
    addi s0, sp, 16
    la a0, llf_1
    li a1, 1
    call closure_alloc
    ld ra, 8(sp)
    ld s0, 0(sp)
    addi sp, sp, 16
    ret
    
    .globl g
    .type g, @function
  g:
    addi sp, sp, -16
    sd ra, 8(sp)
    sd s0, 0(sp)
    addi s0, sp, 16
    addi sp, sp, 0
    addi a1, sp, 0
    li a0, 0
    call f
    addi sp, sp, 0
    addi t3, a0, 0
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -8
    li t0, 7
    sd t0, 0(sp)
    addi a2, sp, 0
    addi a0, t3, 0
    li a1, 1
    call closure_apply
    addi sp, sp, 8
    addi sp, sp, 8
    ld ra, 8(sp)
    ld s0, 0(sp)
    addi sp, sp, 16
    ret
    
    .globl main
    .type main, @function
  main:
    addi sp, sp, -144
    sd ra, 136(sp)
    sd s0, 128(sp)
    addi s0, sp, 144
    call heap_init
    la t0, ML_STACK_BASE
    sd s0, 0(t0)
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -8
    li t0, 1
    sd t0, 0(sp)
    addi a1, sp, 0
    li a0, 1
    call print_gc_status
    addi sp, sp, 8
    addi sp, sp, 8
    addi t0, a0, 0
    sd t0, -24(s0)
    ld t0, -24(s0)
    sd t0, -32(s0)
    addi sp, sp, 0
    addi a1, sp, 0
    li a0, 0
    call f
    addi sp, sp, 0
    addi t3, a0, 0
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -8
    li t0, 7
    sd t0, 0(sp)
    addi a2, sp, 0
    addi a0, t3, 0
    li a1, 1
    call closure_apply
    addi sp, sp, 8
    addi sp, sp, 8
    addi t0, a0, 0
    sd t0, -40(s0)
    ld t0, -40(s0)
    sd t0, -48(s0)
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -8
    li t0, 1
    sd t0, 0(sp)
    addi a1, sp, 0
    li a0, 1
    call print_gc_status
    addi sp, sp, 8
    addi sp, sp, 8
    addi t0, a0, 0
    sd t0, -56(s0)
    ld t0, -56(s0)
    sd t0, -64(s0)
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -8
    li t0, 1
    sd t0, 0(sp)
    addi a1, sp, 0
    li a0, 1
    call collect
    addi sp, sp, 8
    addi sp, sp, 8
    addi t0, a0, 0
    sd t0, -72(s0)
    ld t0, -72(s0)
    sd t0, -80(s0)
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -8
    li t0, 1
    sd t0, 0(sp)
    addi a1, sp, 0
    li a0, 1
    call print_gc_status
    addi sp, sp, 8
    addi sp, sp, 8
    addi t0, a0, 0
    sd t0, -88(s0)
    ld t0, -88(s0)
    sd t0, -96(s0)
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -8
    li t0, 5
    sd t0, 0(sp)
    addi a2, sp, 0
    ld a0, -48(s0)
    li a1, 1
    call closure_apply
    addi sp, sp, 8
    addi sp, sp, 8
    addi t0, a0, 0
    sd t0, -104(s0)
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -8
    ld t0, -104(s0)
    sd t0, 0(sp)
    addi a1, sp, 0
    li a0, 1
    call print_int
    addi sp, sp, 8
    addi sp, sp, 8
    addi t0, a0, 0
    sd t0, -112(s0)
    ld t0, -112(s0)
    sd t0, -120(s0)
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -8
    li t0, 1
    sd t0, 0(sp)
    addi a1, sp, 0
    li a0, 1
    call print_gc_status
    addi sp, sp, 8
    addi sp, sp, 8
    addi t0, a0, 0
    sd t0, -128(s0)
    ld t0, -128(s0)
    sd t0, -136(s0)
    li a0, 1
    ld ra, 136(sp)
    ld s0, 128(sp)
    addi sp, sp, 144
    li a0, 0
    li a7, 93
    ecall
  $ riscv64-linux-gnu-as -march=rv64gc gc2.s -o gc2.o
  $ riscv64-linux-gnu-gcc -static gc2.o -L../../../runtime -l:libruntime.a -o gc2.elf -Wl,--no-warnings
  $ qemu-riscv64 ./gc2.elf
   
  === GC STATUS ===
  old space start:  0x19a320
  old space end:    0x29a320
  alloc pointer:    0x19a320
  new space start:  0x29a320
  heap size: 1048576 bytes
  used (old space): 0 bytes
  collects count: 0
  allocations in total: 0 bytes
  =================
   
  === GC STATUS ===
  old space start:  0x19a320
  old space end:    0x29a320
  alloc pointer:    0x19a388
  new space start:  0x29a320
  heap size: 1048576 bytes
  used (old space): 104 bytes
  collects count: 0
  allocations in total: 104 bytes
  =================
   
  === GC STATUS ===
  old space start:  0x29a320
  old space end:    0x39a320
  alloc pointer:    0x29a348
  new space start:  0x19a320
  heap size: 1048576 bytes
  used (old space): 40 bytes
  collects count: 1
  allocations in total: 104 bytes
  =================
  5 
  === GC STATUS ===
  old space start:  0x29a320
  old space end:    0x39a320
  alloc pointer:    0x29a348
  new space start:  0x19a320
  heap size: 1048576 bytes
  used (old space): 40 bytes
  collects count: 1
  allocations in total: 104 bytes
  =================

=== task 4 ===
  $ ../../../bin/AML.exe ./manytests/typed/012fibcps.ml fibcps.s
  Generated: fibcps.s
  $ cat fibcps.s
    .text
    .globl llf_0
    .type llf_0, @function
  llf_0:
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
    addi t0, t0, -1
    sd t0, -48(s0)
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -8
    ld t0, -48(s0)
    sd t0, 0(sp)
    addi a2, sp, 0
    ld a0, -32(s0)
    li a1, 1
    call closure_apply
    addi sp, sp, 8
    addi sp, sp, 8
    ld ra, 40(sp)
    ld s0, 32(sp)
    addi sp, sp, 48
    ret
    
    .globl llf_1
    .type llf_1, @function
  llf_1:
    addi sp, sp, -80
    sd ra, 72(sp)
    sd s0, 64(sp)
    addi s0, sp, 80
    ld t0, 0(a1)
    sd t0, -24(s0)
    ld t0, 8(a1)
    sd t0, -32(s0)
    ld t0, 16(a1)
    sd t0, -40(s0)
    ld t0, 24(a1)
    sd t0, -48(s0)
    ld t0, -40(s0)
    li t1, 5
    sub t0, t0, t1
    addi t0, t0, 1
    sd t0, -56(s0)
    la a0, llf_0
    li a1, 3
    call closure_alloc
    addi t0, a0, 0
    sd t0, -64(s0)
    addi sp, sp, -16
    ld t0, -48(s0)
    sd t0, 0(sp)
    ld t0, -32(s0)
    sd t0, 8(sp)
    addi a2, sp, 0
    ld a0, -64(s0)
    li a1, 2
    call closure_apply
    addi sp, sp, 16
    addi t0, a0, 0
    sd t0, -72(s0)
    addi sp, sp, -16
    ld t0, -56(s0)
    sd t0, 0(sp)
    ld t0, -72(s0)
    sd t0, 8(sp)
    addi a2, sp, 0
    ld a0, -24(s0)
    li a1, 2
    call closure_apply
    addi sp, sp, 16
    ld ra, 72(sp)
    ld s0, 64(sp)
    addi sp, sp, 80
    ret
    
    .globl llf_2
    .type llf_2, @function
  llf_2:
    addi sp, sp, -80
    sd ra, 72(sp)
    sd s0, 64(sp)
    addi s0, sp, 80
    ld t0, 0(a1)
    sd t0, -24(s0)
    ld t0, 8(a1)
    sd t0, -32(s0)
    ld t0, 16(a1)
    sd t0, -40(s0)
    ld t0, -32(s0)
    li t1, 5
    slt t0, t0, t1
    slli t0, t0, 1
    addi t0, t0, 1
    sd t0, -48(s0)
    ld t0, -48(s0)
    li t1, 1
    beq t0, t1, .Lelse_0
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -8
    ld t0, -32(s0)
    sd t0, 0(sp)
    addi a2, sp, 0
    ld a0, -40(s0)
    li a1, 1
    call closure_apply
    addi sp, sp, 8
    addi sp, sp, 8
    j .Lendif_1
  .Lelse_0:
    ld t0, -32(s0)
    li t1, 3
    sub t0, t0, t1
    addi t0, t0, 1
    sd t0, -56(s0)
    la a0, llf_1
    li a1, 4
    call closure_alloc
    addi t0, a0, 0
    sd t0, -64(s0)
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -24
    ld t0, -24(s0)
    sd t0, 0(sp)
    ld t0, -40(s0)
    sd t0, 8(sp)
    ld t0, -32(s0)
    sd t0, 16(sp)
    addi a2, sp, 0
    ld a0, -64(s0)
    li a1, 3
    call closure_apply
    addi sp, sp, 24
    addi sp, sp, 8
    addi t0, a0, 0
    sd t0, -72(s0)
    addi sp, sp, -16
    ld t0, -56(s0)
    sd t0, 0(sp)
    ld t0, -72(s0)
    sd t0, 8(sp)
    addi a2, sp, 0
    ld a0, -24(s0)
    li a1, 2
    call closure_apply
    addi sp, sp, 16
  .Lendif_1:
    ld ra, 72(sp)
    ld s0, 64(sp)
    addi sp, sp, 80
    ret
    
    .globl llf_3
    .type llf_3, @function
  llf_3:
    addi sp, sp, -32
    sd ra, 24(sp)
    sd s0, 16(sp)
    addi s0, sp, 32
    ld t0, 0(a1)
    sd t0, -24(s0)
    la a0, llf_2
    li a1, 3
    call closure_alloc
    addi t0, a0, 0
    sd t0, -32(s0)
    addi sp, sp, -16
    la a0, fib
    li a1, 0
    call closure_alloc
    addi t0, a0, 0
    sd t0, 0(sp)
    ld t0, -24(s0)
    sd t0, 8(sp)
    addi a2, sp, 0
    ld a0, -32(s0)
    li a1, 2
    call closure_apply
    addi sp, sp, 16
    ld ra, 24(sp)
    ld s0, 16(sp)
    addi sp, sp, 32
    ret
    
    .globl llf_4
    .type llf_4, @function
  llf_4:
    addi sp, sp, -32
    sd ra, 24(sp)
    sd s0, 16(sp)
    addi s0, sp, 32
    ld t0, 0(a1)
    sd t0, -24(s0)
    ld a0, -24(s0)
    ld ra, 24(sp)
    ld s0, 16(sp)
    addi sp, sp, 32
    ret
    
    .globl fib
    .type fib, @function
  fib:
    addi sp, sp, -16
    sd ra, 8(sp)
    sd s0, 0(sp)
    addi s0, sp, 16
    la a0, llf_3
    li a1, 1
    call closure_alloc
    ld ra, 8(sp)
    ld s0, 0(sp)
    addi sp, sp, 16
    ret
    
    .globl main
    .type main, @function
  main:
    addi sp, sp, -32
    sd ra, 24(sp)
    sd s0, 16(sp)
    addi s0, sp, 32
    call heap_init
    la t0, ML_STACK_BASE
    sd s0, 0(t0)
    la a0, llf_4
    li a1, 1
    call closure_alloc
    addi t0, a0, 0
    sd t0, -24(s0)
    addi sp, sp, 0
    addi a1, sp, 0
    li a0, 0
    call fib
    addi sp, sp, 0
    addi t3, a0, 0
    addi sp, sp, -16
    li t0, 13
    sd t0, 0(sp)
    ld t0, -24(s0)
    sd t0, 8(sp)
    addi a2, sp, 0
    addi a0, t3, 0
    li a1, 2
    call closure_apply
    addi sp, sp, 16
    addi t0, a0, 0
    sd t0, -32(s0)
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -8
    ld t0, -32(s0)
    sd t0, 0(sp)
    addi a1, sp, 0
    li a0, 1
    call print_int
    addi sp, sp, 8
    addi sp, sp, 8
    ld ra, 24(sp)
    ld s0, 16(sp)
    addi sp, sp, 32
    li a0, 0
    li a7, 93
    ecall
  $ riscv64-linux-gnu-as -march=rv64gc fibcps.s -o fibcps.o
  $ riscv64-linux-gnu-gcc -static fibcps.o -L../../../runtime -l:libruntime.a -o fibcps.elf -Wl,--no-warnings
  $ qemu-riscv64 ./fibcps.elf
  8
 
  $ ../../../bin/AML.exe ./manytests/typed/012faccps.ml faccps.s
  Generated: faccps.s
$ cat faccps.s
  $ riscv64-linux-gnu-as -march=rv64gc faccps.s -o faccps.o
  $ riscv64-linux-gnu-gcc -static faccps.o -L../../../runtime -l:libruntime.a -o faccps.elf -Wl,--no-warnings
  $ qemu-riscv64 ./faccps.elf
  720

  $ ../../../bin/AML.exe ./manytests/typed/004manyargs.ml many.s
  Generated: many.s
  $ cat many.s
    .text
    .globl llf_0
    .type llf_0, @function
  llf_0:
    addi sp, sp, -32
    sd ra, 24(sp)
    sd s0, 16(sp)
    addi s0, sp, 32
    ld t0, 0(a1)
    sd t0, -24(s0)
    li t0, 3
    li t1, 3
    sub t2, t0, t1
    slt t0, x0, t2
    slt t3, t2, x0
    add t0, t0, t3
    xori t0, t0, 1
    slli t0, t0, 1
    addi t0, t0, 1
    sd t0, -32(s0)
    ld t0, -32(s0)
    li t1, 1
    beq t0, t1, .Lelse_0
    ld a0, -24(s0)
    j .Lendif_1
  .Lelse_0:
    ld a0, -24(s0)
  .Lendif_1:
    ld ra, 24(sp)
    ld s0, 16(sp)
    addi sp, sp, 32
    ret
    
    .globl llf_1
    .type llf_1, @function
  llf_1:
    addi sp, sp, -96
    sd ra, 88(sp)
    sd s0, 80(sp)
    addi s0, sp, 96
    ld t0, 0(a1)
    sd t0, -24(s0)
    ld t0, 8(a1)
    sd t0, -32(s0)
    ld t0, 16(a1)
    sd t0, -40(s0)
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -8
    ld t0, -24(s0)
    sd t0, 0(sp)
    addi a1, sp, 0
    li a0, 1
    call print_int
    addi sp, sp, 8
    addi sp, sp, 8
    addi t0, a0, 0
    sd t0, -48(s0)
    ld t0, -48(s0)
    sd t0, -56(s0)
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -8
    ld t0, -32(s0)
    sd t0, 0(sp)
    addi a1, sp, 0
    li a0, 1
    call print_int
    addi sp, sp, 8
    addi sp, sp, 8
    addi t0, a0, 0
    sd t0, -64(s0)
    ld t0, -64(s0)
    sd t0, -72(s0)
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -8
    ld t0, -40(s0)
    sd t0, 0(sp)
    addi a1, sp, 0
    li a0, 1
    call print_int
    addi sp, sp, 8
    addi sp, sp, 8
    addi t0, a0, 0
    sd t0, -80(s0)
    ld t0, -80(s0)
    sd t0, -88(s0)
    li a0, 1
    ld ra, 88(sp)
    ld s0, 80(sp)
    addi sp, sp, 96
    ret
    
    .globl llf_2
    .type llf_2, @function
  llf_2:
    addi sp, sp, -48
    sd ra, 40(sp)
    sd s0, 32(sp)
    addi s0, sp, 48
    ld t0, 0(a1)
    sd t0, -24(s0)
    ld t0, 8(a1)
    sd t0, -32(s0)
    la a0, llf_1
    li a1, 3
    call closure_alloc
    addi t0, a0, 0
    sd t0, -40(s0)
    addi sp, sp, -16
    ld t0, -24(s0)
    sd t0, 0(sp)
    ld t0, -32(s0)
    sd t0, 8(sp)
    addi a2, sp, 0
    ld a0, -40(s0)
    li a1, 2
    call closure_apply
    addi sp, sp, 16
    ld ra, 40(sp)
    ld s0, 32(sp)
    addi sp, sp, 48
    ret
    
    .globl llf_3
    .type llf_3, @function
  llf_3:
    addi sp, sp, -32
    sd ra, 24(sp)
    sd s0, 16(sp)
    addi s0, sp, 32
    ld t0, 0(a1)
    sd t0, -24(s0)
    la a0, llf_2
    li a1, 2
    call closure_alloc
    addi t0, a0, 0
    sd t0, -32(s0)
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -8
    ld t0, -24(s0)
    sd t0, 0(sp)
    addi a2, sp, 0
    ld a0, -32(s0)
    li a1, 1
    call closure_apply
    addi sp, sp, 8
    addi sp, sp, 8
    ld ra, 24(sp)
    ld s0, 16(sp)
    addi sp, sp, 32
    ret
    
    .globl llf_4
    .type llf_4, @function
  llf_4:
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
    addi t0, t0, -1
    sd t0, -104(s0)
    ld t0, -104(s0)
    ld t1, -40(s0)
    add t0, t0, t1
    addi t0, t0, -1
    sd t0, -112(s0)
    ld t0, -112(s0)
    ld t1, -48(s0)
    add t0, t0, t1
    addi t0, t0, -1
    sd t0, -120(s0)
    ld t0, -120(s0)
    ld t1, -56(s0)
    add t0, t0, t1
    addi t0, t0, -1
    sd t0, -128(s0)
    ld t0, -128(s0)
    ld t1, -64(s0)
    add t0, t0, t1
    addi t0, t0, -1
    sd t0, -136(s0)
    ld t0, -136(s0)
    ld t1, -72(s0)
    add t0, t0, t1
    addi t0, t0, -1
    sd t0, -144(s0)
    ld t0, -144(s0)
    ld t1, -80(s0)
    add t0, t0, t1
    addi t0, t0, -1
    sd t0, -152(s0)
    ld t0, -152(s0)
    ld t1, -88(s0)
    add t0, t0, t1
    addi t0, t0, -1
    sd t0, -160(s0)
    ld t0, -160(s0)
    ld t1, -96(s0)
    add a0, t0, t1
    addi a0, a0, -1
    ld ra, 152(sp)
    ld s0, 144(sp)
    addi sp, sp, 160
    ret
    
    .globl llf_5
    .type llf_5, @function
  llf_5:
    addi sp, sp, -96
    sd ra, 88(sp)
    sd s0, 80(sp)
    addi s0, sp, 96
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
    la a0, llf_4
    li a1, 10
    call closure_alloc
    addi t0, a0, 0
    sd t0, -96(s0)
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -72
    ld t0, -24(s0)
    sd t0, 0(sp)
    ld t0, -32(s0)
    sd t0, 8(sp)
    ld t0, -40(s0)
    sd t0, 16(sp)
    ld t0, -48(s0)
    sd t0, 24(sp)
    ld t0, -56(s0)
    sd t0, 32(sp)
    ld t0, -64(s0)
    sd t0, 40(sp)
    ld t0, -72(s0)
    sd t0, 48(sp)
    ld t0, -80(s0)
    sd t0, 56(sp)
    ld t0, -88(s0)
    sd t0, 64(sp)
    addi a2, sp, 0
    ld a0, -96(s0)
    li a1, 9
    call closure_apply
    addi sp, sp, 72
    addi sp, sp, 8
    ld ra, 88(sp)
    ld s0, 80(sp)
    addi sp, sp, 96
    ret
    
    .globl llf_6
    .type llf_6, @function
  llf_6:
    addi sp, sp, -96
    sd ra, 88(sp)
    sd s0, 80(sp)
    addi s0, sp, 96
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
    la a0, llf_5
    li a1, 9
    call closure_alloc
    addi t0, a0, 0
    sd t0, -88(s0)
    addi sp, sp, -64
    ld t0, -24(s0)
    sd t0, 0(sp)
    ld t0, -32(s0)
    sd t0, 8(sp)
    ld t0, -40(s0)
    sd t0, 16(sp)
    ld t0, -48(s0)
    sd t0, 24(sp)
    ld t0, -56(s0)
    sd t0, 32(sp)
    ld t0, -64(s0)
    sd t0, 40(sp)
    ld t0, -72(s0)
    sd t0, 48(sp)
    ld t0, -80(s0)
    sd t0, 56(sp)
    addi a2, sp, 0
    ld a0, -88(s0)
    li a1, 8
    call closure_apply
    addi sp, sp, 64
    ld ra, 88(sp)
    ld s0, 80(sp)
    addi sp, sp, 96
    ret
    
    .globl llf_7
    .type llf_7, @function
  llf_7:
    addi sp, sp, -80
    sd ra, 72(sp)
    sd s0, 64(sp)
    addi s0, sp, 80
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
    la a0, llf_6
    li a1, 8
    call closure_alloc
    addi t0, a0, 0
    sd t0, -80(s0)
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -56
    ld t0, -24(s0)
    sd t0, 0(sp)
    ld t0, -32(s0)
    sd t0, 8(sp)
    ld t0, -40(s0)
    sd t0, 16(sp)
    ld t0, -48(s0)
    sd t0, 24(sp)
    ld t0, -56(s0)
    sd t0, 32(sp)
    ld t0, -64(s0)
    sd t0, 40(sp)
    ld t0, -72(s0)
    sd t0, 48(sp)
    addi a2, sp, 0
    ld a0, -80(s0)
    li a1, 7
    call closure_apply
    addi sp, sp, 56
    addi sp, sp, 8
    ld ra, 72(sp)
    ld s0, 64(sp)
    addi sp, sp, 80
    ret
    
    .globl llf_8
    .type llf_8, @function
  llf_8:
    addi sp, sp, -80
    sd ra, 72(sp)
    sd s0, 64(sp)
    addi s0, sp, 80
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
    la a0, llf_7
    li a1, 7
    call closure_alloc
    addi t0, a0, 0
    sd t0, -72(s0)
    addi sp, sp, -48
    ld t0, -24(s0)
    sd t0, 0(sp)
    ld t0, -32(s0)
    sd t0, 8(sp)
    ld t0, -40(s0)
    sd t0, 16(sp)
    ld t0, -48(s0)
    sd t0, 24(sp)
    ld t0, -56(s0)
    sd t0, 32(sp)
    ld t0, -64(s0)
    sd t0, 40(sp)
    addi a2, sp, 0
    ld a0, -72(s0)
    li a1, 6
    call closure_apply
    addi sp, sp, 48
    ld ra, 72(sp)
    ld s0, 64(sp)
    addi sp, sp, 80
    ret
    
    .globl llf_9
    .type llf_9, @function
  llf_9:
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
    ld t0, 32(a1)
    sd t0, -56(s0)
    la a0, llf_8
    li a1, 6
    call closure_alloc
    addi t0, a0, 0
    sd t0, -64(s0)
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -40
    ld t0, -24(s0)
    sd t0, 0(sp)
    ld t0, -32(s0)
    sd t0, 8(sp)
    ld t0, -40(s0)
    sd t0, 16(sp)
    ld t0, -48(s0)
    sd t0, 24(sp)
    ld t0, -56(s0)
    sd t0, 32(sp)
    addi a2, sp, 0
    ld a0, -64(s0)
    li a1, 5
    call closure_apply
    addi sp, sp, 40
    addi sp, sp, 8
    ld ra, 56(sp)
    ld s0, 48(sp)
    addi sp, sp, 64
    ret
    
    .globl llf_10
    .type llf_10, @function
  llf_10:
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
    la a0, llf_9
    li a1, 5
    call closure_alloc
    addi t0, a0, 0
    sd t0, -56(s0)
    addi sp, sp, -32
    ld t0, -24(s0)
    sd t0, 0(sp)
    ld t0, -32(s0)
    sd t0, 8(sp)
    ld t0, -40(s0)
    sd t0, 16(sp)
    ld t0, -48(s0)
    sd t0, 24(sp)
    addi a2, sp, 0
    ld a0, -56(s0)
    li a1, 4
    call closure_apply
    addi sp, sp, 32
    ld ra, 56(sp)
    ld s0, 48(sp)
    addi sp, sp, 64
    ret
    
    .globl llf_11
    .type llf_11, @function
  llf_11:
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
    la a0, llf_10
    li a1, 4
    call closure_alloc
    addi t0, a0, 0
    sd t0, -48(s0)
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -24
    ld t0, -24(s0)
    sd t0, 0(sp)
    ld t0, -32(s0)
    sd t0, 8(sp)
    ld t0, -40(s0)
    sd t0, 16(sp)
    addi a2, sp, 0
    ld a0, -48(s0)
    li a1, 3
    call closure_apply
    addi sp, sp, 24
    addi sp, sp, 8
    ld ra, 40(sp)
    ld s0, 32(sp)
    addi sp, sp, 48
    ret
    
    .globl llf_12
    .type llf_12, @function
  llf_12:
    addi sp, sp, -48
    sd ra, 40(sp)
    sd s0, 32(sp)
    addi s0, sp, 48
    ld t0, 0(a1)
    sd t0, -24(s0)
    ld t0, 8(a1)
    sd t0, -32(s0)
    la a0, llf_11
    li a1, 3
    call closure_alloc
    addi t0, a0, 0
    sd t0, -40(s0)
    addi sp, sp, -16
    ld t0, -24(s0)
    sd t0, 0(sp)
    ld t0, -32(s0)
    sd t0, 8(sp)
    addi a2, sp, 0
    ld a0, -40(s0)
    li a1, 2
    call closure_apply
    addi sp, sp, 16
    ld ra, 40(sp)
    ld s0, 32(sp)
    addi sp, sp, 48
    ret
    
    .globl llf_13
    .type llf_13, @function
  llf_13:
    addi sp, sp, -32
    sd ra, 24(sp)
    sd s0, 16(sp)
    addi s0, sp, 32
    ld t0, 0(a1)
    sd t0, -24(s0)
    la a0, llf_12
    li a1, 2
    call closure_alloc
    addi t0, a0, 0
    sd t0, -32(s0)
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -8
    ld t0, -24(s0)
    sd t0, 0(sp)
    addi a2, sp, 0
    ld a0, -32(s0)
    li a1, 1
    call closure_apply
    addi sp, sp, 8
    addi sp, sp, 8
    ld ra, 24(sp)
    ld s0, 16(sp)
    addi sp, sp, 32
    ret
    
    .globl wrap
    .type wrap, @function
  wrap:
    addi sp, sp, -16
    sd ra, 8(sp)
    sd s0, 0(sp)
    addi s0, sp, 16
    la a0, llf_0
    li a1, 1
    call closure_alloc
    ld ra, 8(sp)
    ld s0, 0(sp)
    addi sp, sp, 16
    ret
    
    .globl test3
    .type test3, @function
  test3:
    addi sp, sp, -16
    sd ra, 8(sp)
    sd s0, 0(sp)
    addi s0, sp, 16
    la a0, llf_3
    li a1, 1
    call closure_alloc
    ld ra, 8(sp)
    ld s0, 0(sp)
    addi sp, sp, 16
    ret
    
    .globl test10
    .type test10, @function
  test10:
    addi sp, sp, -16
    sd ra, 8(sp)
    sd s0, 0(sp)
    addi s0, sp, 16
    la a0, llf_13
    li a1, 1
    call closure_alloc
    ld ra, 8(sp)
    ld s0, 0(sp)
    addi sp, sp, 16
    ret
    
    .globl main
    .type main, @function
  main:
    addi sp, sp, -64
    sd ra, 56(sp)
    sd s0, 48(sp)
    addi s0, sp, 64
    call heap_init
    la t0, ML_STACK_BASE
    sd s0, 0(t0)
    addi sp, sp, 0
    addi a1, sp, 0
    li a0, 0
    call wrap
    addi sp, sp, 0
    addi t3, a0, 0
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -88
    la a0, test10
    li a1, 0
    call closure_alloc
    addi t0, a0, 0
    sd t0, 0(sp)
    li t0, 3
    sd t0, 8(sp)
    li t0, 21
    sd t0, 16(sp)
    li t0, 201
    sd t0, 24(sp)
    li t0, 2001
    sd t0, 32(sp)
    li t0, 20001
    sd t0, 40(sp)
    li t0, 200001
    sd t0, 48(sp)
    li t0, 2000001
    sd t0, 56(sp)
    li t0, 20000001
    sd t0, 64(sp)
    li t0, 200000001
    sd t0, 72(sp)
    li t0, 2000000001
    sd t0, 80(sp)
    addi a2, sp, 0
    addi a0, t3, 0
    li a1, 11
    call closure_apply
    addi sp, sp, 88
    addi sp, sp, 8
    addi t0, a0, 0
    sd t0, -24(s0)
    ld t0, -24(s0)
    sd t0, -32(s0)
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -8
    ld t0, -32(s0)
    sd t0, 0(sp)
    addi a1, sp, 0
    li a0, 1
    call print_int
    addi sp, sp, 8
    addi sp, sp, 8
    addi t0, a0, 0
    sd t0, -40(s0)
    ld t0, -40(s0)
    sd t0, -48(s0)
    addi sp, sp, 0
    addi a1, sp, 0
    li a0, 0
    call wrap
    addi sp, sp, 0
    addi t3, a0, 0
    addi sp, sp, -32
    la a0, test3
    li a1, 0
    call closure_alloc
    addi t0, a0, 0
    sd t0, 0(sp)
    li t0, 3
    sd t0, 8(sp)
    li t0, 21
    sd t0, 16(sp)
    li t0, 201
    sd t0, 24(sp)
    addi a2, sp, 0
    addi a0, t3, 0
    li a1, 4
    call closure_apply
    addi sp, sp, 32
    addi t0, a0, 0
    sd t0, -56(s0)
    ld t0, -56(s0)
    sd t0, -64(s0)
    li a0, 1
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

== task 3 ==
  $ ../../../bin/AML.exe ./manytests/typed/010faccps_ll.ml faccps.s
  Generated: faccps.s
  $ cat faccps.s
    .text
    .globl llf_0
    .type llf_0, @function
  llf_0:
    addi sp, sp, -32
    sd ra, 24(sp)
    sd s0, 16(sp)
    addi s0, sp, 32
    ld t0, 0(a1)
    sd t0, -24(s0)
    ld a0, -24(s0)
    ld ra, 24(sp)
    ld s0, 16(sp)
    addi sp, sp, 32
    ret
    
    .globl llf_1
    .type llf_1, @function
  llf_1:
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
    ld t1, -32(s0)
    srai t2, t0, 1
    srai t3, t1, 1
    mul t0, t2, t3
    slli t0, t0, 1
    addi t0, t0, 1
    sd t0, -48(s0)
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -8
    ld t0, -48(s0)
    sd t0, 0(sp)
    addi a2, sp, 0
    ld a0, -24(s0)
    li a1, 1
    call closure_apply
    addi sp, sp, 8
    addi sp, sp, 8
    ld ra, 40(sp)
    ld s0, 32(sp)
    addi sp, sp, 48
    ret
    
    .globl llf_2
    .type llf_2, @function
  llf_2:
    addi sp, sp, -48
    sd ra, 40(sp)
    sd s0, 32(sp)
    addi s0, sp, 48
    ld t0, 0(a1)
    sd t0, -24(s0)
    ld t0, 8(a1)
    sd t0, -32(s0)
    la a0, llf_1
    li a1, 3
    call closure_alloc
    addi t0, a0, 0
    sd t0, -40(s0)
    addi sp, sp, -16
    ld t0, -32(s0)
    sd t0, 0(sp)
    ld t0, -24(s0)
    sd t0, 8(sp)
    addi a2, sp, 0
    ld a0, -40(s0)
    li a1, 2
    call closure_apply
    addi sp, sp, 16
    ld ra, 40(sp)
    ld s0, 32(sp)
    addi sp, sp, 48
    ret
    
    .globl llf_3
    .type llf_3, @function
  llf_3:
    addi sp, sp, -32
    sd ra, 24(sp)
    sd s0, 16(sp)
    addi s0, sp, 32
    ld t0, 0(a1)
    sd t0, -24(s0)
    la a0, llf_2
    li a1, 2
    call closure_alloc
    addi t0, a0, 0
    sd t0, -32(s0)
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -8
    ld t0, -24(s0)
    sd t0, 0(sp)
    addi a2, sp, 0
    ld a0, -32(s0)
    li a1, 1
    call closure_apply
    addi sp, sp, 8
    addi sp, sp, 8
    ld ra, 24(sp)
    ld s0, 16(sp)
    addi sp, sp, 32
    ret
    
    .globl llf_4
    .type llf_4, @function
  llf_4:
    addi sp, sp, -80
    sd ra, 72(sp)
    sd s0, 64(sp)
    addi s0, sp, 80
    ld t0, 0(a1)
    sd t0, -24(s0)
    ld t0, 8(a1)
    sd t0, -32(s0)
    ld t0, 16(a1)
    sd t0, -40(s0)
    ld t0, 24(a1)
    sd t0, -48(s0)
    ld t0, -40(s0)
    li t1, 3
    sub t2, t0, t1
    slt t0, x0, t2
    slt t3, t2, x0
    add t0, t0, t3
    xori t0, t0, 1
    slli t0, t0, 1
    addi t0, t0, 1
    sd t0, -56(s0)
    ld t0, -56(s0)
    li t1, 1
    beq t0, t1, .Lelse_0
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -8
    li t0, 3
    sd t0, 0(sp)
    addi a2, sp, 0
    ld a0, -48(s0)
    li a1, 1
    call closure_apply
    addi sp, sp, 8
    addi sp, sp, 8
    j .Lendif_1
  .Lelse_0:
    ld t0, -40(s0)
    li t1, 3
    sub t0, t0, t1
    addi t0, t0, 1
    sd t0, -64(s0)
    addi sp, sp, -16
    ld t0, -40(s0)
    sd t0, 0(sp)
    ld t0, -48(s0)
    sd t0, 8(sp)
    addi a2, sp, 0
    ld a0, -32(s0)
    li a1, 2
    call closure_apply
    addi sp, sp, 16
    addi t0, a0, 0
    sd t0, -72(s0)
    addi sp, sp, -16
    ld t0, -64(s0)
    sd t0, 0(sp)
    ld t0, -72(s0)
    sd t0, 8(sp)
    addi a2, sp, 0
    ld a0, -24(s0)
    li a1, 2
    call closure_apply
    addi sp, sp, 16
  .Lendif_1:
    ld ra, 72(sp)
    ld s0, 64(sp)
    addi sp, sp, 80
    ret
    
    .globl llf_5
    .type llf_5, @function
  llf_5:
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
    la a0, llf_4
    li a1, 4
    call closure_alloc
    addi t0, a0, 0
    sd t0, -48(s0)
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -24
    ld t0, -24(s0)
    sd t0, 0(sp)
    ld t0, -32(s0)
    sd t0, 8(sp)
    ld t0, -40(s0)
    sd t0, 16(sp)
    addi a2, sp, 0
    ld a0, -48(s0)
    li a1, 3
    call closure_apply
    addi sp, sp, 24
    addi sp, sp, 8
    ld ra, 40(sp)
    ld s0, 32(sp)
    addi sp, sp, 48
    ret
    
    .globl llf_6
    .type llf_6, @function
  llf_6:
    addi sp, sp, -32
    sd ra, 24(sp)
    sd s0, 16(sp)
    addi s0, sp, 32
    ld t0, 0(a1)
    sd t0, -24(s0)
    addi sp, sp, 0
    addi a1, sp, 0
    li a0, 0
    call fac_cps_cc_2
    addi sp, sp, 0
    addi t3, a0, 0
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -24
    la a0, fac_cps
    li a1, 0
    call closure_alloc
    addi t0, a0, 0
    sd t0, 0(sp)
    la a0, fresh_1
    li a1, 0
    call closure_alloc
    addi t0, a0, 0
    sd t0, 8(sp)
    ld t0, -24(s0)
    sd t0, 16(sp)
    addi a2, sp, 0
    addi a0, t3, 0
    li a1, 3
    call closure_apply
    addi sp, sp, 24
    addi sp, sp, 8
    ld ra, 24(sp)
    ld s0, 16(sp)
    addi sp, sp, 32
    ret
    
    .globl id
    .type id, @function
  id:
    addi sp, sp, -16
    sd ra, 8(sp)
    sd s0, 0(sp)
    addi s0, sp, 16
    la a0, llf_0
    li a1, 1
    call closure_alloc
    ld ra, 8(sp)
    ld s0, 0(sp)
    addi sp, sp, 16
    ret
    
    .globl fresh_1
    .type fresh_1, @function
  fresh_1:
    addi sp, sp, -16
    sd ra, 8(sp)
    sd s0, 0(sp)
    addi s0, sp, 16
    la a0, llf_3
    li a1, 1
    call closure_alloc
    ld ra, 8(sp)
    ld s0, 0(sp)
    addi sp, sp, 16
    ret
    
    .globl fac_cps_cc_2
    .type fac_cps_cc_2, @function
  fac_cps_cc_2:
    addi sp, sp, -16
    sd ra, 8(sp)
    sd s0, 0(sp)
    addi s0, sp, 16
    la a0, llf_5
    li a1, 3
    call closure_alloc
    ld ra, 8(sp)
    ld s0, 0(sp)
    addi sp, sp, 16
    ret
    
    .globl fac_cps
    .type fac_cps, @function
  fac_cps:
    addi sp, sp, -16
    sd ra, 8(sp)
    sd s0, 0(sp)
    addi s0, sp, 16
    la a0, llf_6
    li a1, 1
    call closure_alloc
    ld ra, 8(sp)
    ld s0, 0(sp)
    addi sp, sp, 16
    ret
    
    .globl main
    .type main, @function
  main:
    addi sp, sp, -48
    sd ra, 40(sp)
    sd s0, 32(sp)
    addi s0, sp, 48
    call heap_init
    la t0, ML_STACK_BASE
    sd s0, 0(t0)
    addi sp, sp, 0
    addi a1, sp, 0
    li a0, 0
    call fac_cps
    addi sp, sp, 0
    addi t3, a0, 0
    addi sp, sp, -16
    li t0, 9
    sd t0, 0(sp)
    la a0, id
    li a1, 0
    call closure_alloc
    addi t0, a0, 0
    sd t0, 8(sp)
    addi a2, sp, 0
    addi a0, t3, 0
    li a1, 2
    call closure_apply
    addi sp, sp, 16
    addi t0, a0, 0
    sd t0, -24(s0)
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -8
    ld t0, -24(s0)
    sd t0, 0(sp)
    addi a1, sp, 0
    li a0, 1
    call print_int
    addi sp, sp, 8
    addi sp, sp, 8
    addi t0, a0, 0
    sd t0, -32(s0)
    ld t0, -32(s0)
    sd t0, -40(s0)
    li a0, 1
    ld ra, 40(sp)
    ld s0, 32(sp)
    addi sp, sp, 48
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
    .globl llf_0
    .type llf_0, @function
  llf_0:
    addi sp, sp, -32
    sd ra, 24(sp)
    sd s0, 16(sp)
    addi s0, sp, 32
    ld t0, 0(a1)
    sd t0, -24(s0)
    ld a0, -24(s0)
    ld ra, 24(sp)
    ld s0, 16(sp)
    addi sp, sp, 32
    ret
    
    .globl llf_1
    .type llf_1, @function
  llf_1:
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
    ld t0, -32(s0)
    ld t1, -40(s0)
    add t0, t0, t1
    addi t0, t0, -1
    sd t0, -48(s0)
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -8
    ld t0, -48(s0)
    sd t0, 0(sp)
    addi a2, sp, 0
    ld a0, -24(s0)
    li a1, 1
    call closure_apply
    addi sp, sp, 8
    addi sp, sp, 8
    ld ra, 40(sp)
    ld s0, 32(sp)
    addi sp, sp, 48
    ret
    
    .globl llf_2
    .type llf_2, @function
  llf_2:
    addi sp, sp, -48
    sd ra, 40(sp)
    sd s0, 32(sp)
    addi s0, sp, 48
    ld t0, 0(a1)
    sd t0, -24(s0)
    ld t0, 8(a1)
    sd t0, -32(s0)
    la a0, llf_1
    li a1, 3
    call closure_alloc
    addi t0, a0, 0
    sd t0, -40(s0)
    addi sp, sp, -16
    ld t0, -32(s0)
    sd t0, 0(sp)
    ld t0, -24(s0)
    sd t0, 8(sp)
    addi a2, sp, 0
    ld a0, -40(s0)
    li a1, 2
    call closure_apply
    addi sp, sp, 16
    ld ra, 40(sp)
    ld s0, 32(sp)
    addi sp, sp, 48
    ret
    
    .globl llf_3
    .type llf_3, @function
  llf_3:
    addi sp, sp, -32
    sd ra, 24(sp)
    sd s0, 16(sp)
    addi s0, sp, 32
    ld t0, 0(a1)
    sd t0, -24(s0)
    la a0, llf_2
    li a1, 2
    call closure_alloc
    addi t0, a0, 0
    sd t0, -32(s0)
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -8
    ld t0, -24(s0)
    sd t0, 0(sp)
    addi a2, sp, 0
    ld a0, -32(s0)
    li a1, 1
    call closure_apply
    addi sp, sp, 8
    addi sp, sp, 8
    ld ra, 24(sp)
    ld s0, 16(sp)
    addi sp, sp, 32
    ret
    
    .globl llf_4
    .type llf_4, @function
  llf_4:
    addi sp, sp, -80
    sd ra, 72(sp)
    sd s0, 64(sp)
    addi s0, sp, 80
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
    ld t0, -48(s0)
    li t1, 5
    sub t0, t0, t1
    addi t0, t0, 1
    sd t0, -64(s0)
    addi sp, sp, -16
    ld t0, -56(s0)
    sd t0, 0(sp)
    ld t0, -40(s0)
    sd t0, 8(sp)
    addi a2, sp, 0
    ld a0, -32(s0)
    li a1, 2
    call closure_apply
    addi sp, sp, 16
    addi t0, a0, 0
    sd t0, -72(s0)
    addi sp, sp, -16
    ld t0, -64(s0)
    sd t0, 0(sp)
    ld t0, -72(s0)
    sd t0, 8(sp)
    addi a2, sp, 0
    ld a0, -24(s0)
    li a1, 2
    call closure_apply
    addi sp, sp, 16
    ld ra, 72(sp)
    ld s0, 64(sp)
    addi sp, sp, 80
    ret
    
    .globl llf_5
    .type llf_5, @function
  llf_5:
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
    la a0, llf_4
    li a1, 5
    call closure_alloc
    addi t0, a0, 0
    sd t0, -56(s0)
    addi sp, sp, -32
    ld t0, -48(s0)
    sd t0, 0(sp)
    ld t0, -24(s0)
    sd t0, 8(sp)
    ld t0, -32(s0)
    sd t0, 16(sp)
    ld t0, -40(s0)
    sd t0, 24(sp)
    addi a2, sp, 0
    ld a0, -56(s0)
    li a1, 4
    call closure_apply
    addi sp, sp, 32
    ld ra, 56(sp)
    ld s0, 48(sp)
    addi sp, sp, 64
    ret
    
    .globl llf_6
    .type llf_6, @function
  llf_6:
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
    la a0, llf_5
    li a1, 4
    call closure_alloc
    addi t0, a0, 0
    sd t0, -48(s0)
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -24
    ld t0, -24(s0)
    sd t0, 0(sp)
    ld t0, -40(s0)
    sd t0, 8(sp)
    ld t0, -32(s0)
    sd t0, 16(sp)
    addi a2, sp, 0
    ld a0, -48(s0)
    li a1, 3
    call closure_apply
    addi sp, sp, 24
    addi sp, sp, 8
    ld ra, 40(sp)
    ld s0, 32(sp)
    addi sp, sp, 48
    ret
    
    .globl llf_7
    .type llf_7, @function
  llf_7:
    addi sp, sp, -48
    sd ra, 40(sp)
    sd s0, 32(sp)
    addi s0, sp, 48
    ld t0, 0(a1)
    sd t0, -24(s0)
    ld t0, 8(a1)
    sd t0, -32(s0)
    la a0, llf_6
    li a1, 3
    call closure_alloc
    addi t0, a0, 0
    sd t0, -40(s0)
    addi sp, sp, -16
    ld t0, -24(s0)
    sd t0, 0(sp)
    ld t0, -32(s0)
    sd t0, 8(sp)
    addi a2, sp, 0
    ld a0, -40(s0)
    li a1, 2
    call closure_apply
    addi sp, sp, 16
    ld ra, 40(sp)
    ld s0, 32(sp)
    addi sp, sp, 48
    ret
    
    .globl llf_8
    .type llf_8, @function
  llf_8:
    addi sp, sp, -80
    sd ra, 72(sp)
    sd s0, 64(sp)
    addi s0, sp, 80
    ld t0, 0(a1)
    sd t0, -24(s0)
    ld t0, 8(a1)
    sd t0, -32(s0)
    ld t0, 16(a1)
    sd t0, -40(s0)
    ld t0, 24(a1)
    sd t0, -48(s0)
    ld t0, -40(s0)
    li t1, 5
    slt t0, t0, t1
    slli t0, t0, 1
    addi t0, t0, 1
    sd t0, -56(s0)
    ld t0, -56(s0)
    li t1, 1
    beq t0, t1, .Lelse_0
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -8
    ld t0, -40(s0)
    sd t0, 0(sp)
    addi a2, sp, 0
    ld a0, -48(s0)
    li a1, 1
    call closure_apply
    addi sp, sp, 8
    addi sp, sp, 8
    j .Lendif_1
  .Lelse_0:
    ld t0, -40(s0)
    li t1, 3
    sub t0, t0, t1
    addi t0, t0, 1
    sd t0, -64(s0)
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -24
    ld t0, -40(s0)
    sd t0, 0(sp)
    ld t0, -48(s0)
    sd t0, 8(sp)
    ld t0, -24(s0)
    sd t0, 16(sp)
    addi a2, sp, 0
    ld a0, -32(s0)
    li a1, 3
    call closure_apply
    addi sp, sp, 24
    addi sp, sp, 8
    addi t0, a0, 0
    sd t0, -72(s0)
    addi sp, sp, -16
    ld t0, -64(s0)
    sd t0, 0(sp)
    ld t0, -72(s0)
    sd t0, 8(sp)
    addi a2, sp, 0
    ld a0, -24(s0)
    li a1, 2
    call closure_apply
    addi sp, sp, 16
  .Lendif_1:
    ld ra, 72(sp)
    ld s0, 64(sp)
    addi sp, sp, 80
    ret
    
    .globl llf_9
    .type llf_9, @function
  llf_9:
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
    la a0, llf_8
    li a1, 4
    call closure_alloc
    addi t0, a0, 0
    sd t0, -48(s0)
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -24
    ld t0, -24(s0)
    sd t0, 0(sp)
    ld t0, -32(s0)
    sd t0, 8(sp)
    ld t0, -40(s0)
    sd t0, 16(sp)
    addi a2, sp, 0
    ld a0, -48(s0)
    li a1, 3
    call closure_apply
    addi sp, sp, 24
    addi sp, sp, 8
    ld ra, 40(sp)
    ld s0, 32(sp)
    addi sp, sp, 48
    ret
    
    .globl llf_10
    .type llf_10, @function
  llf_10:
    addi sp, sp, -32
    sd ra, 24(sp)
    sd s0, 16(sp)
    addi s0, sp, 32
    ld t0, 0(a1)
    sd t0, -24(s0)
    addi sp, sp, 0
    addi a1, sp, 0
    li a0, 0
    call fib_cc_6
    addi sp, sp, 0
    addi t3, a0, 0
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -24
    la a0, fib
    li a1, 0
    call closure_alloc
    addi t0, a0, 0
    sd t0, 0(sp)
    la a0, fresh_1
    li a1, 0
    call closure_alloc
    addi t0, a0, 0
    sd t0, 8(sp)
    ld t0, -24(s0)
    sd t0, 16(sp)
    addi a2, sp, 0
    addi a0, t3, 0
    li a1, 3
    call closure_apply
    addi sp, sp, 24
    addi sp, sp, 8
    ld ra, 24(sp)
    ld s0, 16(sp)
    addi sp, sp, 32
    ret
    
    .globl id
    .type id, @function
  id:
    addi sp, sp, -16
    sd ra, 8(sp)
    sd s0, 0(sp)
    addi s0, sp, 16
    la a0, llf_0
    li a1, 1
    call closure_alloc
    ld ra, 8(sp)
    ld s0, 0(sp)
    addi sp, sp, 16
    ret
    
    .globl fresh_2
    .type fresh_2, @function
  fresh_2:
    addi sp, sp, -16
    sd ra, 8(sp)
    sd s0, 0(sp)
    addi s0, sp, 16
    la a0, llf_3
    li a1, 1
    call closure_alloc
    ld ra, 8(sp)
    ld s0, 0(sp)
    addi sp, sp, 16
    ret
    
    .globl fresh_1_cc_2
    .type fresh_1_cc_2, @function
  fresh_1_cc_2:
    addi sp, sp, -16
    sd ra, 8(sp)
    sd s0, 0(sp)
    addi s0, sp, 16
    la a0, llf_7
    li a1, 2
    call closure_alloc
    ld ra, 8(sp)
    ld s0, 0(sp)
    addi sp, sp, 16
    ret
    
    .globl fresh_1
    .type fresh_1, @function
  fresh_1:
    addi sp, sp, -16
    sd ra, 8(sp)
    sd s0, 0(sp)
    addi s0, sp, 16
    addi sp, sp, 0
    addi a1, sp, 0
    li a0, 0
    call fresh_1_cc_2
    addi sp, sp, 0
    addi t3, a0, 0
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -8
    la a0, fresh_2
    li a1, 0
    call closure_alloc
    addi t0, a0, 0
    sd t0, 0(sp)
    addi a2, sp, 0
    addi a0, t3, 0
    li a1, 1
    call closure_apply
    addi sp, sp, 8
    addi sp, sp, 8
    ld ra, 8(sp)
    ld s0, 0(sp)
    addi sp, sp, 16
    ret
    
    .globl fib_cc_6
    .type fib_cc_6, @function
  fib_cc_6:
    addi sp, sp, -16
    sd ra, 8(sp)
    sd s0, 0(sp)
    addi s0, sp, 16
    la a0, llf_9
    li a1, 3
    call closure_alloc
    ld ra, 8(sp)
    ld s0, 0(sp)
    addi sp, sp, 16
    ret
    
    .globl fib
    .type fib, @function
  fib:
    addi sp, sp, -16
    sd ra, 8(sp)
    sd s0, 0(sp)
    addi s0, sp, 16
    la a0, llf_10
    li a1, 1
    call closure_alloc
    ld ra, 8(sp)
    ld s0, 0(sp)
    addi sp, sp, 16
    ret
    
    .globl main
    .type main, @function
  main:
    addi sp, sp, -48
    sd ra, 40(sp)
    sd s0, 32(sp)
    addi s0, sp, 48
    call heap_init
    la t0, ML_STACK_BASE
    sd s0, 0(t0)
    addi sp, sp, 0
    addi a1, sp, 0
    li a0, 0
    call fib
    addi sp, sp, 0
    addi t3, a0, 0
    addi sp, sp, -16
    li t0, 13
    sd t0, 0(sp)
    la a0, id
    li a1, 0
    call closure_alloc
    addi t0, a0, 0
    sd t0, 8(sp)
    addi a2, sp, 0
    addi a0, t3, 0
    li a1, 2
    call closure_apply
    addi sp, sp, 16
    addi t0, a0, 0
    sd t0, -24(s0)
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -8
    ld t0, -24(s0)
    sd t0, 0(sp)
    addi a1, sp, 0
    li a0, 1
    call print_int
    addi sp, sp, 8
    addi sp, sp, 8
    addi t0, a0, 0
    sd t0, -32(s0)
    ld t0, -32(s0)
    sd t0, -40(s0)
    li a0, 1
    ld ra, 40(sp)
    ld s0, 32(sp)
    addi sp, sp, 48
    li a0, 0
    li a7, 93
    ecall
  $ riscv64-linux-gnu-as -march=rv64gc fibcps_ll.s -o fibcps_ll.o
  $ riscv64-linux-gnu-gcc -static fibcps_ll.o -L../../../runtime -l:libruntime.a -o fibcps_ll.elf -Wl,--no-warnings
  $ qemu-riscv64 ./fibcps_ll.elf
  8
=== task 2 ===
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
    .globl llf_0
    .type llf_0, @function
  llf_0:
    addi sp, sp, -32
    sd ra, 24(sp)
    sd s0, 16(sp)
    addi s0, sp, 32
    ld t0, 0(a1)
    sd t0, -24(s0)
    li t0, 1
    ld t1, -24(s0)
    sub t2, t0, t1
    slt t0, x0, t2
    slt t3, t2, x0
    add t0, t0, t3
    slli t0, t0, 1
    addi t0, t0, 1
    sd t0, -32(s0)
    ld t0, -32(s0)
    li t1, 1
    beq t0, t1, .Lelse_0
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -8
    li t0, 1
    sd t0, 0(sp)
    addi a1, sp, 0
    li a0, 1
    call print_int
    addi sp, sp, 8
    addi sp, sp, 8
    j .Lendif_1
  .Lelse_0:
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -8
    li t0, 3
    sd t0, 0(sp)
    addi a1, sp, 0
    li a0, 1
    call print_int
    addi sp, sp, 8
    addi sp, sp, 8
  .Lendif_1:
    ld ra, 24(sp)
    ld s0, 16(sp)
    addi sp, sp, 32
    ret
    
    .globl large
    .type large, @function
  large:
    addi sp, sp, -16
    sd ra, 8(sp)
    sd s0, 0(sp)
    addi s0, sp, 16
    la a0, llf_0
    li a1, 1
    call closure_alloc
    ld ra, 8(sp)
    ld s0, 0(sp)
    addi sp, sp, 16
    ret
    
    .globl main
    .type main, @function
  main:
    addi sp, sp, -64
    sd ra, 56(sp)
    sd s0, 48(sp)
    addi s0, sp, 64
    call heap_init
    la t0, ML_STACK_BASE
    sd s0, 0(t0)
    li t0, 1
    li t1, 3
    sub t2, t0, t1
    slt t0, x0, t2
    slt t3, t2, x0
    add t0, t0, t3
    xori t0, t0, 1
    slli t0, t0, 1
    addi t0, t0, 1
    sd t0, -24(s0)
    ld t0, -24(s0)
    li t1, 1
    beq t0, t1, .Lelse_2
    li t0, 1
    li t1, 3
    sub t2, t0, t1
    slt t0, x0, t2
    slt t3, t2, x0
    add t0, t0, t3
    xori t0, t0, 1
    slli t0, t0, 1
    addi t0, t0, 1
    sd t0, -32(s0)
    ld t0, -32(s0)
    li t1, 1
    beq t0, t1, .Lelse_4
    li t0, 1
    li t1, 3
    sub t2, t0, t1
    slt t0, x0, t2
    slt t3, t2, x0
    add t0, t0, t3
    xori t0, t0, 1
    slli t0, t0, 1
    addi t0, t0, 1
    sd t0, -40(s0)
    ld t0, -40(s0)
    li t1, 1
    beq t0, t1, .Lelse_6
    li t0, 1
    sd t0, -48(s0)
    addi sp, sp, 0
    addi a1, sp, 0
    li a0, 0
    call large
    addi sp, sp, 0
    addi t3, a0, 0
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -8
    ld t0, -48(s0)
    sd t0, 0(sp)
    addi a2, sp, 0
    addi a0, t3, 0
    li a1, 1
    call closure_apply
    addi sp, sp, 8
    addi sp, sp, 8
    j .Lendif_7
  .Lelse_6:
    li t0, 3
    sd t0, -56(s0)
    addi sp, sp, 0
    addi a1, sp, 0
    li a0, 0
    call large
    addi sp, sp, 0
    addi t3, a0, 0
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -8
    ld t0, -56(s0)
    sd t0, 0(sp)
    addi a2, sp, 0
    addi a0, t3, 0
    li a1, 1
    call closure_apply
    addi sp, sp, 8
    addi sp, sp, 8
  .Lendif_7:
    j .Lendif_5
  .Lelse_4:
    li t0, 3
    li t1, 3
    sub t2, t0, t1
    slt t0, x0, t2
    slt t3, t2, x0
    add t0, t0, t3
    xori t0, t0, 1
    slli t0, t0, 1
    addi t0, t0, 1
    sd t0, -64(s0)
    ld t0, -64(s0)
    li t1, 1
    beq t0, t1, .Lelse_8
    li t0, 1
    sd t0, -72(s0)
    addi sp, sp, 0
    addi a1, sp, 0
    li a0, 0
    call large
    addi sp, sp, 0
    addi t3, a0, 0
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -8
    ld t0, -72(s0)
    sd t0, 0(sp)
    addi a2, sp, 0
    addi a0, t3, 0
    li a1, 1
    call closure_apply
    addi sp, sp, 8
    addi sp, sp, 8
    j .Lendif_9
  .Lelse_8:
    li t0, 3
    sd t0, -80(s0)
    addi sp, sp, 0
    addi a1, sp, 0
    li a0, 0
    call large
    addi sp, sp, 0
    addi t3, a0, 0
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -8
    ld t0, -80(s0)
    sd t0, 0(sp)
    addi a2, sp, 0
    addi a0, t3, 0
    li a1, 1
    call closure_apply
    addi sp, sp, 8
    addi sp, sp, 8
  .Lendif_9:
  .Lendif_5:
    j .Lendif_3
  .Lelse_2:
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -8
    li t0, 85
    sd t0, 0(sp)
    addi a1, sp, 0
    li a0, 1
    call print_int
    addi sp, sp, 8
    addi sp, sp, 8
    addi t0, a0, 0
    sd t0, -88(s0)
    ld t0, -88(s0)
    sd t0, -96(s0)
    li t0, 3
    li t1, 3
    sub t2, t0, t1
    slt t0, x0, t2
    slt t3, t2, x0
    add t0, t0, t3
    xori t0, t0, 1
    slli t0, t0, 1
    addi t0, t0, 1
    sd t0, -104(s0)
    ld t0, -104(s0)
    li t1, 1
    beq t0, t1, .Lelse_10
    li t0, 1
    li t1, 3
    sub t2, t0, t1
    slt t0, x0, t2
    slt t3, t2, x0
    add t0, t0, t3
    xori t0, t0, 1
    slli t0, t0, 1
    addi t0, t0, 1
    sd t0, -112(s0)
    ld t0, -112(s0)
    li t1, 1
    beq t0, t1, .Lelse_12
    li t0, 1
    sd t0, -120(s0)
    addi sp, sp, 0
    addi a1, sp, 0
    li a0, 0
    call large
    addi sp, sp, 0
    addi t3, a0, 0
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -8
    ld t0, -120(s0)
    sd t0, 0(sp)
    addi a2, sp, 0
    addi a0, t3, 0
    li a1, 1
    call closure_apply
    addi sp, sp, 8
    addi sp, sp, 8
    j .Lendif_13
  .Lelse_12:
    li t0, 3
    sd t0, -128(s0)
    addi sp, sp, 0
    addi a1, sp, 0
    li a0, 0
    call large
    addi sp, sp, 0
    addi t3, a0, 0
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -8
    ld t0, -128(s0)
    sd t0, 0(sp)
    addi a2, sp, 0
    addi a0, t3, 0
    li a1, 1
    call closure_apply
    addi sp, sp, 8
    addi sp, sp, 8
  .Lendif_13:
    j .Lendif_11
  .Lelse_10:
    li t0, 3
    li t1, 3
    sub t2, t0, t1
    slt t0, x0, t2
    slt t3, t2, x0
    add t0, t0, t3
    xori t0, t0, 1
    slli t0, t0, 1
    addi t0, t0, 1
    sd t0, -136(s0)
    ld t0, -136(s0)
    li t1, 1
    beq t0, t1, .Lelse_14
    li t0, 1
    sd t0, -144(s0)
    addi sp, sp, 0
    addi a1, sp, 0
    li a0, 0
    call large
    addi sp, sp, 0
    addi t3, a0, 0
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -8
    ld t0, -144(s0)
    sd t0, 0(sp)
    addi a2, sp, 0
    addi a0, t3, 0
    li a1, 1
    call closure_apply
    addi sp, sp, 8
    addi sp, sp, 8
    j .Lendif_15
  .Lelse_14:
    li t0, 3
    sd t0, -152(s0)
    addi sp, sp, 0
    addi a1, sp, 0
    li a0, 0
    call large
    addi sp, sp, 0
    addi t3, a0, 0
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -8
    ld t0, -152(s0)
    sd t0, 0(sp)
    addi a2, sp, 0
    addi a0, t3, 0
    li a1, 1
    call closure_apply
    addi sp, sp, 8
    addi sp, sp, 8
  .Lendif_15:
  .Lendif_11:
  .Lendif_3:
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

==== other ====
=== without partial ===
  $ cat >fib.ml <<EOF
  > let rec fib n = if n < 2 then n else fib (n - 1) + fib (n - 2)
  > let main = let () = print_int (fib 4) in 0
  > EOF
  $ ../../../bin/AML.exe fib.ml fib.s
  Generated: fib.s
  $ cat fib.s
    .text
    .globl llf_0
    .type llf_0, @function
  llf_0:
    addi sp, sp, -64
    sd ra, 56(sp)
    sd s0, 48(sp)
    addi s0, sp, 64
    ld t0, 0(a1)
    sd t0, -24(s0)
    ld t0, -24(s0)
    li t1, 5
    slt t0, t0, t1
    slli t0, t0, 1
    addi t0, t0, 1
    sd t0, -32(s0)
    ld t0, -32(s0)
    li t1, 1
    beq t0, t1, .Lelse_0
    ld a0, -24(s0)
    j .Lendif_1
  .Lelse_0:
    ld t0, -24(s0)
    li t1, 3
    sub t0, t0, t1
    addi t0, t0, 1
    sd t0, -40(s0)
    addi sp, sp, 0
    addi a1, sp, 0
    li a0, 0
    call fib
    addi sp, sp, 0
    addi t3, a0, 0
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -8
    ld t0, -40(s0)
    sd t0, 0(sp)
    addi a2, sp, 0
    addi a0, t3, 0
    li a1, 1
    call closure_apply
    addi sp, sp, 8
    addi sp, sp, 8
    addi t0, a0, 0
    sd t0, -48(s0)
    ld t0, -24(s0)
    li t1, 5
    sub t0, t0, t1
    addi t0, t0, 1
    sd t0, -56(s0)
    addi sp, sp, 0
    addi a1, sp, 0
    li a0, 0
    call fib
    addi sp, sp, 0
    addi t3, a0, 0
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -8
    ld t0, -56(s0)
    sd t0, 0(sp)
    addi a2, sp, 0
    addi a0, t3, 0
    li a1, 1
    call closure_apply
    addi sp, sp, 8
    addi sp, sp, 8
    addi t0, a0, 0
    sd t0, -64(s0)
    ld t0, -48(s0)
    ld t1, -64(s0)
    add a0, t0, t1
    addi a0, a0, -1
  .Lendif_1:
    ld ra, 56(sp)
    ld s0, 48(sp)
    addi sp, sp, 64
    ret
    
    .globl fib
    .type fib, @function
  fib:
    addi sp, sp, -16
    sd ra, 8(sp)
    sd s0, 0(sp)
    addi s0, sp, 16
    la a0, llf_0
    li a1, 1
    call closure_alloc
    ld ra, 8(sp)
    ld s0, 0(sp)
    addi sp, sp, 16
    ret
    
    .globl main
    .type main, @function
  main:
    addi sp, sp, -48
    sd ra, 40(sp)
    sd s0, 32(sp)
    addi s0, sp, 48
    call heap_init
    la t0, ML_STACK_BASE
    sd s0, 0(t0)
    addi sp, sp, 0
    addi a1, sp, 0
    li a0, 0
    call fib
    addi sp, sp, 0
    addi t3, a0, 0
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -8
    li t0, 9
    sd t0, 0(sp)
    addi a2, sp, 0
    addi a0, t3, 0
    li a1, 1
    call closure_apply
    addi sp, sp, 8
    addi sp, sp, 8
    addi t0, a0, 0
    sd t0, -24(s0)
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -8
    ld t0, -24(s0)
    sd t0, 0(sp)
    addi a1, sp, 0
    li a0, 1
    call print_int
    addi sp, sp, 8
    addi sp, sp, 8
    addi t0, a0, 0
    sd t0, -32(s0)
    ld t0, -32(s0)
    sd t0, -40(s0)
    li a0, 1
    ld ra, 40(sp)
    ld s0, 32(sp)
    addi sp, sp, 48
    li a0, 0
    li a7, 93
    ecall
  $ riscv64-linux-gnu-as -march=rv64gc fib.s -o fib.o
  $ riscv64-linux-gnu-gcc -static fib.o -L../../../runtime -l:libruntime.a -o fib.elf -Wl,--no-warnings
  $ qemu-riscv64 ./fib.elf
  3

=== partial application 11 ===
  $ cat >many_args.ml <<EOF
  > let f a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 = a0+a1+a2+a3+a4+a5+a6+a7+a8+a9+a10
  > let main = print_int (f 0 1 2 3 4 5 6 7 8 9 10)
  > EOF
  $ ../../../bin/AML.exe many_args.ml many_args.s
  Generated: many_args.s
  $ cat many_args.s
    .text
    .globl llf_0
    .type llf_0, @function
  llf_0:
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
    addi t0, t0, -1
    sd t0, -112(s0)
    ld t0, -112(s0)
    ld t1, -40(s0)
    add t0, t0, t1
    addi t0, t0, -1
    sd t0, -120(s0)
    ld t0, -120(s0)
    ld t1, -48(s0)
    add t0, t0, t1
    addi t0, t0, -1
    sd t0, -128(s0)
    ld t0, -128(s0)
    ld t1, -56(s0)
    add t0, t0, t1
    addi t0, t0, -1
    sd t0, -136(s0)
    ld t0, -136(s0)
    ld t1, -64(s0)
    add t0, t0, t1
    addi t0, t0, -1
    sd t0, -144(s0)
    ld t0, -144(s0)
    ld t1, -72(s0)
    add t0, t0, t1
    addi t0, t0, -1
    sd t0, -152(s0)
    ld t0, -152(s0)
    ld t1, -80(s0)
    add t0, t0, t1
    addi t0, t0, -1
    sd t0, -160(s0)
    ld t0, -160(s0)
    ld t1, -88(s0)
    add t0, t0, t1
    addi t0, t0, -1
    sd t0, -168(s0)
    ld t0, -168(s0)
    ld t1, -96(s0)
    add t0, t0, t1
    addi t0, t0, -1
    sd t0, -176(s0)
    ld t0, -176(s0)
    ld t1, -104(s0)
    add a0, t0, t1
    addi a0, a0, -1
    ld ra, 168(sp)
    ld s0, 160(sp)
    addi sp, sp, 176
    ret
    
    .globl llf_1
    .type llf_1, @function
  llf_1:
    addi sp, sp, -112
    sd ra, 104(sp)
    sd s0, 96(sp)
    addi s0, sp, 112
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
    la a0, llf_0
    li a1, 11
    call closure_alloc
    addi t0, a0, 0
    sd t0, -104(s0)
    addi sp, sp, -80
    ld t0, -24(s0)
    sd t0, 0(sp)
    ld t0, -32(s0)
    sd t0, 8(sp)
    ld t0, -40(s0)
    sd t0, 16(sp)
    ld t0, -48(s0)
    sd t0, 24(sp)
    ld t0, -56(s0)
    sd t0, 32(sp)
    ld t0, -64(s0)
    sd t0, 40(sp)
    ld t0, -72(s0)
    sd t0, 48(sp)
    ld t0, -80(s0)
    sd t0, 56(sp)
    ld t0, -88(s0)
    sd t0, 64(sp)
    ld t0, -96(s0)
    sd t0, 72(sp)
    addi a2, sp, 0
    ld a0, -104(s0)
    li a1, 10
    call closure_apply
    addi sp, sp, 80
    ld ra, 104(sp)
    ld s0, 96(sp)
    addi sp, sp, 112
    ret
    
    .globl llf_2
    .type llf_2, @function
  llf_2:
    addi sp, sp, -96
    sd ra, 88(sp)
    sd s0, 80(sp)
    addi s0, sp, 96
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
    la a0, llf_1
    li a1, 10
    call closure_alloc
    addi t0, a0, 0
    sd t0, -96(s0)
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -72
    ld t0, -24(s0)
    sd t0, 0(sp)
    ld t0, -32(s0)
    sd t0, 8(sp)
    ld t0, -40(s0)
    sd t0, 16(sp)
    ld t0, -48(s0)
    sd t0, 24(sp)
    ld t0, -56(s0)
    sd t0, 32(sp)
    ld t0, -64(s0)
    sd t0, 40(sp)
    ld t0, -72(s0)
    sd t0, 48(sp)
    ld t0, -80(s0)
    sd t0, 56(sp)
    ld t0, -88(s0)
    sd t0, 64(sp)
    addi a2, sp, 0
    ld a0, -96(s0)
    li a1, 9
    call closure_apply
    addi sp, sp, 72
    addi sp, sp, 8
    ld ra, 88(sp)
    ld s0, 80(sp)
    addi sp, sp, 96
    ret
    
    .globl llf_3
    .type llf_3, @function
  llf_3:
    addi sp, sp, -96
    sd ra, 88(sp)
    sd s0, 80(sp)
    addi s0, sp, 96
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
    la a0, llf_2
    li a1, 9
    call closure_alloc
    addi t0, a0, 0
    sd t0, -88(s0)
    addi sp, sp, -64
    ld t0, -24(s0)
    sd t0, 0(sp)
    ld t0, -32(s0)
    sd t0, 8(sp)
    ld t0, -40(s0)
    sd t0, 16(sp)
    ld t0, -48(s0)
    sd t0, 24(sp)
    ld t0, -56(s0)
    sd t0, 32(sp)
    ld t0, -64(s0)
    sd t0, 40(sp)
    ld t0, -72(s0)
    sd t0, 48(sp)
    ld t0, -80(s0)
    sd t0, 56(sp)
    addi a2, sp, 0
    ld a0, -88(s0)
    li a1, 8
    call closure_apply
    addi sp, sp, 64
    ld ra, 88(sp)
    ld s0, 80(sp)
    addi sp, sp, 96
    ret
    
    .globl llf_4
    .type llf_4, @function
  llf_4:
    addi sp, sp, -80
    sd ra, 72(sp)
    sd s0, 64(sp)
    addi s0, sp, 80
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
    la a0, llf_3
    li a1, 8
    call closure_alloc
    addi t0, a0, 0
    sd t0, -80(s0)
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -56
    ld t0, -24(s0)
    sd t0, 0(sp)
    ld t0, -32(s0)
    sd t0, 8(sp)
    ld t0, -40(s0)
    sd t0, 16(sp)
    ld t0, -48(s0)
    sd t0, 24(sp)
    ld t0, -56(s0)
    sd t0, 32(sp)
    ld t0, -64(s0)
    sd t0, 40(sp)
    ld t0, -72(s0)
    sd t0, 48(sp)
    addi a2, sp, 0
    ld a0, -80(s0)
    li a1, 7
    call closure_apply
    addi sp, sp, 56
    addi sp, sp, 8
    ld ra, 72(sp)
    ld s0, 64(sp)
    addi sp, sp, 80
    ret
    
    .globl llf_5
    .type llf_5, @function
  llf_5:
    addi sp, sp, -80
    sd ra, 72(sp)
    sd s0, 64(sp)
    addi s0, sp, 80
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
    la a0, llf_4
    li a1, 7
    call closure_alloc
    addi t0, a0, 0
    sd t0, -72(s0)
    addi sp, sp, -48
    ld t0, -24(s0)
    sd t0, 0(sp)
    ld t0, -32(s0)
    sd t0, 8(sp)
    ld t0, -40(s0)
    sd t0, 16(sp)
    ld t0, -48(s0)
    sd t0, 24(sp)
    ld t0, -56(s0)
    sd t0, 32(sp)
    ld t0, -64(s0)
    sd t0, 40(sp)
    addi a2, sp, 0
    ld a0, -72(s0)
    li a1, 6
    call closure_apply
    addi sp, sp, 48
    ld ra, 72(sp)
    ld s0, 64(sp)
    addi sp, sp, 80
    ret
    
    .globl llf_6
    .type llf_6, @function
  llf_6:
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
    ld t0, 32(a1)
    sd t0, -56(s0)
    la a0, llf_5
    li a1, 6
    call closure_alloc
    addi t0, a0, 0
    sd t0, -64(s0)
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -40
    ld t0, -24(s0)
    sd t0, 0(sp)
    ld t0, -32(s0)
    sd t0, 8(sp)
    ld t0, -40(s0)
    sd t0, 16(sp)
    ld t0, -48(s0)
    sd t0, 24(sp)
    ld t0, -56(s0)
    sd t0, 32(sp)
    addi a2, sp, 0
    ld a0, -64(s0)
    li a1, 5
    call closure_apply
    addi sp, sp, 40
    addi sp, sp, 8
    ld ra, 56(sp)
    ld s0, 48(sp)
    addi sp, sp, 64
    ret
    
    .globl llf_7
    .type llf_7, @function
  llf_7:
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
    la a0, llf_6
    li a1, 5
    call closure_alloc
    addi t0, a0, 0
    sd t0, -56(s0)
    addi sp, sp, -32
    ld t0, -24(s0)
    sd t0, 0(sp)
    ld t0, -32(s0)
    sd t0, 8(sp)
    ld t0, -40(s0)
    sd t0, 16(sp)
    ld t0, -48(s0)
    sd t0, 24(sp)
    addi a2, sp, 0
    ld a0, -56(s0)
    li a1, 4
    call closure_apply
    addi sp, sp, 32
    ld ra, 56(sp)
    ld s0, 48(sp)
    addi sp, sp, 64
    ret
    
    .globl llf_8
    .type llf_8, @function
  llf_8:
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
    la a0, llf_7
    li a1, 4
    call closure_alloc
    addi t0, a0, 0
    sd t0, -48(s0)
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -24
    ld t0, -24(s0)
    sd t0, 0(sp)
    ld t0, -32(s0)
    sd t0, 8(sp)
    ld t0, -40(s0)
    sd t0, 16(sp)
    addi a2, sp, 0
    ld a0, -48(s0)
    li a1, 3
    call closure_apply
    addi sp, sp, 24
    addi sp, sp, 8
    ld ra, 40(sp)
    ld s0, 32(sp)
    addi sp, sp, 48
    ret
    
    .globl llf_9
    .type llf_9, @function
  llf_9:
    addi sp, sp, -48
    sd ra, 40(sp)
    sd s0, 32(sp)
    addi s0, sp, 48
    ld t0, 0(a1)
    sd t0, -24(s0)
    ld t0, 8(a1)
    sd t0, -32(s0)
    la a0, llf_8
    li a1, 3
    call closure_alloc
    addi t0, a0, 0
    sd t0, -40(s0)
    addi sp, sp, -16
    ld t0, -24(s0)
    sd t0, 0(sp)
    ld t0, -32(s0)
    sd t0, 8(sp)
    addi a2, sp, 0
    ld a0, -40(s0)
    li a1, 2
    call closure_apply
    addi sp, sp, 16
    ld ra, 40(sp)
    ld s0, 32(sp)
    addi sp, sp, 48
    ret
    
    .globl llf_10
    .type llf_10, @function
  llf_10:
    addi sp, sp, -32
    sd ra, 24(sp)
    sd s0, 16(sp)
    addi s0, sp, 32
    ld t0, 0(a1)
    sd t0, -24(s0)
    la a0, llf_9
    li a1, 2
    call closure_alloc
    addi t0, a0, 0
    sd t0, -32(s0)
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -8
    ld t0, -24(s0)
    sd t0, 0(sp)
    addi a2, sp, 0
    ld a0, -32(s0)
    li a1, 1
    call closure_apply
    addi sp, sp, 8
    addi sp, sp, 8
    ld ra, 24(sp)
    ld s0, 16(sp)
    addi sp, sp, 32
    ret
    
    .globl f
    .type f, @function
  f:
    addi sp, sp, -16
    sd ra, 8(sp)
    sd s0, 0(sp)
    addi s0, sp, 16
    la a0, llf_10
    li a1, 1
    call closure_alloc
    ld ra, 8(sp)
    ld s0, 0(sp)
    addi sp, sp, 16
    ret
    
    .globl main
    .type main, @function
  main:
    addi sp, sp, -32
    sd ra, 24(sp)
    sd s0, 16(sp)
    addi s0, sp, 32
    call heap_init
    la t0, ML_STACK_BASE
    sd s0, 0(t0)
    addi sp, sp, 0
    addi a1, sp, 0
    li a0, 0
    call f
    addi sp, sp, 0
    addi t3, a0, 0
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -88
    li t0, 1
    sd t0, 0(sp)
    li t0, 3
    sd t0, 8(sp)
    li t0, 5
    sd t0, 16(sp)
    li t0, 7
    sd t0, 24(sp)
    li t0, 9
    sd t0, 32(sp)
    li t0, 11
    sd t0, 40(sp)
    li t0, 13
    sd t0, 48(sp)
    li t0, 15
    sd t0, 56(sp)
    li t0, 17
    sd t0, 64(sp)
    li t0, 19
    sd t0, 72(sp)
    li t0, 21
    sd t0, 80(sp)
    addi a2, sp, 0
    addi a0, t3, 0
    li a1, 11
    call closure_apply
    addi sp, sp, 88
    addi sp, sp, 8
    addi t0, a0, 0
    sd t0, -24(s0)
    addi sp, sp, -8
    sd x0, 0(sp)
    addi sp, sp, -8
    ld t0, -24(s0)
    sd t0, 0(sp)
    addi a1, sp, 0
    li a0, 1
    call print_int
    addi sp, sp, 8
    addi sp, sp, 8
    ld ra, 24(sp)
    ld s0, 16(sp)
    addi sp, sp, 32
    li a0, 0
    li a7, 93
    ecall
  $ riscv64-linux-gnu-as -march=rv64gc many_args.s -o many_args.o
  $ riscv64-linux-gnu-gcc -static many_args.o -L../../../runtime -l:libruntime.a -o many_args.elf -Wl,--no-warnings
  $ qemu-riscv64 ./many_args.elf
  55
