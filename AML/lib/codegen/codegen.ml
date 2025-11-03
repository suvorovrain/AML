(** Copyright 2025-2026, Rodion Suvorov, Dmitriy Chirkov*)

(** SPDX-License-Identifier: LGPL-3.0-or-later *)

open Base
open Machine
open Ast
open Ast.Pattern
open Middle.Anf_types

type location =
  | Loc_reg of reg
  | Loc_mem of reg

let _ = Loc_reg (A 1)

type env = (ident, location, String.comparator_witness) Map.t

type cg_state =
  { env : env
  ; frame_offset : int
  ; label_id : int
  ; instructions : instr list
  ; arity_map : (ident, int, String.comparator_witness) Map.t
  }

module Codegen = struct
  type 'a t = Cg of (cg_state -> ('a, string) Result.t * cg_state)

  let run (state : cg_state) (Cg f) : ('a, string) Result.t * cg_state = f state
  let return x = Cg (fun state -> Ok x, state)
  let error msg = Cg (fun state -> Error msg, state)

  let ( let* ) (Cg m) f =
    Cg
      (fun state ->
        match m state with
        | Error msg, st -> Error msg, st
        | Ok res, new_state ->
          let (Cg m') = f res in
          m' new_state)
  ;;

  let ( >> ) (m1 : unit t) (m2 : 'a t) : 'a t =
    let* () = m1 in
    m2
  ;;

  let get_state = Cg (fun state -> Ok state, state)
  let set_state new_state = Cg (fun _ -> Ok (), new_state)

  let emit instr =
    let k instr =
      let* state = get_state in
      set_state { state with instructions = instr :: state.instructions }
    in
    instr k
  ;;

  let rec map_m f = function
    | [] -> return ()
    | x :: xs ->
      let* () = f x in
      map_m f xs
  ;;
end

open Codegen

let align16 n = if n land 15 = 0 then n else n + (16 - (n land 15))

let fresh_label prefix =
  let* state = get_state in
  let id = state.label_id in
  let* () = set_state { state with label_id = id + 1 } in
  return (Printf.sprintf ".L%s_%d" prefix id)
;;

let fresh_fun_symbol () =
  let* st = get_state in
  let id = st.label_id in
  let* () = set_state { st with label_id = id + 1 } in
  return (Printf.sprintf "lam_%d" id)
;;

let allocate_local_var id =
  let* state = get_state in
  let new_offset = state.frame_offset + 8 in
  let location = ROff (-new_offset, fp) in
  let new_env = Map.set state.env ~key:id ~data:(Loc_mem location) in
  let* () = set_state { state with frame_offset = new_offset; env = new_env } in
  return location
;;

let a_gen_bin_op op dst r1 r2 =
  match op with
  | Add -> emit add dst r1 r2
  | Sub -> emit sub dst r1 r2
  | Mul -> emit mul dst r1 r2
  | Le -> emit slt dst r2 r1 >> emit xori dst dst 1
  | Lt -> emit slt dst r1 r2
  | Eq ->
    emit sub t2 r1 r2
    >> emit slt dst x0 t2
    >> emit slt t3 t2 x0
    >> emit add dst dst t3
    >> emit xori dst dst 1
  | Neq ->
    emit sub t2 r1 r2 >> emit slt dst x0 t2 >> emit slt t3 t2 x0 >> emit add dst dst t3
;;

let live_caller_regs_excluding_abi : reg list Codegen.t =
  let* st = get_state in
  Map.to_alist st.env
  |> List.filter_map ~f:(fun (_, loc) ->
    match loc with
    | Loc_reg ((A _ | T _) as r) -> Some r
    | _ -> None)
  |> List.dedup_and_sort ~compare:Poly.compare
  |> List.filter ~f:(fun r -> not (equal_reg r a0 || equal_reg r a1 || equal_reg r a2))
  |> return
;;

let save_regs (rs : reg list) : reg list Codegen.t =
  map_m (fun r -> emit addi sp sp (-8) >> emit sd r (ROff (0, sp))) rs >> return rs
;;

let restore_regs (rs : reg list) : unit Codegen.t =
  map_m (fun r -> emit ld r (ROff (0, sp)) >> emit addi sp sp 8) (List.rev rs)
  >> return ()
;;

type argv_slot =
  | ArgvA1
  | ArgvA2

let rec with_call_frame (argv : argv_slot) (args : immexpr list) (k : unit Codegen.t)
  : unit Codegen.t
  =
  let argc = List.length args in
  let* lives = live_caller_regs_excluding_abi in
  let saved_cnt = List.length lives in
  let need_pad = (saved_cnt + argc) land 1 = 1 in
  let* _ = save_regs lives in
  (if need_pad then emit addi sp sp (-8) >> emit sd x0 (ROff (0, sp)) else return ())
  >> emit addi sp sp (-(8 * argc))
  >> map_m
       (fun (i, arg) -> a_gen_immexpr t0 arg >> emit sd t0 (ROff (i * 8, sp)))
       (List.mapi args ~f:(fun i a -> i, a))
  >> (match argv with
    | ArgvA1 -> emit addi a1 sp 0
    | ArgvA2 -> emit addi a2 sp 0)
  >> k
  >> emit addi sp sp (8 * argc)
  >> (if need_pad then emit addi sp sp 8 else return ())
  >> restore_regs lives

and with_aligned_call_noargs (k : unit Codegen.t) : unit Codegen.t =
  let* lives = live_caller_regs_excluding_abi in
  let saved_cnt = List.length lives in
  let need_pad = saved_cnt land 1 = 1 in
  let* _ = save_regs lives in
  (if need_pad then emit addi sp sp (-8) >> emit sd x0 (ROff (0, sp)) else return ())
  >> k
  >> (if need_pad then emit addi sp sp 8 else return ())
  >> restore_regs lives

and a_gen_immexpr dst = function
  | ImmNum i -> emit li dst i
  | ImmId id ->
    let* st = get_state in
    (match Map.find st.env id with
     | Some (Loc_reg r) -> emit mv dst r
     | Some (Loc_mem m) -> emit ld dst m
     | None ->
       (match Map.find st.arity_map id with
        | Some arity ->
          with_aligned_call_noargs
            (emit la a0 id >> emit li a1 arity >> emit call "closure_alloc")
          >> if not (equal_reg dst a0) then emit mv dst a0 else return ()
        | None -> emit la dst id))

and a_gen_expr (dst : reg) (aexpr : aexpr) : unit Codegen.t =
  match aexpr with
  | ACE cexpr -> a_gen_cexpr dst cexpr
  | ALet (_rec_flag, id, cexpr, body) ->
    a_gen_cexpr t0 cexpr
    >>
    let* loc = allocate_local_var id in
    emit sd t0 loc >> a_gen_expr dst body

and a_gen_cexpr (dst : reg) (cexpr : cexpr) : unit Codegen.t =
  match cexpr with
  | CImm imm -> a_gen_immexpr dst imm
  | CBinop (bop, imm1, imm2) ->
    a_gen_immexpr t0 imm1 >> a_gen_immexpr t1 imm2 >> a_gen_bin_op bop dst t0 t1
  | CApp (ImmId fname, args) ->
    let argc = List.length args in
    let* st = get_state in
    (match Map.find st.env fname with
     | Some _loc ->
       with_call_frame
         ArgvA2
         args
         (a_gen_immexpr a0 (ImmId fname) >> emit li a1 argc >> emit call "closure_apply")
       >> if not (equal_reg dst a0) then emit mv dst a0 else return ()
     | None ->
       (match Map.find st.arity_map fname with
        | None ->
          error (Printf.sprintf "Codegen: function %s not found in arity_map" fname)
        | Some total_arity ->
          if argc = total_arity
          then
            with_call_frame ArgvA1 args (emit li a0 argc >> emit call fname)
            >> if not (equal_reg dst a0) then emit mv dst a0 else return ()
          else if argc < total_arity
          then
            with_call_frame
              ArgvA2
              args
              (emit la a0 fname
               >> emit li a1 total_arity
               >> emit call "closure_alloc"
               >> emit li a1 argc
               >> emit call "closure_apply")
            >> if not (equal_reg dst a0) then emit mv dst a0 else return ()
          else (
            let prefix, rest = List.split_n args total_arity in
            let restc = List.length rest in
            with_call_frame ArgvA1 prefix (emit li a0 total_arity >> emit call fname)
            >> (if restc = 0
                then return ()
                else
                  emit mv t3 a0
                  >> with_call_frame
                       ArgvA2
                       rest
                       (emit mv a0 t3 >> emit li a1 restc >> emit call "closure_apply"))
            >> if not (equal_reg dst a0) then emit mv dst a0 else return ())))
  | CApp (ImmNum _, _) -> error "unreachable: numeric callee"
  | CIte (cond_imm, then_aexpr, else_aexpr) ->
    let* l_else = fresh_label "else" in
    let* l_end = fresh_label "endif" in
    a_gen_immexpr t0 cond_imm
    >> emit beq t0 x0 l_else
    >> a_gen_expr dst then_aexpr
    >> emit j l_end
    >> emit label l_else
    >> a_gen_expr dst else_aexpr
    >> emit label l_end
  | CFun (param, body) ->
    let rec collect params = function
      | ACE (CFun (p, b)) -> collect (Pat_var p :: params) b
      | a -> List.rev (Pat_var param :: params), a
    in
    let params, fun_body = collect [] body in
    let* lam_name = fresh_fun_symbol () in
    a_gen_func lam_name params fun_body
    >>
    let* st = get_state in
    let arity_map' = Map.set st.arity_map ~key:lam_name ~data:(List.length params) in
    set_state { st with arity_map = arity_map' }
    >> with_aligned_call_noargs
         (emit la a0 lam_name
          >> emit li a1 (List.length params)
          >> emit call "closure_alloc")
    >> if not (equal_reg dst a0) then emit mv dst a0 else return ()

and a_count_local_vars = function
  | ALet (_, _, _, body) -> 1 + a_count_local_vars body
  | ACE cexpr ->
    (match cexpr with
     | CIte (_, then_expr, else_expr) ->
       Int.max (a_count_local_vars then_expr) (a_count_local_vars else_expr)
     | _ -> 0)

and a_bind_params_from_argv (params : Ast.Pattern.t list) : unit Codegen.t =
  map_m
    (fun (i, pat) ->
       match pat with
       | Pat_var id ->
         let* slot = allocate_local_var id in
         let* st = get_state in
         let env' = Map.set st.env ~key:id ~data:(Loc_mem slot) in
         let* () = set_state { st with env = env' } in
         emit ld t0 (ROff (i * 8, a1)) >> emit sd t0 slot
       | _ -> error "only simple variables are supported in parameters")
    (List.mapi params ~f:(fun i p -> i, p))

and a_gen_func name args body =
  let is_main = String.equal name "main" in
  let func_label = name in
  let locals_count = a_count_local_vars body + List.length args in
  let stack_size = align16 (16 + (locals_count * 8)) in
  let* st0 = get_state in
  let arity_map' = Map.set st0.arity_map ~key:name ~data:(List.length args) in
  set_state { st0 with arity_map = arity_map' }
  >> emit directive (Printf.sprintf ".globl %s" func_label)
  >> emit directive (Printf.sprintf ".type %s, @function" func_label)
  >> emit label func_label
  >> emit addi sp sp (-stack_size)
  >> emit sd ra (ROff (stack_size - 8, sp))
  >> emit sd fp (ROff (stack_size - 16, sp))
  >> emit addi fp sp stack_size
  >>
  let* global_state = get_state in
  let initial_cg_state =
    { global_state with env = Map.empty (module String); frame_offset = 16 }
  in
  set_state initial_cg_state
  >> a_bind_params_from_argv args
  >> a_gen_expr a0 body
  >>
  let* final_state = get_state in
  set_state
    { global_state with
      label_id = final_state.label_id
    ; instructions = final_state.instructions
    ; arity_map = final_state.arity_map
    }
  >> emit label (name ^ "_end")
  >> emit ld ra (ROff (stack_size - 8, sp))
  >> emit ld fp (ROff (stack_size - 16, sp))
  >> emit addi sp sp stack_size
  >> if is_main then emit li a0 0 >> emit li (A 7) 93 >> emit ecall else emit ret
;;

let rec extract_fun_params_body (aexp : aexpr) =
  match aexp with
  | ACE (CFun (param, body)) ->
    let params, final_body = extract_fun_params_body body in
    Ast.Pattern.Pat_var param :: params, final_body
  | _ -> [], aexp
;;

let codegen ppf (s : aprogram) =
  let initial_arity_map =
    List.fold
      s
      ~init:(Map.empty (module String))
      ~f:(fun acc -> function
        | AStr_value (_, name, expr) ->
          let params, _ = extract_fun_params_body expr in
          Map.set acc ~key:name ~data:(List.length params)
        | _ -> acc)
  in
  let initial_arity_map = Map.set initial_arity_map ~key:"print_int" ~data:1 in
  let initial_state =
    { env = Map.empty (module String)
    ; frame_offset = 0
    ; label_id = 0
    ; instructions = []
    ; arity_map = initial_arity_map
    }
  in
  let program_gen =
    emit directive ".text"
    >> map_m
         (function
           | AStr_value (_rec_flag, name, expr) ->
             let params, body = extract_fun_params_body expr in
             a_gen_func name params body
           | AStr_eval expr -> a_gen_func "main" [] expr)
         s
  in
  let result, final_state = Codegen.run initial_state program_gen in
  match result with
  | Ok () -> pp_instrs ppf final_state.instructions
  | Error msg -> Stdlib.Format.fprintf ppf ";; Codegen error: %s\n" msg
;;
