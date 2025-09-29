  $ clang-16 -c runtime.c -o runtime.o
  clang-16: not found
  [127]
  $ ./main.exe
  ./main.exe: not found
  [127]
  $ ls
  $ cat out.ll | grep -E 'source_filename|target datalayout|ModuleID' --invert-match
  cat: out.ll: No such file or directory
  [1]
  $ clang-16 out.ll runtime.o -o demo1.exe
  clang-16: not found
  [127]
  $ echo "Press $(./demo1.exe) to pay respect"
  ./demo1.exe: not found
  Press  to pay respect
