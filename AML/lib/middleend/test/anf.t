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
  let wrap__0_cc_0 =
    fun f__1 ->
      let t_0__2 = 1 = 1 in
      if t_0__2 then
        f__1
      else
        f__1
  
  let wrap__0 =
    wrap__0_cc_0
  
  let test3__3_cc_1 =
    fun a__4 ->
      let f_cc_2 = fun a__4 ->
        fun b__5 ->
          let f_cc_4 = fun a__4 ->
            fun b__5 ->
              fun c__6 ->
                let t_2__7 = print_int a__4 in
                let a__8 = t_2__7 in
                let t_3__9 = print_int b__5 in
                let b__10 = t_3__9 in
                let t_4__11 = print_int c__6 in
                let c__12 = t_4__11 in
                0 in
          let closure_cc_5 = f_cc_4 a__4 b__5 in
          closure_cc_5 in
      let closure_cc_3 = f_cc_2 a__4 in
      closure_cc_3
  
  let test3__3 =
    test3__3_cc_1
  
  let test10__13_cc_6 =
    fun a__14 ->
      let f_cc_7 = fun a__14 ->
        fun b__15 ->
          let f_cc_9 = fun a__14 ->
            fun b__15 ->
              fun c__16 ->
                let f_cc_11 = fun a__14 ->
                  fun b__15 ->
                    fun c__16 ->
                      fun d__17 ->
                        let f_cc_13 = fun a__14 ->
                          fun b__15 ->
                            fun c__16 ->
                              fun d__17 ->
                                fun e__18 ->
                                  let f_cc_15 = fun a__14 ->
                                    fun b__15 ->
                                      fun c__16 ->
                                        fun d__17 ->
                                          fun e__18 ->
                                            fun f__19 ->
                                              let f_cc_17 = fun a__14 ->
                                                fun b__15 ->
                                                  fun c__16 ->
                                                    fun d__17 ->
                                                      fun e__18 ->
                                                        fun f__19 ->
                                                          fun g__20 ->
                                                            let f_cc_19 = fun a__14 ->
                                                              fun b__15 ->
                                                                fun c__16 ->
                                                                  fun d__17 ->
                                                                    fun e__18 ->
                                                                      fun f__19 ->
                                                                        fun g__20 ->
                                                                          fun h__21 ->
                                                                            let f_cc_21 = fun a__14 ->
                                                                              fun b__15 ->
                                                                                fun c__16 ->
                                                                                  fun d__17 ->
                                                                                    fun e__18 ->
                                                                                      fun f__19 ->
                                                                                        fun g__20 ->
                                                                                          fun h__21 ->
                                                                                            fun i__22 ->
                                                                                              let f_cc_23 = fun a__14 ->
                                                                                                fun b__15 ->
                                                                                                  fun c__16 ->
                                                                                                    fun d__17 ->
                                                                                                      fun e__18 ->
                                                                                                        fun f__19 ->
                                                                                                          fun g__20 ->
                                                                                                            fun h__21 ->
                                                                                                              fun i__22 ->
                                                                                                                fun j__23 ->
                                                                                                                  let t_6__24 = a__14 + b__15 in
                                                                                                                  let t_7__25 = t_6__24 + c__16 in
                                                                                                                  let t_8__26 = t_7__25 + d__17 in
                                                                                                                  let t_9__27 = t_8__26 + e__18 in
                                                                                                                  let t_10__28 = t_9__27 + f__19 in
                                                                                                                  let t_11__29 = t_10__28 + g__20 in
                                                                                                                  let t_12__30 = t_11__29 + h__21 in
                                                                                                                  let t_13__31 = t_12__30 + i__22 in
                                                                                                                  t_13__31 + j__23 in
                                                                                              let closure_cc_24 = f_cc_23 a__14 b__15 c__16 d__17 e__18 f__19 g__20 h__21 i__22 in
                                                                                              closure_cc_24 in
                                                                            let closure_cc_22 = f_cc_21 a__14 b__15 c__16 d__17 e__18 f__19 g__20 h__21 in
                                                                            closure_cc_22 in
                                                            let closure_cc_20 = f_cc_19 a__14 b__15 c__16 d__17 e__18 f__19 g__20 in
                                                            closure_cc_20 in
                                              let closure_cc_18 = f_cc_17 a__14 b__15 c__16 d__17 e__18 f__19 in
                                              closure_cc_18 in
                                  let closure_cc_16 = f_cc_15 a__14 b__15 c__16 d__17 e__18 in
                                  closure_cc_16 in
                        let closure_cc_14 = f_cc_13 a__14 b__15 c__16 d__17 in
                        closure_cc_14 in
                let closure_cc_12 = f_cc_11 a__14 b__15 c__16 in
                closure_cc_12 in
          let closure_cc_10 = f_cc_9 a__14 b__15 in
          closure_cc_10 in
      let closure_cc_8 = f_cc_7 a__14 in
      closure_cc_8
  
  let test10__13 =
    test10__13_cc_6
  
  let main__32 =
    let t_16__33 = wrap__0 test10__13 1 10 100 1000 10000 100000 1000000 10000000 100000000 1000000000 in
    let rez__34 = t_16__33 in
    let t_17__35 = print_int rez__34 in
    let ()__36 = t_17__35 in
    let t_18__37 = wrap__0 test3__3 1 10 100 in
    let temp2__38 = t_18__37 in
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
    fun f__1 ->
      let t_0__2 = 1 = 1 in
      if t_0__2 then
        f__1
      else
        f__1
  
  let t_10 =
    fun a__14 ->
      fun b__15 ->
        fun c__16 ->
          fun d__17 ->
            fun e__18 ->
              fun f__19 ->
                fun g__20 ->
                  fun h__21 ->
                    fun i__22 ->
                      fun j__23 ->
                        let t_6__24 = a__14 + b__15 in
                        let t_7__25 = t_6__24 + c__16 in
                        let t_8__26 = t_7__25 + d__17 in
                        let t_9__27 = t_8__26 + e__18 in
                        let t_10__28 = t_9__27 + f__19 in
                        let t_11__29 = t_10__28 + g__20 in
                        let t_12__30 = t_11__29 + h__21 in
                        let t_13__31 = t_12__30 + i__22 in
                        t_13__31 + j__23
  
  let t_9 =
    fun a__14 ->
      fun b__15 ->
        fun c__16 ->
          fun d__17 ->
            fun e__18 ->
              fun f__19 ->
                fun g__20 ->
                  fun h__21 ->
                    fun i__22 ->
                      let f_cc_23 = t_10 in
                      let closure_cc_24 = f_cc_23 a__14 b__15 c__16 d__17 e__18 f__19 g__20 h__21 i__22 in
                      closure_cc_24
  
  let t_8 =
    fun a__14 ->
      fun b__15 ->
        fun c__16 ->
          fun d__17 ->
            fun e__18 ->
              fun f__19 ->
                fun g__20 ->
                  fun h__21 ->
                    let f_cc_21 = t_9 in
                    let closure_cc_22 = f_cc_21 a__14 b__15 c__16 d__17 e__18 f__19 g__20 h__21 in
                    closure_cc_22
  
  let t_7 =
    fun a__14 ->
      fun b__15 ->
        fun c__16 ->
          fun d__17 ->
            fun e__18 ->
              fun f__19 ->
                fun g__20 ->
                  let f_cc_19 = t_8 in
                  let closure_cc_20 = f_cc_19 a__14 b__15 c__16 d__17 e__18 f__19 g__20 in
                  closure_cc_20
  
  let t_6 =
    fun a__14 ->
      fun b__15 ->
        fun c__16 ->
          fun d__17 ->
            fun e__18 ->
              fun f__19 ->
                let f_cc_17 = t_7 in
                let closure_cc_18 = f_cc_17 a__14 b__15 c__16 d__17 e__18 f__19 in
                closure_cc_18
  
  let t_5 =
    fun a__14 ->
      fun b__15 ->
        fun c__16 ->
          fun d__17 ->
            fun e__18 ->
              let f_cc_15 = t_6 in
              let closure_cc_16 = f_cc_15 a__14 b__15 c__16 d__17 e__18 in
              closure_cc_16
  
  let t_4 =
    fun a__14 ->
      fun b__15 ->
        fun c__16 ->
          fun d__17 ->
            let f_cc_13 = t_5 in
            let closure_cc_14 = f_cc_13 a__14 b__15 c__16 d__17 in
            closure_cc_14
  
  let t_3 =
    fun a__14 ->
      fun b__15 ->
        fun c__16 ->
          let f_cc_11 = t_4 in
          let closure_cc_12 = f_cc_11 a__14 b__15 c__16 in
          closure_cc_12
  
  let t_2 =
    fun a__14 ->
      fun b__15 ->
        let f_cc_9 = t_3 in
        let closure_cc_10 = f_cc_9 a__14 b__15 in
        closure_cc_10
  
  let t_1 =
    fun a__14 ->
      let f_cc_7 = t_2 in
      let closure_cc_8 = f_cc_7 a__14 in
      closure_cc_8
  
  let wrap__0_cc_0 =
    t_0
  
  let wrap__0 =
    wrap__0_cc_0
  
  let test3__3_cc_1 =
    fun a__4 ->
      let f_cc_2 = fun a__4 ->
        fun b__5 ->
          let f_cc_4 = fun a__4 ->
            fun b__5 ->
              fun c__6 ->
                let t_2__7 = print_int a__4 in
                let a__8 = t_2__7 in
                let t_3__9 = print_int b__5 in
                let b__10 = t_3__9 in
                let t_4__11 = print_int c__6 in
                let c__12 = t_4__11 in
                0 in
          let closure_cc_5 = f_cc_4 a__4 b__5 in
          closure_cc_5 in
      let closure_cc_3 = f_cc_2 a__4 in
      closure_cc_3
  
  let test3__3 =
    test3__3_cc_1
  
  let test10__13_cc_6 =
    t_1
  
  let test10__13 =
    test10__13_cc_6
  
  let main__32 =
    let t_16__33 = wrap__0 test10__13 1 10 100 1000 10000 100000 1000000 10000000 100000000 1000000000 in
    let rez__34 = t_16__33 in
    let t_17__35 = print_int rez__34 in
    let ()__36 = t_17__35 in
    let t_18__37 = wrap__0 test3__3 1 10 100 in
    let temp2__38 = t_18__37 in
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
  let id__0_cc_0 =
    fun x__1 ->
      x__1
  
  let id__0 =
    id__0_cc_0
  
  let fresh_1__2_cc_1 =
    fun n__3 ->
      let f_cc_2 = fun n__3 ->
        fun k__4 ->
          let f_cc_4 = fun k__4 ->
            fun n__3 ->
              fun p__5 ->
                let t_1__6 = p__5 * n__3 in
                k__4 t_1__6 in
          let closure_cc_5 = f_cc_4 k__4 n__3 in
          closure_cc_5 in
      let closure_cc_3 = f_cc_2 n__3 in
      closure_cc_3
  
  let fresh_1__2 =
    fresh_1__2_cc_1
  
  let fac_cps__7_cc_6 =
    fun fac_cps__7 ->
      fun fresh_1__2 ->
        fun n__8 ->
          let f_cc_7 = fun fac_cps__7 ->
            fun fresh_1__2 ->
              fun n__8 ->
                fun k__9 ->
                  let t_4__10 = n__8 = 1 in
                  if t_4__10 then
                    k__9 1
                  else
                    let t_6__11 = n__8 - 1 in
                    let t_7__12 = fresh_1__2 n__8 k__9 in
                    fac_cps__7 t_6__11 t_7__12 in
          let closure_cc_8 = f_cc_7 fac_cps__7 fresh_1__2 n__8 in
          closure_cc_8
  
  let rec fac_cps__7 =
    fun n__8 ->
      fac_cps__7_cc_6 fac_cps__7 fresh_1__2 n__8
  
  let main__13 =
    let t_10__14 = fac_cps__7 4 id__0 in
    let t_11__15 = print_int t_10__14 in
    let t_12__16 = t_11__15 in
    0



=================== faccps_ll (after cc + ll) ===================
  $ ../../../bin/AML.exe --dump-cc-ll-anf ./manytests/typed/010faccps_ll.ml
  let t_0 =
    fun x__1 ->
      x__1
  
  let t_3 =
    fun k__4 ->
      fun n__3 ->
        fun p__5 ->
          let t_1__6 = p__5 * n__3 in
          k__4 t_1__6
  
  let t_2 =
    fun n__3 ->
      fun k__4 ->
        let f_cc_4 = t_3 in
        let closure_cc_5 = f_cc_4 k__4 n__3 in
        closure_cc_5
  
  let t_1 =
    fun n__3 ->
      let f_cc_2 = t_2 in
      let closure_cc_3 = f_cc_2 n__3 in
      closure_cc_3
  
  let t_5 =
    fun fac_cps__7 ->
      fun fresh_1__2 ->
        fun n__8 ->
          fun k__9 ->
            let t_4__10 = n__8 = 1 in
            if t_4__10 then
              k__9 1
            else
              let t_6__11 = n__8 - 1 in
              let t_7__12 = fresh_1__2 n__8 k__9 in
              fac_cps__7 t_6__11 t_7__12
  
  let t_4 =
    fun fac_cps__7 ->
      fun fresh_1__2 ->
        fun n__8 ->
          let f_cc_7 = t_5 in
          let closure_cc_8 = f_cc_7 fac_cps__7 fresh_1__2 n__8 in
          closure_cc_8
  
  let id__0_cc_0 =
    t_0
  
  let id__0 =
    id__0_cc_0
  
  let fresh_1__2_cc_1 =
    t_1
  
  let fresh_1__2 =
    fresh_1__2_cc_1
  
  let fac_cps__7_cc_6 =
    t_4
  
  let rec fac_cps__7 =
    fun n__8 ->
      fac_cps__7_cc_6 fac_cps__7 fresh_1__2 n__8
  
  let main__13 =
    let t_10__14 = fac_cps__7 4 id__0 in
    let t_11__15 = print_int t_10__14 in
    let t_12__16 = t_11__15 in
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
  let fac__0_cc_0 =
    fun fac__0 ->
      fun n__1 ->
        let f_cc_1 = fun fac__0 ->
          fun n__1 ->
            fun k__2 ->
              let t_0__3 = n__1 < 2 in
              if t_0__3 then
                k__2 1
              else
                let t_2__4 = n__1 - 1 in
                let t_5__7_cc_3 = fun k__2 ->
                  fun n__1 ->
                    fun a__5 ->
                      let t_3__6 = a__5 * n__1 in
                      k__2 t_3__6 in
                let t_5__7 = t_5__7_cc_3 k__2 n__1 in
                fac__0 t_2__4 t_5__7 in
        let closure_cc_2 = f_cc_1 fac__0 n__1 in
        closure_cc_2
  
  let rec fac__0 =
    fun n__1 ->
      fac__0_cc_0 fac__0 n__1
  
  let main__8 =
    let t_8__10_cc_4 = fun x__9 ->
      x__9 in
    let t_8__10 = t_8__10_cc_4 in
    let t_9__11 = fac__0 6 t_8__10 in
    print_int t_9__11

=================== faccps (after cc + ll) ===================
  $ ../../../bin/AML.exe --dump-cc-ll-anf ./manytests/typed/012faccps.ml
  let t_2 =
    fun k__2 ->
      fun n__1 ->
        fun a__5 ->
          let t_3__6 = a__5 * n__1 in
          k__2 t_3__6
  
  let t_1 =
    fun fac__0 ->
      fun n__1 ->
        fun k__2 ->
          let t_0__3 = n__1 < 2 in
          if t_0__3 then
            k__2 1
          else
            let t_2__4 = n__1 - 1 in
            let t_5__7_cc_3 = t_2 in
            let t_5__7 = t_5__7_cc_3 k__2 n__1 in
            fac__0 t_2__4 t_5__7
  
  let t_0 =
    fun fac__0 ->
      fun n__1 ->
        let f_cc_1 = t_1 in
        let closure_cc_2 = f_cc_1 fac__0 n__1 in
        closure_cc_2
  
  let t_3 =
    fun x__9 ->
      x__9
  
  let fac__0_cc_0 =
    t_0
  
  let rec fac__0 =
    fun n__1 ->
      fac__0_cc_0 fac__0 n__1
  
  let main__8 =
    let t_8__10_cc_4 = t_3 in
    let t_8__10 = t_8__10_cc_4 in
    let t_9__11 = fac__0 6 t_8__10 in
    print_int t_9__11

==== 4 task fact no cc no ll ====
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

==== 4 task fact no ll ====
  $ ../../../bin/AML.exe --dump-cc-anf ./manytests/typed/012faccps.ml
  let fac__0_cc_0 =
    fun fac__0 ->
      fun n__1 ->
        let f_cc_1 = fun fac__0 ->
          fun n__1 ->
            fun k__2 ->
              let t_0__3 = n__1 < 2 in
              if t_0__3 then
                k__2 1
              else
                let t_2__4 = n__1 - 1 in
                let t_5__7_cc_3 = fun k__2 ->
                  fun n__1 ->
                    fun a__5 ->
                      let t_3__6 = a__5 * n__1 in
                      k__2 t_3__6 in
                let t_5__7 = t_5__7_cc_3 k__2 n__1 in
                fac__0 t_2__4 t_5__7 in
        let closure_cc_2 = f_cc_1 fac__0 n__1 in
        closure_cc_2
  
  let rec fac__0 =
    fun n__1 ->
      fac__0_cc_0 fac__0 n__1
  
  let main__8 =
    let t_8__10_cc_4 = fun x__9 ->
      x__9 in
    let t_8__10 = t_8__10_cc_4 in
    let t_9__11 = fac__0 6 t_8__10 in
    print_int t_9__11
==== 4 task fact ====
  $ ../../../bin/AML.exe --dump-cc-ll-anf ./manytests/typed/012faccps.ml
  let t_2 =
    fun k__2 ->
      fun n__1 ->
        fun a__5 ->
          let t_3__6 = a__5 * n__1 in
          k__2 t_3__6
  
  let t_1 =
    fun fac__0 ->
      fun n__1 ->
        fun k__2 ->
          let t_0__3 = n__1 < 2 in
          if t_0__3 then
            k__2 1
          else
            let t_2__4 = n__1 - 1 in
            let t_5__7_cc_3 = t_2 in
            let t_5__7 = t_5__7_cc_3 k__2 n__1 in
            fac__0 t_2__4 t_5__7
  
  let t_0 =
    fun fac__0 ->
      fun n__1 ->
        let f_cc_1 = t_1 in
        let closure_cc_2 = f_cc_1 fac__0 n__1 in
        closure_cc_2
  
  let t_3 =
    fun x__9 ->
      x__9
  
  let fac__0_cc_0 =
    t_0
  
  let rec fac__0 =
    fun n__1 ->
      fac__0_cc_0 fac__0 n__1
  
  let main__8 =
    let t_8__10_cc_4 = t_3 in
    let t_8__10 = t_8__10_cc_4 in
    let t_9__11 = fac__0 6 t_8__10 in
    print_int t_9__11

==== 4 task fib no cc no ll ====
  $ ../../../bin/AML.exe --dump-anf ./manytests/typed/012fibcps.ml
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

==== 4 task fib no ll ====
  $ ../../../bin/AML.exe --dump-cc-anf ./manytests/typed/012fibcps.ml
  let fib__0_cc_0 =
    fun fib__0 ->
      fun n__1 ->
        let f_cc_1 = fun fib__0 ->
          fun n__1 ->
            fun k__2 ->
              let t_0__3 = n__1 < 2 in
              if t_0__3 then
                k__2 n__1
              else
                let t_2__4 = n__1 - 1 in
                let t_8__10_cc_3 = fun fib__0 ->
                  fun k__2 ->
                    fun n__1 ->
                      fun a__5 ->
                        let t_3__6 = n__1 - 2 in
                        let t_6__9_cc_4 = fun a__5 ->
                          fun k__2 ->
                            fun b__7 ->
                              let t_4__8 = a__5 + b__7 in
                              k__2 t_4__8 in
                        let t_6__9 = t_6__9_cc_4 a__5 k__2 in
                        fib__0 t_3__6 t_6__9 in
                let t_8__10 = t_8__10_cc_3 fib__0 k__2 n__1 in
                fib__0 t_2__4 t_8__10 in
        let closure_cc_2 = f_cc_1 fib__0 n__1 in
        closure_cc_2
  
  let rec fib__0 =
    fun n__1 ->
      fib__0_cc_0 fib__0 n__1
  
  let main__11 =
    let t_11__13_cc_5 = fun x__12 ->
      x__12 in
    let t_11__13 = t_11__13_cc_5 in
    let t_12__14 = fib__0 6 t_11__13 in
    print_int t_12__14
==== 4 task fib ====
  $ ../../../bin/AML.exe --dump-cc-ll-anf ./manytests/typed/012fibcps.ml
  let t_3 =
    fun a__5 ->
      fun k__2 ->
        fun b__7 ->
          let t_4__8 = a__5 + b__7 in
          k__2 t_4__8
  
  let t_2 =
    fun fib__0 ->
      fun k__2 ->
        fun n__1 ->
          fun a__5 ->
            let t_3__6 = n__1 - 2 in
            let t_6__9_cc_4 = t_3 in
            let t_6__9 = t_6__9_cc_4 a__5 k__2 in
            fib__0 t_3__6 t_6__9
  
  let t_1 =
    fun fib__0 ->
      fun n__1 ->
        fun k__2 ->
          let t_0__3 = n__1 < 2 in
          if t_0__3 then
            k__2 n__1
          else
            let t_2__4 = n__1 - 1 in
            let t_8__10_cc_3 = t_2 in
            let t_8__10 = t_8__10_cc_3 fib__0 k__2 n__1 in
            fib__0 t_2__4 t_8__10
  
  let t_0 =
    fun fib__0 ->
      fun n__1 ->
        let f_cc_1 = t_1 in
        let closure_cc_2 = f_cc_1 fib__0 n__1 in
        closure_cc_2
  
  let t_4 =
    fun x__12 ->
      x__12
  
  let fib__0_cc_0 =
    t_0
  
  let rec fib__0 =
    fun n__1 ->
      fib__0_cc_0 fib__0 n__1
  
  let main__11 =
    let t_11__13_cc_5 = t_4 in
    let t_11__13 = t_11__13_cc_5 in
    let t_12__14 = fib__0 6 t_11__13 in
    print_int t_12__14
