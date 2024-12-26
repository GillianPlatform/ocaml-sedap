(** An extension of the Debug Adapter Protocol for debugging symbolic execution. *)
(* Auto-generated from json schema. Do not edit manually. *)

include Debug_protocol
open Utils

module Branch_case = struct
  (** The type of a branch case is arbitrary and implementation-dependent.
  The UI should essentially treat this as a black box to pass back to the debugger when calling "stepSpecific". *)
  type t = Yojson.Safe.t [@@deriving yojson]

end

module Map_node_next = struct
  module Cases = struct
    type t = {
      branch_label : string [@key "branchLabel"];
      branch_case : Branch_case.t [@key "branchCase"];
      id : string;
    }
    [@@deriving make, yojson {strict = false}]
  end

  type t =
    | Single of {
        id : string option
      } [@name "single"]
    | Branch of {
        cases : Cases.t list
      } [@name "branch"]
    | Final [@name "final"]

    let to_yojson = function
      | Single { id } -> `Assoc [
          ("kind", `String "single");
          ("id", [%to_yojson: string option] id);
        ]
      | Branch { cases } -> `Assoc [
          ("kind", `String "branch");
          ("cases", [%to_yojson: Cases.t list] cases);
        ]
      | Final  -> `Assoc [
          ("kind", `String "final");
        ]

    let of_yojson json =
      let* obj = obj_of_yojson json in
      match List.assoc_opt "type" obj with
      | Some (`String "single") ->
          let* _id = key_of_yojson "id" [%of_yojson: string option] obj in
        Ok (Single {
            id = _id;
        })
      | Some (`String "branch") ->
          let* _cases = key_of_yojson "cases" [%of_yojson: Cases.t list] obj in
        Ok (Branch {
            cases = _cases;
        })
      | Some (`String "final") ->
        Ok (Final)
      | _ -> Error "invalid variant kind"
end

module Map_node = struct
  type t = {
    id : string;
    display : string;
    submaps : string list option [@default None];
    next : Map_node_next.t option [@default None];
    ext : Yojson.Safe.t option [@default None]; (** Optional, implementation-specific data of arbitrary type. *)
  }
  [@@deriving make, yojson {strict = false}]
end

module Map_update_event = struct
  let type_ = "mapUpdate"

  module Payload = struct
    module Nodes = struct
      (** An object of map nodes to update, where a key is the node's ID, or null to specify node deleting the node at that ID. *)
      type t = Map_node.t option String_map.t
      [@@deriving yojson]
    end

    module Roots = struct
      type t = String_dict.t
      [@@deriving yojson]
    end

    type t = {
      nodes : Nodes.t option [@default None]; (** An object of map nodes to update, where a key is the node's ID, or null to specify node deleting the node at that ID. *)
      roots : Roots.t option [@default None];
      current_step : string option [@key "currentStep"] [@default None];
      ext : Yojson.Safe.t option [@default None];
    }
    [@@deriving make, yojson {strict = false}]
  end
end

(** The request starts the debugger to step from a specific point in execution, in a specific direction in the case of branching.
When there is no branch, this is equivalent to "jump" followed by "stepIn".
Errors if a branch is present and no branch case is supplied, or a branch case is supplied where ther is no branch. *)
module Step_specific_command = struct
  let type_ = "stepSpecific"

  module Arguments = struct
    (** Arguments for 'stepSpecific' request. *)
    type t = {
      step_id : string [@key "stepId"]; (** The id of the execution node to step from. *)
      branch_case : Branch_case.t option [@key "branchCase"] [@default None]; (** The branch case to step in. *)
    }
    [@@deriving make, yojson {strict = false}]
  end

  module Result = struct
    type t = Empty_dict.t
    [@@deriving yojson]
  end
end

(** The request causes the exeuction state to jump to another (existing) point in execution. *)
module Jump_command = struct
  let type_ = "jump"

  module Arguments = struct
    (** Arguments for 'jump'' request. *)
    type t = {
      step_id : string option [@key "stepId"] [@default None]; (** The id of the execution node to jump to. *)
    }
    [@@deriving make, yojson {strict = false}]
  end

  module Result = struct
    type t = Empty_dict.t
    [@@deriving yojson]
  end
end

module Jmp_command = struct
  let type_ = "jmp"

  module Arguments = struct
    type t = Empty_dict.t
    [@@deriving yojson]
  end

  module Result = struct
    type t = Empty_dict.t
    [@@deriving yojson]
  end
end

