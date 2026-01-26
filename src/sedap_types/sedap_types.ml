(** An extension of the Debug Adapter Protocol for debugging symbolic execution. *)
(* Auto-generated from json schema. Do not edit manually. *)

include Debug_protocol
include Sedap_types_static

open Utils

module Map_node_next = struct
  module Value = struct
    type t = {
      label : string option; [@default None]
      step_id : string; [@key "stepId"]
    }
    [@@deriving make, yojson {strict = false}]
  end

  type t = Value.t list [@@deriving yojson]
end

module Map_node_extra = struct
  (** Additional, optional details to attach to a node *)
  type t =
    | Badge of {
        text : string;
        tag : string option;
      } [@name "badge"]
    | Tooltip of {
        text : string;
      } [@name "tooltip"]

    let to_yojson = function
      | Badge { text; tag } -> `Assoc [
          ("kind", `String "badge");
          ("text", [%to_yojson: string] text);
          ("tag", [%to_yojson: string option] tag);
        ]
      | Tooltip { text } -> `Assoc [
          ("kind", `String "tooltip");
          ("text", [%to_yojson: string] text);
        ]

    let of_yojson json =
      let* obj = obj_of_yojson json in
      match List.assoc_opt "type" obj with
      | Some (`String "badge") ->
          let* _text = key_of_yojson "text" [%of_yojson: string] obj in
          let* _tag = key_of_yojson "tag" [%of_yojson: string option] obj in
        Ok (Badge {
            text = _text;
            tag = _tag;
        })
      | Some (`String "tooltip") ->
          let* _text = key_of_yojson "text" [%of_yojson: string] obj in
        Ok (Tooltip {
            text = _text;
        })
      | _ -> Error "invalid variant kind"
end

module Map_node_options = struct
  module Controls = struct
    type t =
      | Jump [@name "jump"]
      | Step_in [@name "stepIn"]
      | Step_over [@name "stepOver"]

    let of_yojson = function
      | `String "jump" -> Ok Jump
      | `String "stepIn" -> Ok Step_in
      | `String "stepOver" -> Ok Step_over
      | _ -> Error (print_exn_at_loc [%here])

    let to_yojson = function
      | Jump -> `String "jump"
      | Step_in -> `String "stepIn"
      | Step_over -> `String "stepOver"

  end

  module Highlight = struct
    type t =
      | Error [@name "error"]
      | Warning [@name "warning"]
      | Info [@name "info"]
      | Success [@name "success"]

    let of_yojson = function
      | `String "error" -> Ok Error
      | `String "warning" -> Ok Warning
      | `String "info" -> Ok Info
      | `String "success" -> Ok Success
      | _ -> Error (print_exn_at_loc [%here])

    let to_yojson = function
      | Error -> `String "error"
      | Warning -> `String "warning"
      | Info -> `String "info"
      | Success -> `String "success"

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

    let to_yojson = function
      | Basic { display; controls; highlight; extras } -> `Assoc [
          ("kind", `String "basic");
          ("display", [%to_yojson: string] display);
          ("controls", [%to_yojson: Controls.t list option] controls);
          ("highlight", [%to_yojson: Highlight.t option] highlight);
          ("extras", [%to_yojson: Map_node_extra.t list option] extras);
        ]
      | Root { title; subtitle; zoomable; extras } -> `Assoc [
          ("kind", `String "root");
          ("title", [%to_yojson: string] title);
          ("subtitle", [%to_yojson: string option] subtitle);
          ("zoomable", [%to_yojson: bool option] zoomable);
          ("extras", [%to_yojson: Map_node_extra.t list option] extras);
        ]
      | Pending  -> `Assoc [
          ("kind", `String "pending");
        ]
      | Custom { custom_kind; custom_options } -> `Assoc [
          ("kind", `String "custom");
          ("customKind", [%to_yojson: string] custom_kind);
          ("customOptions", [%to_yojson: Yojson.Safe.t] custom_options);
        ]

    let of_yojson json =
      let* obj = obj_of_yojson json in
      match List.assoc_opt "type" obj with
      | Some (`String "basic") ->
          let* _display = key_of_yojson "display" [%of_yojson: string] obj in
          let* _controls = key_of_yojson "controls" [%of_yojson: Controls.t list option] obj in
          let* _highlight = key_of_yojson "highlight" [%of_yojson: Highlight.t option] obj in
          let* _extras = key_of_yojson "extras" [%of_yojson: Map_node_extra.t list option] obj in
        Ok (Basic {
            display = _display;
            controls = _controls;
            highlight = _highlight;
            extras = _extras;
        })
      | Some (`String "root") ->
          let* _title = key_of_yojson "title" [%of_yojson: string] obj in
          let* _subtitle = key_of_yojson "subtitle" [%of_yojson: string option] obj in
          let* _zoomable = key_of_yojson "zoomable" [%of_yojson: bool option] obj in
          let* _extras = key_of_yojson "extras" [%of_yojson: Map_node_extra.t list option] obj in
        Ok (Root {
            title = _title;
            subtitle = _subtitle;
            zoomable = _zoomable;
            extras = _extras;
        })
      | Some (`String "pending") ->
        Ok (Pending)
      | Some (`String "custom") ->
          let* _custom_kind = key_of_yojson "customKind" [%of_yojson: string] obj in
          let* _custom_options = key_of_yojson "customOptions" [%of_yojson: Yojson.Safe.t] obj in
        Ok (Custom {
            custom_kind = _custom_kind;
            custom_options = _custom_options;
        })
      | _ -> Error "invalid variant kind"
end

module Map_node = struct
  type t = {
    step_id : string; [@key "stepId"]
    aliases : string list; [@default []]
    submaps : string list; [@default []]
    next : Map_node_next.t;
    options : Map_node_options.t;
  }
  [@@deriving make, yojson {strict = false}]
end

module Map_root = struct
  type t = {
    map_id : string; [@key "mapId"]
    name : string;
  }
  [@@deriving make, yojson {strict = false}]
end

module Map_update_event_body = struct
  module Nodes = struct
    (** An object of map nodes to update, where a key is the node's ID, or null to specify node deleting the node at that ID. *)
    type t = Map_node.t option String_map.t
    [@@deriving yojson]
  end

  module Current_steps = struct
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

module Map_update_event = struct
  let type_ = "mapUpdate"

  module Payload = struct
    type t = Map_update_event_body.t [@@deriving yojson]
  end
end

(** The request causes the exeuction state to jump to another (existing) point in execution. *)
module Jump_command = struct
  let type_ = "jump"

  module Arguments = struct
    (** Arguments for 'jump'' request. *)
    type t = {
      step_id : string; [@key "stepId"] (** The id of the execution node to jump to. *)
    }
    [@@deriving make, yojson {strict = false}]
  end

  module Result = struct
    type t = Empty_dict.t
    [@@deriving yojson]
  end
end

module Get_full_map_command = struct
  let type_ = "getFullMap"

  module Arguments = struct
    (** The 'getFullMap' request takes no arguments. *)
    type t = Empty_dict.t
    [@@deriving yojson]
  end

  module Result = struct
    type t = Map_update_event_body.t [@@deriving yojson]
  end
end

