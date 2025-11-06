(** Copyright 2025-2026, Rodion Suvorov, Dmitriy Chirkov*)

(** SPDX-License-Identifier: LGPL-3.0-or-later *)

open Codegen
open Format
open Inferencer.Infer
open Inferencer.InferTypes
open Middle.Anf
open Middle.Anf_pp
open Middle.CC
open Middle.LL

let usage_msg = "Usage: AML.exe <input file> <output file>"

let read_file filename =
  let ic = open_in filename in
  let len = in_channel_length ic in
  let s = really_input_string ic len in
  close_in ic;
  s
;;

let write_file filename content =
  let oc = open_out filename in
  output_string oc content;
  close_out oc
;;

let compile input_file output_file =
  let src = read_file input_file in
  let program = Parser.parse_str src in
  match run_infer_program program env_with_things with
  | Ok (_, _) ->
    (match anf_transform program with
     | Ok aprogram ->
       (match cc_transform aprogram with
        | Ok _ccaprogram ->
          (match ll_transform _ccaprogram with
           | Ok _llaprogram ->
             let asm = asprintf "%a" codegen _llaprogram in
             write_file output_file asm;
             printf "Generated: %s\n" output_file
           | Error msg -> Format.eprintf "LL transform error: %s\n" msg)
        | Error msg -> Format.eprintf "CC transform error: %s\n" msg)
     | Error msg -> Format.eprintf "ANF transform error: %s\n" msg)
  | Error err -> Format.printf "%a" pp_inf_err err
;;

let dump_anf input_file =
  let src = read_file input_file in
  let program = Parser.parse_str src in
  match run_infer_program program env_with_things with
  | Ok (_, _) ->
    (match anf_transform program with
     | Ok aprogram ->
       pp_anf std_formatter aprogram;
       pp_print_flush std_formatter ()
     | Error msg -> Format.eprintf "ANF transform error: %s\n" msg)
  | Error err -> Format.printf "%a" pp_inf_err err
;;

let dump_cc_anf input_file =
  let src = read_file input_file in
  let program = Parser.parse_str src in
  match run_infer_program program env_with_things with
  | Ok (_, _) ->
    let res = anf_transform program in
    (match res with
     | Ok aprogram ->
       (match cc_transform aprogram with
        | Ok aprogram ->
          pp_anf std_formatter aprogram;
          pp_print_flush std_formatter ()
        | Error msg -> Format.eprintf "CC transform error: %s\n" msg)
     | Error msg -> Format.eprintf "ANF transform error: %s\n" msg)
  | Error err -> Format.printf "%a" pp_inf_err err
;;

let dump_cc_ll_anf input_file =
  let src = read_file input_file in
  let program = Parser.parse_str src in
  match run_infer_program program env_with_things with
  | Ok (_, _) ->
    let res = anf_transform program in
    (match res with
     | Ok aprogram ->
       (match cc_transform aprogram with
        | Ok aprogram ->
          (match ll_transform aprogram with
           | Ok aprogram ->
             pp_anf std_formatter aprogram;
             pp_print_flush std_formatter ()
           | Error msg -> Format.eprintf "LL transform error: %s\n" msg)
        | Error msg -> Format.eprintf "CC transform error: %s\n" msg)
     | Error msg -> Format.eprintf "ANF transform error: %s\n" msg)
  | Error err -> Format.printf "%a" pp_inf_err err
;;

let () =
  match Array.to_list Sys.argv with
  | [ _exe; "--dump-anf"; input_file ] -> dump_anf input_file
  | [ _exe; "--dump-cc-anf"; input_file ] -> dump_cc_anf input_file
  | [ _exe; "--dump-cc-ll-anf"; input_file ] -> dump_cc_ll_anf input_file
  | [ _exe; input_file; output_file ] -> compile input_file output_file
  | _ ->
    prerr_endline usage_msg;
    exit 1
;;
