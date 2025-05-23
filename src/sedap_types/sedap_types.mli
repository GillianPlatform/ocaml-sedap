(** An extension of the Debug Adapter Protocol for debugging symbolic execution. *)
(* Auto-generated from json schema. Do not edit manually. *)

include module type of Debug_protocol

include module type of Sedap_types_static

module Branch_case : sig
  (** The type of a branch case is arbitrary and implementation-dependent.
  The UI should essentially treat this as a black box to pass back to the debugger when calling "stepSpecific". *)
  type t = Yojson.Safe.t [@@deriving yojson]

end

module Map_node_next : sig
  module Cases : sig
    type t = {
      branch_label : string; [@key "branchLabel"]
      branch_case : Branch_case.t; [@key "branchCase"]
      id : string option;
    }
    [@@deriving make, yojson {strict = false}]
  end

  type t =
    | Single of {
        id : string option;
      } [@name "single"]
    | Branch of {
        cases : Cases.t list;
      } [@name "branch"]
    | Final [@name "final"]
  [@@deriving yojson]

end

module Map_node_extra : sig
  type t =
    | Badge of {
        text : string;
        tag : string option;
      } [@name "badge"]
    | Tooltip of {
        text : string;
      } [@name "tooltip"]
  [@@deriving yojson]

end

module Map_node_options : sig
  module Highlight : sig
    type t =
      | Error [@name "error"]
      | Warning [@name "warning"]
      | Info [@name "info"]
      | Success [@name "success"]

    include JSONABLE with type t := t
  end

  type t =
    | Basic of {
        display : string;
        selectable : bool option;
        highlight : Highlight.t option;
        extras : Map_node_extra.t list option;
      } [@name "basic"]
    | Root of {
        title : string;
        subtitle : string option;
        zoomable : bool option;
        extras : Map_node_extra.t list option;
      } [@name "root"]
    | Custom of {
        custom_kind : string; [@key "customKind"]
        custom_options : Yojson.Safe.t; [@key "customOptions"]
      } [@name "custom"]
  [@@deriving yojson]

end

module Map_node : sig
  type t = {
    id : string;
    aliases : string list; [@default []]
    submaps : string list; [@default []]
    next : Map_node_next.t;
    options : Map_node_options.t;
  }
  [@@deriving make, yojson {strict = false}]
end

module Map_root : sig
  type t = {
    id : string;
    name : string;
  }
  [@@deriving make, yojson {strict = false}]
end

module Map_update_event_body : sig
  module Nodes : sig
    (** An object of map nodes to update, where a key is the node's ID, or null to specify node deleting the node at that ID. *)
    type t = Map_node.t option String_map.t
    [@@deriving yojson]
  end

  module Current_steps : sig
    type t = {
      primary : string list option; [@default None]
      secondary : string list option; [@default None]
    }
    [@@deriving make, yojson {strict = false}]
  end

  type t = {
    nodes : Nodes.t; [@default String_map.empty] (** An object of map nodes to update, where a key is the node's ID, or null to specify node deleting the node at that ID. *)
    roots : Map_root.t list; [@default []]
    current_steps : Current_steps.t option; [@key "currentSteps"] [@default None]
    reset : bool; [@default false] (** If true, the map should be reset to its initial state; this event contains the full map and previous information can be discarded. *)
    ext : Yojson.Safe.t option; [@default None]
  }
  [@@deriving make, yojson {strict = false}]
end

module Map_update_event : sig
  val type_ : string

  module Payload : sig
    type t = Map_update_event_body.t [@@deriving yojson]
  end
end

(** The request starts the debugger to step from a specific point in execution, in a specific direction in the case of branching.
When there is no branch, this is equivalent to "jump" followed by "stepIn".
Errors if a branch is present and no branch case is supplied, or a branch case is supplied where ther is no branch. *)
module Step_specific_command : sig
  val type_ : string

  module Arguments : sig
    (** Arguments for 'stepSpecific' request. *)
    type t = {
      step_id : string; [@key "stepId"] (** The id of the execution node to step from. *)
      branch_case : Branch_case.t option; [@key "branchCase"] [@default None] (** The branch case to step in. *)
    }
    [@@deriving make, yojson {strict = false}]
  end

  module Result : sig
    type t = Empty_dict.t
    [@@deriving yojson]
  end
end

(** The request causes the exeuction state to jump to another (existing) point in execution. *)
module Jump_command : sig
  val type_ : string

  module Arguments : sig
    (** Arguments for 'jump'' request. *)
    type t = {
      step_id : string; [@key "stepId"] (** The id of the execution node to jump to. *)
    }
    [@@deriving make, yojson {strict = false}]
  end

  module Result : sig
    type t = Empty_dict.t
    [@@deriving yojson]
  end
end

module Get_full_map_command : sig
  val type_ : string

  module Arguments : sig
    (** The 'getFullMap' request takes no arguments. *)
    type t = Empty_dict.t
    [@@deriving yojson]
  end

  module Result : sig
    type t = Map_update_event_body.t [@@deriving yojson]
  end
end

