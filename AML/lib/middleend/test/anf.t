(** Copyright 2025-2026, Rodion Suvorov, Dmitriy Chirkov*)

(** SPDX-License-Identifier: LGPL-3.0-or-later *)

  $ ../../../bin/AML.exe --dump-anf ./manytests/typed/010fac_anf.ml
  let rec fac =
    fun n ->
      let t_0 = n <= 1 in
      if t_0 then
        1
      else
        let t_1 = n - 1 in
        let n1 = t_1 in
        let t_2 = fac n1 in
        let m = t_2 in
        n * m
  
  let main =
    fac 4

  $ ../../../bin/AML.exe --dump-anf ./manytests/typed/010faccps_ll.ml
  let id =
    fun x ->
      x
  
  let fresh_1 =
    fun n ->
      fun k ->
        fun p ->
          let t_1 = p * n in
          k t_1
  
  let rec fac_cps =
    fun n ->
      fun k ->
        let t_4 = n = 1 in
        if t_4 then
          k 1
        else
          let t_6 = n - 1 in
          let t_7 = fresh_1 n k in
          fac_cps t_6 t_7
  
  let main =
    let t_10 = fac_cps 4 id in
    let t_11 = print_int t_10 in
    let t_12 = t_11 in
    0
  $ ../../../bin/AML.exe --dump-anf ./manytests/typed/010fibcps_ll.ml
  let id =
    fun x ->
      x
  
  let fresh_2 =
    fun p1 ->
      fun k ->
        fun p2 ->
          let t_1 = p1 + p2 in
          k t_1
  
  let fresh_1 =
    fun n ->
      fun k ->
        fun fib ->
          fun p1 ->
            let t_4 = n - 2 in
            let t_5 = fresh_2 p1 k in
            fib t_4 t_5
  
  let rec fib =
    fun n ->
      fun k ->
        let t_8 = n < 2 in
        if t_8 then
          k n
        else
          let t_10 = n - 1 in
          let t_11 = fresh_1 n k fib in
          fib t_10 t_11
  
  let main =
    let t_14 = fib 6 id in
    let t_15 = print_int t_14 in
    let z = t_15 in
    0

=================== custom (before cc + ll) ===================
  $ cat >many_args_pa.ml <<EOF
  > let wrap f = if 1 = 1 then f else f
  > 
  > let test3 a b c =
  > let a = print_int a in
  > let b = print_int b in
  > let c = print_int c in
  > 0
  > 
  > let test10 a b c d e f g h i j = a + b + c + d + e + f + g + h + i + j
  > 
  > let main =
  > let rez =
  >     (wrap test10 1 10 100 1000 10000 100000 1000000 10000000 100000000
  >        1000000000)
  > in
  > let () = print_int rez in
  > let temp2 = wrap test3 1 10 100 in
  > 0
  > EOF
  $ ../../../bin/AML.exe --dump-anf many_args_pa.ml
  let wrap =
    fun f ->
      let t_0 = 1 = 1 in
      if t_0 then
        f
      else
        f
  
  let test3 =
    fun a ->
      fun b ->
        fun c ->
          let t_2 = print_int a in
          let a = t_2 in
          let t_3 = print_int b in
          let b = t_3 in
          let t_4 = print_int c in
          let c = t_4 in
          0
  
  let test10 =
    fun a ->
      fun b ->
        fun c ->
          fun d ->
            fun e ->
              fun f ->
                fun g ->
                  fun h ->
                    fun i ->
                      fun j ->
                        let t_6 = a + b in
                        let t_7 = t_6 + c in
                        let t_8 = t_7 + d in
                        let t_9 = t_8 + e in
                        let t_10 = t_9 + f in
                        let t_11 = t_10 + g in
                        let t_12 = t_11 + h in
                        let t_13 = t_12 + i in
                        t_13 + j
  
  let main =
    let t_16 = wrap test10 1 10 100 1000 10000 100000 1000000 10000000 100000000 1000000000 in
    let rez = t_16 in
    let t_17 = print_int rez in
    let () = t_17 in
    let t_18 = wrap test3 1 10 100 in
    let temp2 = t_18 in
    0

=================== custom (after cc, before ll) ===================
  $ cat >many_args_pa.ml <<EOF
  > let wrap f = if 1 = 1 then f else f
  > 
  > let test3 a b c =
  > let a = print_int a in
  > let b = print_int b in
  > let c = print_int c in
  > 0
  > 
  > let test10 a b c d e f g h i j = a + b + c + d + e + f + g + h + i + j
  > 
  > let main =
  > let rez =
  >     (wrap test10 1 10 100 1000 10000 100000 1000000 10000000 100000000
  >        1000000000)
  > in
  > let () = print_int rez in
  > let temp2 = wrap test3 1 10 100 in
  > 0
  > EOF
  $ ../../../bin/AML.exe --dump-cc-anf many_args_pa.ml
  let wrap_cc_0 =
    fun f ->
      let t_0 = 1 = 1 in
      if t_0 then
        f
      else
        f
  
  let wrap =
    wrap_cc_0
  
  let test3_cc_1 =
    fun a ->
      let f_cc_2 = fun a ->
        fun b ->
          let f_cc_4 = fun a ->
            fun b ->
              fun c ->
                let t_2 = print_int a in
                let a = t_2 in
                let t_3 = print_int b in
                let b = t_3 in
                let t_4 = print_int c in
                let c = t_4 in
                0 in
          let closure_cc_5 = f_cc_4 a b in
          closure_cc_5 in
      let closure_cc_3 = f_cc_2 a in
      closure_cc_3
  
  let test3 =
    test3_cc_1
  
  let test10_cc_6 =
    fun a ->
      let f_cc_7 = fun a ->
        fun b ->
          let f_cc_9 = fun a ->
            fun b ->
              fun c ->
                let f_cc_11 = fun a ->
                  fun b ->
                    fun c ->
                      fun d ->
                        let f_cc_13 = fun a ->
                          fun b ->
                            fun c ->
                              fun d ->
                                fun e ->
                                  let f_cc_15 = fun a ->
                                    fun b ->
                                      fun c ->
                                        fun d ->
                                          fun e ->
                                            fun f ->
                                              let f_cc_17 = fun a ->
                                                fun b ->
                                                  fun c ->
                                                    fun d ->
                                                      fun e ->
                                                        fun f ->
                                                          fun g ->
                                                            let f_cc_19 = fun a ->
                                                              fun b ->
                                                                fun c ->
                                                                  fun d ->
                                                                    fun e ->
                                                                      fun f ->
                                                                        fun g ->
                                                                          fun h ->
                                                                            let f_cc_21 = fun a ->
                                                                              fun b ->
                                                                                fun c ->
                                                                                  fun d ->
                                                                                    fun e ->
                                                                                      fun f ->
                                                                                        fun g ->
                                                                                          fun h ->
                                                                                            fun i ->
                                                                                              let f_cc_23 = fun a ->
                                                                                                fun b ->
                                                                                                  fun c ->
                                                                                                    fun d ->
                                                                                                      fun e ->
                                                                                                        fun f ->
                                                                                                          fun g ->
                                                                                                            fun h ->
                                                                                                              fun i ->
                                                                                                                fun j ->
                                                                                                                  let t_6 = a + b in
                                                                                                                  let t_7 = t_6 + c in
                                                                                                                  let t_8 = t_7 + d in
                                                                                                                  let t_9 = t_8 + e in
                                                                                                                  let t_10 = t_9 + f in
                                                                                                                  let t_11 = t_10 + g in
                                                                                                                  let t_12 = t_11 + h in
                                                                                                                  let t_13 = t_12 + i in
                                                                                                                  t_13 + j in
                                                                                              let closure_cc_24 = f_cc_23 a b c d e f g h i in
                                                                                              closure_cc_24 in
                                                                            let closure_cc_22 = f_cc_21 a b c d e f g h in
                                                                            closure_cc_22 in
                                                            let closure_cc_20 = f_cc_19 a b c d e f g in
                                                            closure_cc_20 in
                                              let closure_cc_18 = f_cc_17 a b c d e f in
                                              closure_cc_18 in
                                  let closure_cc_16 = f_cc_15 a b c d e in
                                  closure_cc_16 in
                        let closure_cc_14 = f_cc_13 a b c d in
                        closure_cc_14 in
                let closure_cc_12 = f_cc_11 a b c in
                closure_cc_12 in
          let closure_cc_10 = f_cc_9 a b in
          closure_cc_10 in
      let closure_cc_8 = f_cc_7 a in
      closure_cc_8
  
  let test10 =
    test10_cc_6
  
  let main =
    let t_16 = wrap test10 1 10 100 1000 10000 100000 1000000 10000000 100000000 1000000000 in
    let rez = t_16 in
    let t_17 = print_int rez in
    let () = t_17 in
    let t_18 = wrap test3 1 10 100 in
    let temp2 = t_18 in
    0

=================== custom (after cc + ll) ===================
  $ cat >many_args_pa.ml <<EOF
  > let wrap f = if 1 = 1 then f else f
  > 
  > let test3 a b c =
  > let a = print_int a in
  > let b = print_int b in
  > let c = print_int c in
  > 0
  > 
  > let test10 a b c d e f g h i j = a + b + c + d + e + f + g + h + i + j
  > 
  > let main =
  > let rez =
  >     (wrap test10 1 10 100 1000 10000 100000 1000000 10000000 100000000
  >        1000000000)
  > in
  > let () = print_int rez in
  > let temp2 = wrap test3 1 10 100 in
  > 0
  > EOF
  $ ../../../bin/AML.exe --dump-cc-ll-anf many_args_pa.ml
  let t_0 =
    fun f ->
      let t_0 = 1 = 1 in
      if t_0 then
        f
      else
        f
  
  let t_6 =
    fun c ->
      let t_2 = print_int a in
      let a = t_2 in
      let t_3 = print_int b in
      let b = t_3 in
      let t_4 = print_int c in
      let c = t_4 in
      0
  
  let t_5 =
    fun b ->
      t_6
  
  let t_4 =
    fun a ->
      t_5
  
  let t_3 =
    fun b ->
      let f_cc_4 = t_4 in
      let closure_cc_5 = f_cc_4 a b in
      closure_cc_5
  
  let t_2 =
    fun a ->
      t_3
  
  let t_1 =
    fun a ->
      let f_cc_2 = t_2 in
      let closure_cc_3 = f_cc_2 a in
      closure_cc_3
  
  let t_61 =
    fun j ->
      let t_6 = a + b in
      let t_7 = t_6 + c in
      let t_8 = t_7 + d in
      let t_9 = t_8 + e in
      let t_10 = t_9 + f in
      let t_11 = t_10 + g in
      let t_12 = t_11 + h in
      let t_13 = t_12 + i in
      t_13 + j
  
  let t_60 =
    fun i ->
      t_61
  
  let t_59 =
    fun h ->
      t_60
  
  let t_58 =
    fun g ->
      t_59
  
  let t_57 =
    fun f ->
      t_58
  
  let t_56 =
    fun e ->
      t_57
  
  let t_55 =
    fun d ->
      t_56
  
  let t_54 =
    fun c ->
      t_55
  
  let t_53 =
    fun b ->
      t_54
  
  let t_52 =
    fun a ->
      t_53
  
  let t_51 =
    fun i ->
      let f_cc_23 = t_52 in
      let closure_cc_24 = f_cc_23 a b c d e f g h i in
      closure_cc_24
  
  let t_50 =
    fun h ->
      t_51
  
  let t_49 =
    fun g ->
      t_50
  
  let t_48 =
    fun f ->
      t_49
  
  let t_47 =
    fun e ->
      t_48
  
  let t_46 =
    fun d ->
      t_47
  
  let t_45 =
    fun c ->
      t_46
  
  let t_44 =
    fun b ->
      t_45
  
  let t_43 =
    fun a ->
      t_44
  
  let t_42 =
    fun h ->
      let f_cc_21 = t_43 in
      let closure_cc_22 = f_cc_21 a b c d e f g h in
      closure_cc_22
  
  let t_41 =
    fun g ->
      t_42
  
  let t_40 =
    fun f ->
      t_41
  
  let t_39 =
    fun e ->
      t_40
  
  let t_38 =
    fun d ->
      t_39
  
  let t_37 =
    fun c ->
      t_38
  
  let t_36 =
    fun b ->
      t_37
  
  let t_35 =
    fun a ->
      t_36
  
  let t_34 =
    fun g ->
      let f_cc_19 = t_35 in
      let closure_cc_20 = f_cc_19 a b c d e f g in
      closure_cc_20
  
  let t_33 =
    fun f ->
      t_34
  
  let t_32 =
    fun e ->
      t_33
  
  let t_31 =
    fun d ->
      t_32
  
  let t_30 =
    fun c ->
      t_31
  
  let t_29 =
    fun b ->
      t_30
  
  let t_28 =
    fun a ->
      t_29
  
  let t_27 =
    fun f ->
      let f_cc_17 = t_28 in
      let closure_cc_18 = f_cc_17 a b c d e f in
      closure_cc_18
  
  let t_26 =
    fun e ->
      t_27
  
  let t_25 =
    fun d ->
      t_26
  
  let t_24 =
    fun c ->
      t_25
  
  let t_23 =
    fun b ->
      t_24
  
  let t_22 =
    fun a ->
      t_23
  
  let t_21 =
    fun e ->
      let f_cc_15 = t_22 in
      let closure_cc_16 = f_cc_15 a b c d e in
      closure_cc_16
  
  let t_20 =
    fun d ->
      t_21
  
  let t_19 =
    fun c ->
      t_20
  
  let t_18 =
    fun b ->
      t_19
  
  let t_17 =
    fun a ->
      t_18
  
  let t_16 =
    fun d ->
      let f_cc_13 = t_17 in
      let closure_cc_14 = f_cc_13 a b c d in
      closure_cc_14
  
  let t_15 =
    fun c ->
      t_16
  
  let t_14 =
    fun b ->
      t_15
  
  let t_13 =
    fun a ->
      t_14
  
  let t_12 =
    fun c ->
      let f_cc_11 = t_13 in
      let closure_cc_12 = f_cc_11 a b c in
      closure_cc_12
  
  let t_11 =
    fun b ->
      t_12
  
  let t_10 =
    fun a ->
      t_11
  
  let t_9 =
    fun b ->
      let f_cc_9 = t_10 in
      let closure_cc_10 = f_cc_9 a b in
      closure_cc_10
  
  let t_8 =
    fun a ->
      t_9
  
  let t_7 =
    fun a ->
      let f_cc_7 = t_8 in
      let closure_cc_8 = f_cc_7 a in
      closure_cc_8
  
  let wrap_cc_0 =
    t_0
  
  let wrap =
    wrap_cc_0
  
  let test3_cc_1 =
    t_1
  
  let test3 =
    test3_cc_1
  
  let test10_cc_6 =
    t_7
  
  let test10 =
    test10_cc_6
  
  let main =
    let t_16 = wrap test10 1 10 100 1000 10000 100000 1000000 10000000 100000000 1000000000 in
    let rez = t_16 in
    let t_17 = print_int rez in
    let () = t_17 in
    let t_18 = wrap test3 1 10 100 in
    let temp2 = t_18 in
    0


=================== faccps_ll (before cc + ll) ===================
  $ ../../../bin/AML.exe --dump-anf ./manytests/typed/010faccps_ll.ml
  let id =
    fun x ->
      x
  
  let fresh_1 =
    fun n ->
      fun k ->
        fun p ->
          let t_1 = p * n in
          k t_1
  
  let rec fac_cps =
    fun n ->
      fun k ->
        let t_4 = n = 1 in
        if t_4 then
          k 1
        else
          let t_6 = n - 1 in
          let t_7 = fresh_1 n k in
          fac_cps t_6 t_7
  
  let main =
    let t_10 = fac_cps 4 id in
    let t_11 = print_int t_10 in
    let t_12 = t_11 in
    0




=================== faccps_ll (after cc, before ll) ===================
  $ ../../../bin/AML.exe --dump-cc-anf ./manytests/typed/010faccps_ll.ml
  let id_cc_0 =
    fun x ->
      x
  
  let id =
    id_cc_0
  
  let fresh_1_cc_1 =
    fun n ->
      let f_cc_2 = fun n ->
        fun k ->
          let f_cc_4 = fun k ->
            fun n ->
              fun p ->
                let t_1 = p * n in
                k t_1 in
          let closure_cc_5 = f_cc_4 k n in
          closure_cc_5 in
      let closure_cc_3 = f_cc_2 n in
      closure_cc_3
  
  let fresh_1 =
    fresh_1_cc_1
  
  let rec fac_cps_cc_6 =
    fun fresh_1 ->
      fun n ->
        let f_cc_7 = fun fresh_1 ->
          fun n ->
            fun k ->
              let t_4 = n = 1 in
              if t_4 then
                k 1
              else
                let t_6 = n - 1 in
                let t_7 = fresh_1 n k in
                fac_cps_cc_6 t_6 t_7 in
        let closure_cc_8 = f_cc_7 fresh_1 n in
        closure_cc_8
  
  let fac_cps =
    fac_cps_cc_6 fresh_1
  
  let main =
    let t_10 = fac_cps 4 id in
    let t_11 = print_int t_10 in
    let t_12 = t_11 in
    0



=================== faccps_ll (after cc + ll) ===================
  $ ../../../bin/AML.exe --dump-cc-ll-anf ./manytests/typed/010faccps_ll.ml
  let t_0 =
    fun x ->
      x
  
  let t_6 =
    fun p ->
      let t_1 = p * n in
      k t_1
  
  let t_5 =
    fun n ->
      t_6
  
  let t_4 =
    fun k ->
      t_5
  
  let t_3 =
    fun k ->
      let f_cc_4 = t_4 in
      let closure_cc_5 = f_cc_4 k n in
      closure_cc_5
  
  let t_2 =
    fun n ->
      t_3
  
  let t_1 =
    fun n ->
      let f_cc_2 = t_2 in
      let closure_cc_3 = f_cc_2 n in
      closure_cc_3
  
  let t_11 =
    fun k ->
      let t_4 = n = 1 in
      if t_4 then
        k 1
      else
        let t_6 = n - 1 in
        let t_7 = fresh_1 n k in
        fac_cps_cc_6 t_6 t_7
  
  let t_10 =
    fun n ->
      t_11
  
  let t_9 =
    fun fresh_1 ->
      t_10
  
  let t_8 =
    fun n ->
      let f_cc_7 = t_9 in
      let closure_cc_8 = f_cc_7 fresh_1 n in
      closure_cc_8
  
  let t_7 =
    fun fresh_1 ->
      t_8
  
  let id_cc_0 =
    t_0
  
  let id =
    id_cc_0
  
  let fresh_1_cc_1 =
    t_1
  
  let fresh_1 =
    fresh_1_cc_1
  
  let rec fac_cps_cc_6 =
    t_7
  
  let fac_cps =
    fac_cps_cc_6 fresh_1
  
  let main =
    let t_10 = fac_cps 4 id in
    let t_11 = print_int t_10 in
    let t_12 = t_11 in
    0





=================== faccps (before cc + ll) ===================
  $ ../../../bin/AML.exe --dump-anf ./manytests/typed/012faccps.ml
  let rec fac =
    fun n ->
      fun k ->
        let t_0 = n < 2 in
        if t_0 then
          k 1
        else
          let t_2 = n - 1 in
          let t_5 = fun a ->
            let t_3 = a * n in
            k t_3 in
          fac t_2 t_5
  
  let main =
    let t_8 = fun x ->
      x in
    let t_9 = fac 6 t_8 in
    print_int t_9

=================== faccps (after cc, before ll) ===================
  $ ../../../bin/AML.exe --dump-cc-anf ./manytests/typed/012faccps.ml
  let rec fac_cc_0 =
    fun n ->
      let f_cc_1 = fun n ->
        fun k ->
          let t_0 = n < 2 in
          if t_0 then
            k 1
          else
            let t_2 = n - 1 in
            let t_5_cc_3 = fun k ->
              fun n ->
                fun a ->
                  let t_3 = a * n in
                  k t_3 in
            let t_5 = t_5_cc_3 k n in
            fac_cc_0 t_2 t_5 in
      let closure_cc_2 = f_cc_1 n in
      closure_cc_2
  
  let fac =
    fac_cc_0
  
  let main =
    let t_8_cc_4 = fun x ->
      x in
    let t_8 = t_8_cc_4 in
    let t_9 = fac 6 t_8 in
    print_int t_9

=================== faccps (after cc + ll) ===================
  $ ../../../bin/AML.exe --dump-cc-ll-anf ./manytests/typed/012faccps.ml
  let t_5 =
    fun a ->
      let t_3 = a * n in
      k t_3
  
  let t_4 =
    fun n ->
      t_5
  
  let t_3 =
    fun k ->
      t_4
  
  let t_2 =
    fun k ->
      let t_0 = n < 2 in
      if t_0 then
        k 1
      else
        let t_2 = n - 1 in
        let t_5_cc_3 = t_3 in
        let t_5 = t_5_cc_3 k n in
        fac_cc_0 t_2 t_5
  
  let t_1 =
    fun n ->
      t_2
  
  let t_0 =
    fun n ->
      let f_cc_1 = t_1 in
      let closure_cc_2 = f_cc_1 n in
      closure_cc_2
  
  let t_6 =
    fun x ->
      x
  
  let rec fac_cc_0 =
    t_0
  
  let fac =
    fac_cc_0
  
  let main =
    let t_8_cc_4 = t_6 in
    let t_8 = t_8_cc_4 in
    let t_9 = fac 6 t_8 in
    print_int t_9








=================== fac (before cc + ll) ===================
  $ ../../../bin/AML.exe --dump-anf ./manytests/typed/fac.ml
  let rec fib =
    fun n ->
      fun k ->
        let t_0 = n < 2 in
        if t_0 then
          k n
        else
          let t_2 = n - 1 in
          let t_8 = fun a ->
            let t_3 = n - 2 in
            let t_6 = fun b ->
              let t_4 = a + b in
              k t_4 in
            fib t_3 t_6 in
          fib t_2 t_8
  
  let main =
    let t_11 = fun x ->
      x in
    let t_12 = fib 6 t_11 in
    print_int t_12



=================== fac (after cc, before ll) ===================
  $ ../../../bin/AML.exe --dump-cc-anf ./manytests/typed/fac.ml
  let rec fib_cc_0 =
    fun n ->
      let f_cc_1 = fun n ->
        fun k ->
          let t_0 = n < 2 in
          if t_0 then
            k n
          else
            let t_2 = n - 1 in
            let t_8_cc_3 = fun k ->
              fun n ->
                fun a ->
                  let t_3 = n - 2 in
                  let t_6_cc_4 = fun a ->
                    fun k ->
                      fun b ->
                        let t_4 = a + b in
                        k t_4 in
                  let t_6 = t_6_cc_4 a k in
                  fib_cc_0 t_3 t_6 in
            let t_8 = t_8_cc_3 k n in
            fib_cc_0 t_2 t_8 in
      let closure_cc_2 = f_cc_1 n in
      closure_cc_2
  
  let fib =
    fib_cc_0
  
  let main =
    let t_11_cc_5 = fun x ->
      x in
    let t_11 = t_11_cc_5 in
    let t_12 = fib 6 t_11 in
    print_int t_12


=================== fac (after cc + ll) ===================
  $ ../../../bin/AML.exe --dump-cc-ll-anf ./manytests/typed/fac.ml
  let t_8 =
    fun b ->
      let t_4 = a + b in
      k t_4
  
  let t_7 =
    fun k ->
      t_8
  
  let t_6 =
    fun a ->
      t_7
  
  let t_5 =
    fun a ->
      let t_3 = n - 2 in
      let t_6_cc_4 = t_6 in
      let t_6 = t_6_cc_4 a k in
      fib_cc_0 t_3 t_6
  
  let t_4 =
    fun n ->
      t_5
  
  let t_3 =
    fun k ->
      t_4
  
  let t_2 =
    fun k ->
      let t_0 = n < 2 in
      if t_0 then
        k n
      else
        let t_2 = n - 1 in
        let t_8_cc_3 = t_3 in
        let t_8 = t_8_cc_3 k n in
        fib_cc_0 t_2 t_8
  
  let t_1 =
    fun n ->
      t_2
  
  let t_0 =
    fun n ->
      let f_cc_1 = t_1 in
      let closure_cc_2 = f_cc_1 n in
      closure_cc_2
  
  let t_9 =
    fun x ->
      x
  
  let rec fib_cc_0 =
    t_0
  
  let fib =
    fib_cc_0
  
  let main =
    let t_11_cc_5 = t_9 in
    let t_11 = t_11_cc_5 in
    let t_12 = fib 6 t_11 in
    print_int t_12


