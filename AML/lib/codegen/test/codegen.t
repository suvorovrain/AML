=== task 4 ===
  $ ../../../bin/AML.exe ./manytests/typed/012fibcps.ml fibcps.s
  Generated: fibcps.s
$ cat fibcps.s
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
  $ riscv64-linux-gnu-as -march=rv64gc many.s -o many.o
  $ riscv64-linux-gnu-gcc -static many.o -L../../../runtime -l:libruntime.a -o many.elf -Wl,--no-warnings
  $ qemu-riscv64 ./many.elf
  1111111111110100

== task 3 ==
  $ ../../../bin/AML.exe ./manytests/typed/010faccps_ll.ml faccps.s
  Generated: faccps.s
$ cat faccps.s
  $ riscv64-linux-gnu-as -march=rv64gc faccps.s -o faccps.o
  $ riscv64-linux-gnu-gcc -static faccps.o -L../../../runtime -l:libruntime.a -o faccps.elf -Wl,--no-warnings
  $ qemu-riscv64 ./faccps.elf
  24

  $ ../../../bin/AML.exe ./manytests/typed/010fibcps_ll.ml fibcps_ll.s
  Generated: fibcps_ll.s
$ cat fibcps_ll.s
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
  $ riscv64-linux-gnu-as -march=rv64gc ite.s -o ite.o
  $ riscv64-linux-gnu-gcc -static ite.o -L../../../runtime -l:libruntime.a -o ite.elf -Wl,--no-warnings
  $ qemu-riscv64 ./ite.elf
  420

