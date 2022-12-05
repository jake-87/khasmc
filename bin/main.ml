
open Lexing
open Ast
open Typecheck
open Typecheck_env
open Uniq_typevars

let print_error_position lexbuf =
  let pos = lexbuf.lex_curr_p in
  Fmt.str "Line: %d, Position: %d" pos.pos_lnum (pos.pos_cnum - pos.pos_bol + 1)



let parseToAst filename =
  let file = open_in filename in
  let lexbuf = Lexing.from_channel file in
  try
    let result = Parser.program Lexer.token lexbuf in
    close_in file;
    result
  with
  | Parser.Error(x) ->
     let error_msg = Fmt.str "%s: syntax error in state %d@." (print_error_position lexbuf) x in
     print_endline ("Parse error: " ^ error_msg);
     exit 1

let rec normalise files =
  match files with
  | [] -> []
  | x :: xs ->
     (
       Filename.basename x
       |> Filename.chop_extension
       |> BatString.capitalize
     )  :: normalise xs

let _ =
  let argc = Array.length Sys.argv in
  if argc < 2 then
    begin
      print_endline "USAGE: ./khasmc <file>";
      exit 1
    end;
  print_endline "";
  let t = Unix.gettimeofday() in
  begin
    let list = Array.to_list Sys.argv in
    let files = List.tl list in (* make this better *)
    let programs = List.map parseToAst files in
    let names = normalise files in 
    let uniq_typevars = List.map make_uniq_typevars programs in
    let end_env = typecheck_program_list uniq_typevars names None in
    print_endline (show_env end_env)
  end;
  Printf.printf "\nkhasmc done in %fs\n"  ((Unix.gettimeofday()) -. t)
