let ( let+ ) f o = Result.map o f
let ( let* ) o f = Result.bind o f

let obj_of_yojson = function
  | `Assoc obj -> Ok obj
  | _ -> Error "expected object"
  

let key_of_yojson key f obj =
  match List.assoc_opt key obj with
  | Some x -> f x
  | None -> f `Null

let print_exn_at_loc loc =
  Printf.sprintf "Exception raised at %s:%d" loc.Lexing.pos_fname loc.Lexing.pos_lnum