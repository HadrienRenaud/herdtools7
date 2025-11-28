(* Auto-generated file - do not edit. *)

module type I = sig
  type ii
  type v
  type 'a m

  (* Utils *)
  val return : 'a -> 'a m
  val bind : 'a m -> ('a -> 'b m) -> 'b m
  val arity_error : string -> expected:int -> actual:int -> 'a

  (* Primitives *)
  val u_int : ii -> n:v m -> x:v m -> v m
  val s_int : ii -> n:v m -> x:v m -> v m
  val dec_str : ii -> x:v m -> v m
  val hex_str : ii -> x:v m -> v m
  val ascii_str : ii -> x:v m -> v m
  val floor_log2 : ii -> x:v m -> v m
  val round_down : ii -> x:v m -> v m
  val round_up : ii -> x:v m -> v m
  val round_towards_zero : ii -> x:v m -> v m
end

module Make(I: I) = struct
  open I

  let wrap_return x = return [ x ]
  let no_return m = bind m (fun () -> return [])

  let u_int ii (params : v m list) (args : v m list) : v m list m =
    match (params, args) with
    | [ p0 ], [ a0 ] ->
        u_int ii ~n:p0 ~x:a0 |> wrap_return
    | _, [ _0 ] ->
        arity_error "UInt" ~expected:1 ~actual:(List.length params)
    | _ ->
        arity_error "UInt" ~expected:1 ~actual:(List.length args)

  let s_int ii (params : v m list) (args : v m list) : v m list m =
    match (params, args) with
    | [ p0 ], [ a0 ] ->
        s_int ii ~n:p0 ~x:a0 |> wrap_return
    | _, [ _0 ] ->
        arity_error "SInt" ~expected:1 ~actual:(List.length params)
    | _ ->
        arity_error "SInt" ~expected:1 ~actual:(List.length args)

  let dec_str ii (params : v m list) (args : v m list) : v m list m =
    match (params, args) with
    | [], [ a0 ] ->
        dec_str ii ~x:a0 |> wrap_return
    | _, [ _0 ] ->
        arity_error "DecStr" ~expected:0 ~actual:(List.length params)
    | _ ->
        arity_error "DecStr" ~expected:1 ~actual:(List.length args)

  let hex_str ii (params : v m list) (args : v m list) : v m list m =
    match (params, args) with
    | [], [ a0 ] ->
        hex_str ii ~x:a0 |> wrap_return
    | _, [ _0 ] ->
        arity_error "HexStr" ~expected:0 ~actual:(List.length params)
    | _ ->
        arity_error "HexStr" ~expected:1 ~actual:(List.length args)

  let ascii_str ii (params : v m list) (args : v m list) : v m list m =
    match (params, args) with
    | [], [ a0 ] ->
        ascii_str ii ~x:a0 |> wrap_return
    | _, [ _0 ] ->
        arity_error "AsciiStr" ~expected:0 ~actual:(List.length params)
    | _ ->
        arity_error "AsciiStr" ~expected:1 ~actual:(List.length args)

  let floor_log2 ii (params : v m list) (args : v m list) : v m list m =
    match (params, args) with
    | [], [ a0 ] ->
        floor_log2 ii ~x:a0 |> wrap_return
    | _, [ _0 ] ->
        arity_error "FloorLog2" ~expected:0 ~actual:(List.length params)
    | _ ->
        arity_error "FloorLog2" ~expected:1 ~actual:(List.length args)

  let round_down ii (params : v m list) (args : v m list) : v m list m =
    match (params, args) with
    | [], [ a0 ] ->
        round_down ii ~x:a0 |> wrap_return
    | _, [ _0 ] ->
        arity_error "RoundDown" ~expected:0 ~actual:(List.length params)
    | _ ->
        arity_error "RoundDown" ~expected:1 ~actual:(List.length args)

  let round_up ii (params : v m list) (args : v m list) : v m list m =
    match (params, args) with
    | [], [ a0 ] ->
        round_up ii ~x:a0 |> wrap_return
    | _, [ _0 ] ->
        arity_error "RoundUp" ~expected:0 ~actual:(List.length params)
    | _ ->
        arity_error "RoundUp" ~expected:1 ~actual:(List.length args)

  let round_towards_zero ii (params : v m list) (args : v m list) : v m list m =
    match (params, args) with
    | [], [ a0 ] ->
        round_towards_zero ii ~x:a0 |> wrap_return
    | _, [ _0 ] ->
        arity_error "RoundTowardsZero" ~expected:0 ~actual:(List.length params)
    | _ ->
        arity_error "RoundTowardsZero" ~expected:1 ~actual:(List.length args)

  let primitives =
    [
      (u_int, "UInt");
      (s_int, "SInt");
      (dec_str, "DecStr");
      (hex_str, "HexStr");
      (ascii_str, "AsciiStr");
      (floor_log2, "FloorLog2");
      (round_down, "RoundDown");
      (round_up, "RoundUp");
      (round_towards_zero, "RoundTowardsZero");
    ]
end
