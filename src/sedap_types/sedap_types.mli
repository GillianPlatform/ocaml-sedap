(** An extension of the Debug Adapter Protocol for debugging symbolic execution. *)
(* Auto-generated from json schema. Do not edit manually. *)

include module type of Debug_protocol

include module type of Sedap_types_static

module Map_node_next : sig
  module Value : sig
    type t = {
      label : string option; [@default None]
      step_id : string; [@key "stepId"]
    }
    [@@deriving make, yojson {strict = false}]
  end

  type t = Value.t list [@@deriving yojson]
end

module Map_node_extra : sig
  (** Additional, optional details to attach to a node *)
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
  module Controls : sig
    type t =
      | Jump [@name "jump"]
      | Step_in [@name "stepIn"]
      | Step_over [@name "stepOver"]

    include JSONABLE with type t := t
  end

  module Highlight : sig
    type t =
      | Error [@name "error"]
      | Warning [@name "warning"]
      | Info [@name "info"]
      | Success [@name "success"]

    include JSONABLE with type t := t
  end

  (** The kind of map node, with appropriate options *)
  type t =
    | Basic of {
        display : string;
        controls : Controls.t list option;
        highlight : Highlight.t option;
        extras : Map_node_extra.t list option;
      } [@name "basic"]
    | Root of {
        title : string;
        subtitle : string option;
        zoomable : bool option;
        extras : Map_node_extra.t list option;
      } [@name "root"]
    | Pending [@name "pending"]
    | Custom of {
        custom_kind : string; [@key "customKind"]
        custom_options : Yojson.Safe.t; [@key "customOptions"]
      } [@name "custom"]
  [@@deriving yojson]

end

module Map_node : sig
  type t = {
    step_id : string; [@key "stepId"]
    aliases : string list; [@default []]
    submaps : string list; [@default []]
    next : Map_node_next.t;
    options : Map_node_options.t;
  }
  [@@deriving make, yojson {strict = false}]
end

module Map_root : sig
  type t = {
    map_id : string; [@key "mapId"]
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

(** The request causes the exeuction state to step-over from a specific point in execution. *)
module Step_over_at_command : sig
  val type_ : string

  module Arguments : sig
    (** Arguments for 'stepOverAt' request. *)
    type t = {
      step_id : string; [@key "stepId"] (** The id of the execution node to step-over from. *)
    }
    [@@deriving make, yojson {strict = false}]
  end

  module Result : sig
    type t = Empty_dict.t
    [@@deriving yojson]
  end
end

(** The request causes the exeuction state to step-in from a specific point in execution. *)
module Step_in_at_command : sig
  val type_ : string

  module Arguments : sig
    (** Arguments for 'stepInAt' request. *)
    type t = {
      step_id : string; [@key "stepId"] (** The id of the execution node to step-in from. *)
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
    (** Arguments for 'jump' request. *)
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

