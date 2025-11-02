  $ dune exec ./../bin/XML.exe -- --ll <<EOF
  > let rec fac n = if n = 0 then 1 else n * fac (n - 1)
  > 
  > let main = print_int (fac 4)
  Error: Program './../bin/XML.exe' not found!
  [1]
