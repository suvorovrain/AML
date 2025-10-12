open Ast
open Ast.Expression

open Middle.Anf  
open Middle.Anf.ANFState

let show_anf aexpr =
  let indent n = String.make (2 * n) ' ' in

  let rec show_imm = function
    | ImmNum n -> Printf.sprintf "%d" n
    | ImmId x -> x
  and show_binop = function
    | Add -> "+" | Sub -> "-" | Mul -> "*" | Le -> "<=" | Lt -> "<"
    | Eq -> "=" | Neq -> "<>"
  and show_cexpr ?(lvl=0) = function
    | CImm i -> Printf.sprintf "%s(CImm %s)" (indent lvl) (show_imm i)
    | CBinop (op, a, b) ->
        Printf.sprintf "%s(CBinop %s %s %s)" (indent lvl)
          (show_binop op) (show_imm a) (show_imm b)
    | CApp (f, args) ->
        let args_str =
          Base.String.concat ~sep:"; " (List.map show_imm args)
        in
        Printf.sprintf "%s(CApp %s [%s])" (indent lvl) (show_imm f) args_str
    | CIte (cond, texpr, eexpr) ->
        Printf.sprintf "%s(CIte %s\n%s\n%s)"
          (indent lvl) (show_imm cond)
          (show_aexpr ~lvl:(lvl + 1) texpr)
          (show_aexpr ~lvl:(lvl + 1) eexpr)
    | CFun (arg, body) ->
        Printf.sprintf "%s(CFun %s\n%s)"
          (indent lvl) arg (show_aexpr ~lvl:(lvl + 1) body)
  and show_aexpr ?(lvl=0) = function
    | ACE c -> Printf.sprintf "%s(ACE\n%s)" (indent lvl) (show_cexpr ~lvl:(lvl + 1) c)
    | ALet (flag, id, c, a) ->
        let rf = match flag with Nonrecursive -> "let" | Recursive -> "let rec" in
        Printf.sprintf "%s(ALet %s %s =\n%s\n%s)"
          (indent lvl) rf id
          (show_cexpr ~lvl:(lvl + 1) c)
          (show_aexpr ~lvl:(lvl + 1) a)
  in
  show_aexpr aexpr
;;


let test_anf expr =
  let anf, _ =
    ANFState.run (transform_expr expr (fun x -> return (ACE (CImm x)))) { temps = 0 }
  in
  print_endline (show_anf anf)
;;

(* let rec fac n = if n <= 1 then 1 else n * fac (n - 1) in fac 4*)
let%expect_test "anf_fac" =
  let expr =
    Expression.Exp_let
      ( Recursive
      , ( { pat = Pattern.Pat_var "fac"
          ; expr =
              Expression.Exp_fun
                ( (Pattern.Pat_var "n", [])
                , Expression.Exp_if
                    ( Expression.Exp_apply
                        ( Expression.Exp_ident "<="
                        , Expression.Exp_tuple
                            ( Expression.Exp_ident "n"
                            , Expression.Exp_constant (Constant.Const_integer 1)
                            , [] ) )
                    , Expression.Exp_constant (Constant.Const_integer 1)
                    , Some
                        ( Expression.Exp_apply
                            ( Expression.Exp_ident "*"
                            , Expression.Exp_tuple
                                ( Expression.Exp_ident "n"
                                , Expression.Exp_apply
                                    ( Expression.Exp_ident "fac"
                                    , Expression.Exp_apply
                                        ( Expression.Exp_ident "-"
                                        , Expression.Exp_tuple
                                            ( Expression.Exp_ident "n"
                                            , Expression.Exp_constant
                                                (Constant.Const_integer 1)
                                            , [] ) ) )
                                , [] ) ) ) ) ) }
        , [] )
      , Expression.Exp_apply
          ( Expression.Exp_ident "fac"
          , Expression.Exp_constant (Constant.Const_integer 4) ) )
  in
  test_anf expr;
  [%expect{|
    (ALet let t_4 =
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
                      (CImm t_3)))))))))
      (ALet let rec fac =
        (CImm t_4)
        (ALet let t_5 =
          (CApp fac [4])
          (ACE
            (CImm t_5))))) |}]

(*let rec fib n = if n < 2 then n else fib (n - 1) + fib (n - 2) in fib 4*)
let%expect_test "anf_fib" =
  let expr =
     Exp_let (Recursive,
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
            []),
           (Exp_apply ((Exp_ident "fib"), (Exp_constant (Const_integer 4)))))
  in
  test_anf expr;
  [%expect{|
    (ALet let t_6 =
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
                          (CImm t_5)))))))))))
      (ALet let rec fib =
        (CImm t_6)
        (ALet let t_7 =
          (CApp fib [4])
          (ACE
            (CImm t_7))))) |}]

           