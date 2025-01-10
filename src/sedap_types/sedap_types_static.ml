open Utils

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
