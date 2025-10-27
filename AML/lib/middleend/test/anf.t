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
          let t_0 = p * n in
          k t_0
  
  let rec fac_cps =
    fun n ->
      fun k ->
        let t_2 = n = 1 in
        if t_2 then
          k 1
        else
          let t_4 = n - 1 in
          let t_5 = fresh_1 n k in
          fac_cps t_4 t_5
  
  let main =
    let t_7 = fac_cps 4 id in
    let t_8 = print_int t_7 in
    let t_9 = t_8 in
    0
  $ ../../../bin/AML.exe --dump-anf ./manytests/typed/010fibcps_ll.ml
  let id =
    fun x ->
      x
  
  let fresh_2 =
    fun p1 ->
      fun k ->
        fun p2 ->
          let t_0 = p1 + p2 in
          k t_0
  
  let fresh_1 =
    fun n ->
      fun k ->
        fun fib ->
          fun p1 ->
            let t_2 = n - 2 in
            let t_3 = fresh_2 p1 k in
            fib t_2 t_3
  
  let rec fib =
    fun n ->
      fun k ->
        let t_5 = n < 2 in
        if t_5 then
          k n
        else
          let t_7 = n - 1 in
          let t_8 = fresh_1 n k fib in
          fib t_7 t_8
  
  let main =
    let t_10 = fib 6 id in
    let t_11 = print_int t_10 in
    let z = t_11 in
    0
