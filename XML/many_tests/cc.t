  $ dune exec ./../bin/XML.exe -- --anf <<EOF
  > let main =
  > let c = 2 in
  > let add x = x + c in
  > let mul x = x * c in
  > print_int (add 3 + mul 4)
  let main = let c = 2
               in let t_1 = fun c x -> let t_0 = (x + c) in t_0
                    in let add = t_1 c
                         in let t_3 = fun c x -> let t_2 = (x * c) in t_2
                              in let mul = t_3 c
                                   in let t_4 = add c 3
                                        in let t_5 = mul c 4
                                             in let t_6 = (t_4 + t_5)
                                                  in let t_7 = print_int t_6
                                                       in t_7;;
