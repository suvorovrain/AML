 $ dune exec ./../bin/XML.exe -- --cc <<EOF
 > let rec fac n = if n = 0 then 1 else n * fac (n - 1)
 > 
 > let main = print_int (fac 4)

