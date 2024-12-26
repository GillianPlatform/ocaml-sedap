let ( let+ ) f o = Result.map o f
let ( let* ) o f = Result.bind o f

let obj_of_yojson = function
  | `Assoc obj -> Ok obj
  | _ -> Error "expected object"
  

let key_of_yojson key f obj =
  match List.assoc_opt key obj with
  | Some x -> f x
  | None -> f `Null

module String_map = struct
  include Map.Make(String)
  let to_yojson f t =
    let elems = to_list t |> List.map (fun (k, v) -> (k, f v)) in
    `Assoc elems

  let of_yojson f (j : Yojson.Safe.t) =
    let rec aux acc = function
    | (k, v) :: rest ->
      let* v' = f v in
      aux ((k, v') :: acc) rest
    | [] -> Ok (List.rev acc)
    in
    let* o = obj_of_yojson j in
    let* elems = aux [] o in
    Ok (of_list elems)
end
