open Ast
open Ast.Expression
open Ast.Structure
open Middle.Anf

let show_anf_program (items : astructure_item list) =
  let indent n = String.make (2 * n) ' ' in
  let rec show_imm = function
    | ImmNum n -> Printf.sprintf "%d" n
    | ImmId x -> x
  and show_binop = function
    | Add -> "+"
    | Sub -> "-"
    | Mul -> "*"
    | Le -> "<="
    | Lt -> "<"
    | Eq -> "="
    | Neq -> "<>"
  and show_cexpr ?(lvl = 0) = function
    | CImm i -> Printf.sprintf "%s(CImm %s)" (indent lvl) (show_imm i)
    | CBinop (op, a, b) ->
      Printf.sprintf
        "%s(CBinop %s %s %s)"
        (indent lvl)
        (show_binop op)
        (show_imm a)
        (show_imm b)
    | CApp (f, args) ->
      let args_str = String.concat "; " (List.map show_imm args) in
      Printf.sprintf "%s(CApp %s [%s])" (indent lvl) (show_imm f) args_str
    | CIte (cond, texpr, eexpr) ->
      Printf.sprintf
        "%s(CIte %s\n%s\n%s)"
        (indent lvl)
        (show_imm cond)
        (show_aexpr ~lvl:(lvl + 1) texpr)
        (show_aexpr ~lvl:(lvl + 1) eexpr)
    | CFun (arg, body) ->
      Printf.sprintf "%s(CFun %s\n%s)" (indent lvl) arg (show_aexpr ~lvl:(lvl + 1) body)
  and show_aexpr ?(lvl = 0) = function
    | ACE c -> Printf.sprintf "%s(ACE\n%s)" (indent lvl) (show_cexpr ~lvl:(lvl + 1) c)
    | ALet (flag, id, c, a) ->
      let rf =
        match flag with
        | Nonrecursive -> "let"
        | Recursive -> "let rec"
      in
      Printf.sprintf
        "%s(ALet %s %s =\n%s\n%s)"
        (indent lvl)
        rf
        id
        (show_cexpr ~lvl:(lvl + 1) c)
        (show_aexpr ~lvl:(lvl + 1) a)
  and show_astr_item ?(lvl = 0) = function
    | AStr_value (flag, id, aexpr) ->
      let rf =
        match flag with
        | Nonrecursive -> "let"
        | Recursive -> "let rec"
      in
      Printf.sprintf
        "%s(AStr_value %s %s\n%s)"
        (indent lvl)
        rf
        id
        (show_aexpr ~lvl:(lvl + 1) aexpr)
    | AStr_expr e ->
      Printf.sprintf "%s(AStr_expr\n%s)" (indent lvl) (show_aexpr ~lvl:(lvl + 1) e)
  in
  items |> List.map (show_astr_item ~lvl:0) |> String.concat "\n"
;;

let test_anf (prog : program) =
  let anf_prog = anf_transform prog in
  print_endline (show_anf_program anf_prog)
;;

(* 
let rec fac n = if n <= 1 then 1 else n * fac (n - 1)

let main =
  let () = print_int (fac 4) in
  0
*)
let%expect_test "anf_fac" =
  let expr =
   [(Str_value (Recursive,
          ({ pat = (Pat_var "fac");
             expr =
             (Exp_fun (((Pat_var "n"), []),
                (Exp_if (
                   (Exp_apply ((Exp_ident "<="),
                      (Exp_tuple
                         ((Exp_ident "n"), (Exp_constant (Const_integer 1)), []))
                      )),
                   (Exp_constant (Const_integer 1)),
                   (Some (Exp_apply ((Exp_ident "*"),
                            (Exp_tuple
                               ((Exp_ident "n"),
                                (Exp_apply ((Exp_ident "fac"),
                                   (Exp_apply ((Exp_ident "-"),
                                      (Exp_tuple
                                         ((Exp_ident "n"),
                                          (Exp_constant (Const_integer 1)),
                                          []))
                                      ))
                                   )),
                                []))
                            )))
                   ))
                ))
             },
           [])
          ));
        (Str_value (Nonrecursive,
           ({ pat = (Pat_var "main");
              expr =
              (Exp_let (Nonrecursive,
                 ({ pat = (Pat_construct ("()", None));
                    expr =
                    (Exp_apply ((Exp_ident "print_int"),
                       (Exp_apply ((Exp_ident "fac"),
                          (Exp_constant (Const_integer 4))))
                       ))
                    },
                  []),
                 (Exp_constant (Const_integer 0))))
              },
            [])
           ))
        ]
  in
  test_anf expr;
  [%expect{|
    (AStr_value let rec fac
      (ACE
        (CFun n
          (ALet let t_0 =
            (CBinop <= n 1)
            (ACE
              (CIte t_0
                (ACE
                  (CImm 1))
                (ALet let t_1 =
                  (CBinop - n 1)
                  (ALet let t_2 =
                    (CApp fac [t_1])
                    (ALet let t_3 =
                      (CBinop * n t_2)
                      (ACE
                        (CImm t_3)))))))))))
    (AStr_value let main
      (ALet let t_4 =
        (CApp fac [4])
        (ALet let t_5 =
          (CApp print_int [t_4])
          (ALet let () =
            (CImm t_5)
            (ACE
              (CImm 0)))))) |}]
;;

(*
let rec fib n = if n < 2 then n else fib (n - 1) + fib (n - 2)

let main =
  let () = print_int (fib 4) in
  0
*)
let%expect_test "anf_fib" =
  let expr =
    [(Str_value (Recursive,
        ({ pat = (Pat_var "fib");
           expr =
           (Exp_fun (((Pat_var "n"), []),
              (Exp_if (
                 (Exp_apply ((Exp_ident "<"),
                    (Exp_tuple
                       ((Exp_ident "n"), (Exp_constant (Const_integer 2)), []))
                    )),
                 (Exp_ident "n"),
                 (Some (Exp_apply ((Exp_ident "+"),
                          (Exp_tuple
                             ((Exp_apply ((Exp_ident "fib"),
                                 (Exp_apply ((Exp_ident "-"),
                                    (Exp_tuple
                                       ((Exp_ident "n"),
                                        (Exp_constant (Const_integer 1)),
                                        []))
                                    ))
                                 )),
                              (Exp_apply ((Exp_ident "fib"),
                                 (Exp_apply ((Exp_ident "-"),
                                    (Exp_tuple
                                       ((Exp_ident "n"),
                                        (Exp_constant (Const_integer 2)),
                                        []))
                                    ))
                                 )),
                              []))
                          )))
                 ))
              ))
           },
         [])
        ));
      (Str_value (Nonrecursive,
         ({ pat = (Pat_var "main");
            expr =
            (Exp_let (Nonrecursive,
               ({ pat = (Pat_construct ("()", None));
                  expr =
                  (Exp_apply ((Exp_ident "print_int"),
                     (Exp_apply ((Exp_ident "fib"),
                        (Exp_constant (Const_integer 4))))
                     ))
                  },
                []),
               (Exp_constant (Const_integer 0))))
            },
          [])
         ))
      ]
  in
  test_anf expr;
  [%expect
    {|
    (AStr_value let rec fib
      (ACE
        (CFun n
          (ALet let t_0 =
            (CBinop < n 2)
            (ACE
              (CIte t_0
                (ACE
                  (CImm n))
                (ALet let t_1 =
                  (CBinop - n 1)
                  (ALet let t_2 =
                    (CApp fib [t_1])
                    (ALet let t_3 =
                      (CBinop - n 2)
                      (ALet let t_4 =
                        (CApp fib [t_3])
                        (ALet let t_5 =
                          (CBinop + t_2 t_4)
                          (ACE
                            (CImm t_5)))))))))))))
    (AStr_value let main
      (ALet let t_6 =
        (CApp fib [4])
        (ALet let t_7 =
          (CApp print_int [t_6])
          (ALet let () =
            (CImm t_7)
            (ACE
              (CImm 0)))))) |}]
;;

(*
let large x = if 0<>x then print_int 0 else print_int 1
  let main =
     let x = if (if (if 0
                     then 0 else (let t42 = print_int 42 in 1))
                 then 0 else 1)
             then 0 else 1 in
     large x
*)
let%expect_test "anf_third_test" =
  let expr =
    [(Str_value (Nonrecursive,
        ({ pat = (Pat_var "large");
           expr =
           (Exp_fun (((Pat_var "x"), []),
              (Exp_if (
                 (Exp_apply ((Exp_ident "<>"),
                    (Exp_tuple
                       ((Exp_constant (Const_integer 0)), (Exp_ident "x"), []))
                    )),
                 (Exp_apply ((Exp_ident "print_int"),
                    (Exp_constant (Const_integer 0)))),
                 (Some (Exp_apply ((Exp_ident "print_int"),
                          (Exp_constant (Const_integer 1)))))
                 ))
              ))
           },
         [])
        ));
      (Str_value (Nonrecursive,
         ({ pat = (Pat_var "main");
            expr =
            (Exp_let (Nonrecursive,
               ({ pat = (Pat_var "x");
                  expr =
                  (Exp_if (
                     (Exp_if (
                        (Exp_if ((Exp_constant (Const_integer 0)),
                           (Exp_constant (Const_integer 0)),
                           (Some (Exp_let (Nonrecursive,
                                    ({ pat = (Pat_var "t42");
                                       expr =
                                       (Exp_apply ((Exp_ident "print_int"),
                                          (Exp_constant (Const_integer 42))))
                                       },
                                     []),
                                    (Exp_constant (Const_integer 1)))))
                           )),
                        (Exp_constant (Const_integer 0)),
                        (Some (Exp_constant (Const_integer 1))))),
                     (Exp_constant (Const_integer 0)),
                     (Some (Exp_constant (Const_integer 1)))))
                  },
                []),
               (Exp_apply ((Exp_ident "large"), (Exp_ident "x")))))
            },
          [])
         ))
      ] 
  in
  test_anf expr;
  [%expect
    {|
    (AStr_value let large
      (ACE
        (CFun x
          (ALet let t_0 =
            (CBinop <> 0 x)
            (ACE
              (CIte t_0
                (ALet let t_1 =
                  (CApp print_int [0])
                  (ACE
                    (CImm t_1)))
                (ALet let t_2 =
                  (CApp print_int [1])
                  (ACE
                    (CImm t_2)))))))))
    (AStr_value let main
      (ACE
        (CIte 0
          (ACE
            (CIte 0
              (ACE
                (CIte 0
                  (ALet let x =
                    (CImm 0)
                    (ALet let t_3 =
                      (CApp large [x])
                      (ACE
                        (CImm t_3))))
                  (ALet let x =
                    (CImm 1)
                    (ALet let t_4 =
                      (CApp large [x])
                      (ACE
                        (CImm t_4))))))
              (ACE
                (CIte 1
                  (ALet let x =
                    (CImm 0)
                    (ALet let t_5 =
                      (CApp large [x])
                      (ACE
                        (CImm t_5))))
                  (ALet let x =
                    (CImm 1)
                    (ALet let t_6 =
                      (CApp large [x])
                      (ACE
                        (CImm t_6))))))))
          (ALet let t_7 =
            (CApp print_int [42])
            (ALet let t42 =
              (CImm t_7)
              (ACE
                (CIte 1
                  (ACE
                    (CIte 0
                      (ALet let x =
                        (CImm 0)
                        (ALet let t_8 =
                          (CApp large [x])
                          (ACE
                            (CImm t_8))))
                      (ALet let x =
                        (CImm 1)
                        (ALet let t_9 =
                          (CApp large [x])
                          (ACE
                            (CImm t_9))))))
                  (ACE
                    (CIte 1
                      (ALet let x =
                        (CImm 0)
                        (ALet let t_10 =
                          (CApp large [x])
                          (ACE
                            (CImm t_10))))
                      (ALet let x =
                        (CImm 1)
                        (ALet let t_11 =
                          (CApp large [x])
                          (ACE
                            (CImm t_11))))))))))))) |}]
;;
