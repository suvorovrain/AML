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
    addi sp, sp, -64
    sd ra, 56(sp)
    sd s0, 48(sp)
    addi s0, sp, 64
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
    mul t0, t0, t1
    sd t0, -64(s0)
    ld a0, -64(s0)
  .Lendif_1:
  fac_end:
    ld ra, 56(sp)
    ld s0, 48(sp)
    addi sp, sp, 64
    ret
    .globl main
    .type main, @function
  main:
    addi sp, sp, -32
    sd ra, 24(sp)
    sd s0, 16(sp)
    addi s0, sp, 32
    li a0, 4
    call fac
    addi t0, a0, 0
    sd t0, -24(s0)
    ld a0, -24(s0)
    call print_int
    addi t0, a0, 0
    sd t0, -32(s0)
    ld a0, -32(s0)
  main_end:
    ld ra, 24(sp)
    ld s0, 16(sp)
    addi sp, sp, 32
    ret
  $ riscv64-linux-gnu-as -march=rv64gc fac.s -o fac.o
  $ riscv64-linux-gnu-gcc -static fac.o -L../../../runtime/target/riscv64gc-unknown-linux-gnu/release -l:libruntime.a -o fac.elf --no-warnings
  /usr/lib/gcc-cross/riscv64-linux-gnu/13/../../../../riscv64-linux-gnu/bin/ld: ../../../runtime/target/riscv64gc-unknown-linux-gnu/release/libruntime.a(std-fc20e55d14b154cf.std.f9e9beb01923febe-cgu.0.rcgu.o): in function `<std::sys::net::connection::socket::LookupHost as core::convert::TryFrom<(&str,u16)>>::try_from::{{closure}}':
  /rustc/1159e78c4747b02ef996e55082b704c09b970588/library/std/src/sys/net/connection/socket.rs:319:(.text._ZN117_$LT$std..sys..net..connection..socket..LookupHost$u20$as$u20$core..convert..TryFrom$LT$$LP$$RF$str$C$u16$RP$$GT$$GT$8try_from28_$u7b$$u7b$closure$u7d$$u7d$17h6b3bead568d72262E+0x44): warning: Using 'getaddrinfo' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
  /usr/lib/gcc-cross/riscv64-linux-gnu/13/../../../../riscv64-linux-gnu/bin/ld: ../../../runtime/target/riscv64gc-unknown-linux-gnu/release/libruntime.a(std-fc20e55d14b154cf.std.f9e9beb01923febe-cgu.0.rcgu.o): in function `std::sys::pal::unix::os::home_dir::fallback':
  /rustc/1159e78c4747b02ef996e55082b704c09b970588/library/std/src/sys/pal/unix/os.rs:674:(.text._ZN3std3env8home_dir17hfa1f00305db43d8bE+0xb8): warning: Using 'getpwuid_r' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
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
    addi sp, sp, -64
    sd ra, 56(sp)
    sd s0, 48(sp)
    addi s0, sp, 64
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
    add t0, t0, t1
    sd t0, -64(s0)
    ld a0, -64(s0)
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
    ret
  $ riscv64-linux-gnu-as -march=rv64gc fib.s -o fib.o
  $ riscv64-linux-gnu-gcc -static fib.o -L../../../runtime/target/riscv64gc-unknown-linux-gnu/release -l:libruntime.a -o fib.elf --no-warnings
  /usr/lib/gcc-cross/riscv64-linux-gnu/13/../../../../riscv64-linux-gnu/bin/ld: ../../../runtime/target/riscv64gc-unknown-linux-gnu/release/libruntime.a(std-fc20e55d14b154cf.std.f9e9beb01923febe-cgu.0.rcgu.o): in function `<std::sys::net::connection::socket::LookupHost as core::convert::TryFrom<(&str,u16)>>::try_from::{{closure}}':
  /rustc/1159e78c4747b02ef996e55082b704c09b970588/library/std/src/sys/net/connection/socket.rs:319:(.text._ZN117_$LT$std..sys..net..connection..socket..LookupHost$u20$as$u20$core..convert..TryFrom$LT$$LP$$RF$str$C$u16$RP$$GT$$GT$8try_from28_$u7b$$u7b$closure$u7d$$u7d$17h6b3bead568d72262E+0x44): warning: Using 'getaddrinfo' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
  /usr/lib/gcc-cross/riscv64-linux-gnu/13/../../../../riscv64-linux-gnu/bin/ld: ../../../runtime/target/riscv64gc-unknown-linux-gnu/release/libruntime.a(std-fc20e55d14b154cf.std.f9e9beb01923febe-cgu.0.rcgu.o): in function `std::sys::pal::unix::os::home_dir::fallback':
  /rustc/1159e78c4747b02ef996e55082b704c09b970588/library/std/src/sys/pal/unix/os.rs:674:(.text._ZN3std3env8home_dir17hfa1f00305db43d8bE+0xb8): warning: Using 'getpwuid_r' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
  $ qemu-riscv64 ./fib.elf
  3

  $ cat >ite.ml <<EOF
  > let large x = if 0<>x then print_int 0 else print_int 1
  >   let main =
  >      let x = if (if (if 0
  >                      then 0 else (let t42 = print_int 42 in 1))
  >                  then 0 else 1)
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
    addi t0, a0, 0
    ld a0, 0(sp)
    addi sp, sp, 8
    sd t0, -32(s0)
    ld a0, -32(s0)
    j .Lendif_1
  .Lelse_0:
    addi sp, sp, -8
    sd a0, 0(sp)
    li a0, 1
    call print_int
    addi t0, a0, 0
    ld a0, 0(sp)
    addi sp, sp, 8
    sd t0, -40(s0)
    ld a0, -40(s0)
  .Lendif_1:
  large_end:
    ld ra, 24(sp)
    ld s0, 16(sp)
    addi sp, sp, 32
    ret
    .globl main
    .type main, @function
  main:
    addi sp, sp, -48
    sd ra, 40(sp)
    sd s0, 32(sp)
    addi s0, sp, 48
    li t0, 0
    beq t0, x0, .Lelse_2
    li t0, 0
    beq t0, x0, .Lelse_4
    li t0, 0
    beq t0, x0, .Lelse_6
    li t0, 0
    sd t0, -24(s0)
    ld a0, -24(s0)
    call large
    addi t0, a0, 0
    sd t0, -32(s0)
    ld a0, -32(s0)
    j .Lendif_7
  .Lelse_6:
    li t0, 1
    sd t0, -40(s0)
    ld a0, -40(s0)
    call large
    addi t0, a0, 0
    sd t0, -48(s0)
    ld a0, -48(s0)
  .Lendif_7:
    j .Lendif_5
  .Lelse_4:
    li t0, 1
    beq t0, x0, .Lelse_8
    li t0, 0
    sd t0, -56(s0)
    ld a0, -56(s0)
    call large
    addi t0, a0, 0
    sd t0, -64(s0)
    ld a0, -64(s0)
    j .Lendif_9
  .Lelse_8:
    li t0, 1
    sd t0, -72(s0)
    ld a0, -72(s0)
    call large
    addi t0, a0, 0
    sd t0, -80(s0)
    ld a0, -80(s0)
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
    beq t0, x0, .Lelse_10
    li t0, 0
    beq t0, x0, .Lelse_12
    li t0, 0
    sd t0, -104(s0)
    ld a0, -104(s0)
    call large
    addi t0, a0, 0
    sd t0, -112(s0)
    ld a0, -112(s0)
    j .Lendif_13
  .Lelse_12:
    li t0, 1
    sd t0, -120(s0)
    ld a0, -120(s0)
    call large
    addi t0, a0, 0
    sd t0, -128(s0)
    ld a0, -128(s0)
  .Lendif_13:
    j .Lendif_11
  .Lelse_10:
    li t0, 1
    beq t0, x0, .Lelse_14
    li t0, 0
    sd t0, -136(s0)
    ld a0, -136(s0)
    call large
    addi t0, a0, 0
    sd t0, -144(s0)
    ld a0, -144(s0)
    j .Lendif_15
  .Lelse_14:
    li t0, 1
    sd t0, -152(s0)
    ld a0, -152(s0)
    call large
    addi t0, a0, 0
    sd t0, -160(s0)
    ld a0, -160(s0)
  .Lendif_15:
  .Lendif_11:
  .Lendif_3:
  main_end:
    ld ra, 40(sp)
    ld s0, 32(sp)
    addi sp, sp, 48
    ret
  $ riscv64-linux-gnu-as -march=rv64gc ite.s -o ite.o
  $ riscv64-linux-gnu-gcc -static ite.o -L../../../runtime/target/riscv64gc-unknown-linux-gnu/release -l:libruntime.a -o ite.elf --no-warnings
  /usr/lib/gcc-cross/riscv64-linux-gnu/13/../../../../riscv64-linux-gnu/bin/ld: ../../../runtime/target/riscv64gc-unknown-linux-gnu/release/libruntime.a(std-fc20e55d14b154cf.std.f9e9beb01923febe-cgu.0.rcgu.o): in function `<std::sys::net::connection::socket::LookupHost as core::convert::TryFrom<(&str,u16)>>::try_from::{{closure}}':
  /rustc/1159e78c4747b02ef996e55082b704c09b970588/library/std/src/sys/net/connection/socket.rs:319:(.text._ZN117_$LT$std..sys..net..connection..socket..LookupHost$u20$as$u20$core..convert..TryFrom$LT$$LP$$RF$str$C$u16$RP$$GT$$GT$8try_from28_$u7b$$u7b$closure$u7d$$u7d$17h6b3bead568d72262E+0x44): warning: Using 'getaddrinfo' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
  /usr/lib/gcc-cross/riscv64-linux-gnu/13/../../../../riscv64-linux-gnu/bin/ld: ../../../runtime/target/riscv64gc-unknown-linux-gnu/release/libruntime.a(std-fc20e55d14b154cf.std.f9e9beb01923febe-cgu.0.rcgu.o): in function `std::sys::pal::unix::os::home_dir::fallback':
  /rustc/1159e78c4747b02ef996e55082b704c09b970588/library/std/src/sys/pal/unix/os.rs:674:(.text._ZN3std3env8home_dir17hfa1f00305db43d8bE+0xb8): warning: Using 'getpwuid_r' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
  $ qemu-riscv64 ./ite.elf
  42
  0
