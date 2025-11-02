  $ dune exec ./../bin/XML.exe -- --ll <<EOF
  > let rec fac n = if n = 0 then 1 else n * fac (n - 1)
  > 
  > let main = print_int (fac 4)
  let rec fac = fun n -> let t_0 = (n = 0)
                           in let t_4 = if t_0 then 1 else let t_1 = (n - 1)
                                                             in let t_2 = fac t_1
                                                                  in let t_3 = (n * t_2)
                                                                      in t_3
                                in t_4;;
  let main = let t_6 = fac 4 in let t_7 = print_int t_6 in t_7;;
