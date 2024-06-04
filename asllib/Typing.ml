(******************************************************************************)
(*                                ASLRef                                      *)
(******************************************************************************)
(*
 * SPDX-FileCopyrightText: Copyright 2022-2023 Arm Limited and/or its affiliates <open-source-office@arm.com>
 * SPDX-License-Identifier: BSD-3-Clause
 *)
(******************************************************************************)
(* Disclaimer:                                                                *)
(* This material covers both ASLv0 (viz, the existing ASL pseudocode language *)
(* which appears in the Arm Architecture Reference Manual) and ASLv1, a new,  *)
(* experimental, and as yet unreleased version of ASL.                        *)
(* This material is work in progress, more precisely at pre-Alpha quality as  *)
(* per Arm’s quality standards.                                               *)
(* In particular, this means that it would be premature to base any           *)
(* production tool development on this material.                              *)
(* However, any feedback, question, query and feature request would be most   *)
(* welcome; those can be sent to Arm’s Architecture Formal Team Lead          *)
(* Jade Alglave <jade.alglave@arm.com>, or by raising issues or PRs to the    *)
(* herdtools7 github repository.                                              *)
(******************************************************************************)

open AST
open ASTUtils
open Infix
open StaticEnv
module TypingRule = Instrumentation.TypingRule
module SE = SideEffectSet

type side_effects = SE.t

let ( |: ) = Instrumentation.TypingNoInstr.use_with
let fatal_from = Error.fatal_from
let undefined_identifier pos x = fatal_from pos (Error.UndefinedIdentifier x)
let invalid_expr e = fatal_from e (Error.InvalidExpr e)

let conflict pos expected provided =
  fatal_from pos (Error.ConflictingTypes (expected, provided))

let expr_of_z z = literal (L_Int z)
let plus = binop PLUS
let t_bits_bitwidth e = T_Bits (e, [])

let reduce_expr env e =
  let open StaticModel in
  try normalize env e with NotYetImplemented -> e

let reduce_constants env e =
  let open StaticInterpreter in
  let open StaticModel in
  let eval_expr env e =
    try static_eval env e with NotYetImplemented -> unsupported_expr e
  in
  try eval_expr env e
  with StaticEvaluationUnknown -> (
    let () =
      if false then
        Format.eprintf
          "@[<hov>Static evaluation failed. Trying to reduce.@ For %a@ at \
           %a@]@."
          PP.pp_expr e PP.pp_pos e
    in
    try reduce_expr env e |> eval_expr env
    with StaticEvaluationUnknown -> unsupported_expr e)

let reduce_constraint env = function
  | Constraint_Exact e -> Constraint_Exact (reduce_expr env e)
  | Constraint_Range (e1, e2) ->
      Constraint_Range (reduce_expr env e1, reduce_expr env e2)

let reduce_constraints env = function
  | (UnConstrained | UnderConstrained _) as c -> c
  | WellConstrained constraints ->
      WellConstrained (List.map (reduce_constraint env) constraints)

let sum = function [] -> !$0 | [ x ] -> x | h :: t -> List.fold_left plus h t

let slices_width env =
  let minus = binop MINUS in
  let one = !$1 in
  let slice_length = function
    | Slice_Single _ -> one
    | Slice_Star (_, e) | Slice_Length (_, e) -> e
    | Slice_Range (e1, e2) -> plus one (minus e1 e2)
  in
  fun li -> List.map slice_length li |> sum |> reduce_expr env

let width_plus env acc w = plus acc w |> reduce_expr env

let rename_ty_eqs : env -> (AST.identifier * AST.expr) list -> AST.ty -> AST.ty
    =
  let subst_expr env eqs e = subst_expr eqs e |> reduce_expr env in
  let subst_constraint env eqs = function
    | Constraint_Exact e -> Constraint_Exact (subst_expr env eqs e)
    | Constraint_Range (e1, e2) ->
        Constraint_Range (subst_expr env eqs e1, subst_expr env eqs e2)
  in
  let subst_constraints env eqs = List.map (subst_constraint env eqs) in
  let rec rename env eqs ty =
    match ty.desc with
    | T_Bits (e, fields) ->
        T_Bits (subst_expr env eqs e, fields) |> add_pos_from_st ty
    | T_Int (WellConstrained constraints) ->
        let constraints = subst_constraints env eqs constraints in
        T_Int (WellConstrained constraints) |> add_pos_from_st ty
    | T_Int (UnderConstrained (_uid, name)) ->
        let e = E_Var name |> add_pos_from ty |> subst_expr env eqs in
        T_Int (WellConstrained [ Constraint_Exact e ]) |> add_pos_from ty
    | T_Tuple tys -> T_Tuple (List.map (rename env eqs) tys) |> add_pos_from ty
    | _ -> ty
  in
  rename

(* Begin Lit *)
let annotate_literal = function
  | L_Int _ as v -> integer_exact' (literal v)
  | L_Bool _ -> T_Bool
  | L_Real _ -> T_Real
  | L_String _ -> T_String
  | L_BitVector bv -> Bitvector.length bv |> expr_of_int |> t_bits_bitwidth
(* End *)

exception ConstraintMinMaxTop

let min_constraint env = function
  | Constraint_Exact e | Constraint_Range (e, _) -> (
      let e = reduce_expr env e in
      match e.desc with
      | E_Literal (L_Int i) -> i
      | _ ->
          let () =
            if false then
              Format.eprintf "Min constraint found strange value %a@."
                PP.pp_expr e
          in
          raise ConstraintMinMaxTop)

let max_constraint env = function
  | Constraint_Exact e | Constraint_Range (_, e) -> (
      let e = reduce_expr env e in
      match e.desc with
      | E_Literal (L_Int i) -> i
      | _ ->
          let () =
            if false then
              Format.eprintf "Max constraint found strange value %a@."
                PP.pp_expr e
          in
          raise ConstraintMinMaxTop)

let min_max_constraints m_constraint m =
  let rec do_rec env = function
    | [] ->
        failwith
          "A well-constrained integer cannot have an empty list of constraints."
    | [ c ] -> m_constraint env c
    | c :: cs ->
        let i = m_constraint env c and j = do_rec env cs in
        m i j
  in
  do_rec

(* NB: functions raise [ConstraintMinMaxTop] if no approximation can be found *)
let min_constraints = min_max_constraints min_constraint min
and max_constraints = min_max_constraints max_constraint max

let get_first_duplicate extractor li =
  let exception Duplicate of identifier in
  let folder acc elt =
    let x = extractor elt in
    let acc' = ISet.add x acc in
    if acc' == acc then raise (Duplicate x) else acc'
  in
  try
    let _ = List.fold_left folder ISet.empty li in
    None
  with Duplicate x -> Some x

(** [set_filter_map f set] is the list of [y] such that [f x = Some y] for all
    elements [x] of [set]. *)
let set_filter_map f set =
  let folder e acc = match f e with None -> acc | Some x -> x :: acc in
  ISet.fold folder set []

let name_of_type ty = match ty.desc with T_Named s -> s | _ -> assert false

(* ---------------------------------------------------------------------------

                              Properties handling

   ---------------------------------------------------------------------------*)

type strictness = [ `Silence | `Warn | `TypeCheck ]

module type ANNOTATE_CONFIG = sig
  val check : strictness
end

module Property (C : ANNOTATE_CONFIG) = struct
  exception TypingAssumptionFailed

  type ('a, 'b) property = 'a -> 'b
  type prop = (unit, unit) property

  let strictness_string =
    match C.check with
    | `TypeCheck -> "type-checking-strict"
    | `Warn -> "type-checking-warn"
    | `Silence -> "type-inference"

  let check : prop -> prop =
    match C.check with
    | `TypeCheck -> fun f () -> f ()
    | `Warn -> (
        fun f () -> try f () with Error.ASLException e -> Error.eprintln e)
    | `Silence -> fun _f () -> ()

  let best_effort' : ('a, 'a) property -> ('a, 'a) property =
    match C.check with
    | `TypeCheck -> fun f x -> f x
    | `Warn -> (
        fun f x ->
          try f x
          with Error.ASLException e ->
            Error.eprintln e;
            x)
    | `Silence -> ( fun f x -> try f x with Error.ASLException _ -> x)

  let best_effort : 'a -> ('a, 'a) property -> 'a = fun x f -> best_effort' f x
  let[@inline] ( let+ ) m f = check m () |> f

  let[@inline] both (p1 : prop) (p2 : prop) () =
    let () = p1 () in
    let () = p2 () in
    ()

  let either (p1 : ('a, 'b) property) (p2 : ('a, 'b) property) x =
    try p1 x with TypingAssumptionFailed | Error.ASLException _ -> p2 x

  let rec any (li : prop list) : prop =
    match li with
    | [] -> raise (Invalid_argument "any")
    | [ f ] -> f
    | p :: li -> either p (any li)

  let assumption_failed () = raise_notrace TypingAssumptionFailed [@@inline]
  let ok () = () [@@inline]
  let check_true b fail () = if b then () else fail () [@@inline]
  let check_true' b = check_true b assumption_failed [@@inline]
end

(* -------------------------------------------------------------------------

                        Functional polymorphism

   ------------------------------------------------------------------------- *)

module FunctionRenaming (C : ANNOTATE_CONFIG) = struct
  open Property (C)

  (* Returns true iff type lists type-clash element-wise. *)
  let has_arg_clash env caller callee =
    List.compare_lengths caller callee == 0
    && List.for_all2
         (fun t_caller (_, t_callee) ->
           Types.type_clashes env t_caller t_callee)
         caller callee

  (* Return true if two subprogram are forbidden with the same argument types. *)
  let has_subprogram_type_clash s1 s2 =
    match (s1, s2) with
    | ST_Getter, ST_Setter
    | ST_Setter, ST_Getter
    | ST_EmptyGetter, ST_EmptySetter
    | ST_EmptySetter, ST_EmptyGetter ->
        false
    | _ -> true

  (* Deduce renamings from match between calling and callee types. *)
  let deduce_eqs env =
    (* Here we assume [has_arg_clash env caller callee] *)
    (* Thus [List.length caller == List.length callee]. *)
    let folder prev_eqs caller (_name, callee) =
      match callee.desc with
      | T_Bits ({ desc = E_Var x; _ }, _) -> (
          match (Types.get_structure env caller).desc with
          | T_Bits (e_caller, _) -> (x, e_caller) :: prev_eqs
          | _ ->
              (* We know that callee type_clashes with caller, and that it
                 cannot be a name. *)
              assert false)
      | _ -> prev_eqs
    in
    List.fold_left2 folder []

  let add_new_func loc env name arg_types subpgm_type =
    match IMap.find_opt name env.global.subprogram_renamings with
    | None ->
        let env = set_renamings name (ISet.singleton name) env in
        (env, name)
    | Some set ->
        let name' = name ^ "-" ^ string_of_int (ISet.cardinal set) in
        let clash =
          let arg_types = List.map snd arg_types in
          (not (ISet.is_empty set))
          && ISet.exists
               (fun name'' ->
                 let other_func_sig, _ =
                   IMap.find name'' env.global.subprograms
                 in
                 has_subprogram_type_clash subpgm_type
                   other_func_sig.subprogram_type
                 && has_arg_clash env arg_types other_func_sig.args)
               set
        in
        let+ () =
         fun () ->
          if clash then
            let () =
              if false then
                Format.eprintf
                  "Function %s@[(%a)@] is declared multiple times.@." name
                  Format.(
                    pp_print_list
                      ~pp_sep:(fun f () -> fprintf f ",@ ")
                      PP.pp_typed_identifier)
                  arg_types
            in
            Error.fatal_from loc (Error.AlreadyDeclaredIdentifier name)
        in
        let env = set_renamings name (ISet.add name' set) env in
        (env, name')

  let find_name loc env name caller_arg_types =
    let () =
      if false then Format.eprintf "Trying to rename call to %S@." name
    in
    let renaming_set =
      try IMap.find name env.global.subprogram_renamings
      with Not_found -> undefined_identifier loc name
    in
    let get_func_sig name' =
      match IMap.find_opt name' env.global.subprograms with
      | Some (func_sig, ses)
        when has_arg_clash env caller_arg_types func_sig.args ->
          Some (name', func_sig, ses)
      | _ -> None
    in
    let matching_renamings = set_filter_map get_func_sig renaming_set in
    match matching_renamings with
    | [ (name', func_sig, ses) ] ->
        (deduce_eqs env caller_arg_types func_sig.args, name', func_sig, ses)
    | [] -> fatal_from loc (Error.NoCallCandidate (name, caller_arg_types))
    | _ :: _ ->
        fatal_from loc (Error.TooManyCallCandidates (name, caller_arg_types))

  let try_find_name =
    match C.check with
    | `TypeCheck -> find_name
    | `Warn | `Silence -> (
        fun loc env name caller_arg_types ->
          try find_name loc env name caller_arg_types
          with Error.ASLException _ as error -> (
            try
              match IMap.find_opt name env.global.subprograms with
              | None -> undefined_identifier loc ("function " ^ name)
              | Some (func_sig, ses) ->
                  if false then
                    Format.eprintf "@[<2>%a:@ No extra arguments for %s@]@."
                      PP.pp_pos loc name;
                  ([], name, func_sig, ses)
            with Error.ASLException _ -> raise error))
end

(* ---------------------------------------------------------------------------

                           Main type-checking module

   ---------------------------------------------------------------------------*)

module Annotate (C : ANNOTATE_CONFIG) = struct
  open Property (C)
  module Fn = FunctionRenaming (C)

  let should_reduce_to_call env name =
    IMap.mem name env.global.subprogram_renamings

  let should_slices_reduce_to_call env name slices =
    let args =
      try Some (List.map slice_as_single slices)
      with Invalid_argument _ -> None
    in
    match args with
    | None -> None
    | Some args -> if should_reduce_to_call env name then Some args else None

  let disjoint_slices_to_diet loc env slices =
    let eval env e =
      match reduce_constants env e with
      | L_Int z -> Z.to_int z
      | _ -> fatal_from e Error.(UnsupportedExpr (Static, e))
    in
    let module DI = Diet.Int in
    let one_slice loc env diet slice =
      let interval =
        let make x y =
          if x > y then fatal_from loc @@ Error.OverlappingSlices [ slice ]
          else DI.Interval.make x y
        in
        match slice with
        | Slice_Single e ->
            let x = eval env e in
            make x x
        | Slice_Range (e1, e2) ->
            let x = eval env e2 and y = eval env e1 in
            make x y
        | Slice_Length (e1, e2) ->
            let x = eval env e1 and y = eval env e2 in
            make x (x + y - 1)
        | Slice_Star (e1, e2) ->
            let x = eval env e1 and y = eval env e2 in
            make (x * y) ((x * (y + 1)) - 1)
      in
      let new_diet = DI.add interval DI.empty in
      if DI.is_empty (Diet.Int.inter new_diet diet) then DI.add interval diet
      else fatal_from loc Error.(OverlappingSlices slices)
    in
    List.fold_left (one_slice loc env) Diet.Int.empty slices

  let check_disjoint_slices loc env slices =
    if List.length slices <= 1 then ok
    else fun () ->
      let _ = disjoint_slices_to_diet loc env slices in
      ()

  exception NoSingleField

  let to_singles env =
    let eval e =
      match reduce_constants env e with
      | L_Int z -> Z.to_int z
      | _ -> raise NoSingleField
    in
    let one slice k =
      match slice with
      | Slice_Single e -> e :: k
      | Slice_Length (e1, e2) ->
          let i1 = eval e1 and i2 = eval e2 in
          let rec do_rec n =
            if n >= i2 then k
            else
              let e = E_Literal (L_Int (Z.of_int (i1 + n))) |> add_dummy_pos in
              e :: do_rec (n + 1)
          in
          do_rec 0
      | Slice_Range (e1, e2) ->
          let i1 = eval e1 and i2 = eval e2 in
          let rec do_rec i =
            if i > i1 then k
            else
              let e = E_Literal (L_Int (Z.of_int i)) |> add_dummy_pos in
              e :: do_rec (i + 1)
          in
          do_rec i2
      | Slice_Star _ -> raise NoSingleField
    in
    fun slices -> List.fold_right one slices []

  let slices_of_bitfield = function
    | BitField_Simple (_, slices)
    | BitField_Nested (_, slices, _)
    | BitField_Type (_, slices, _) ->
        slices

  let field_to_single env bf field =
    match find_bitfield_opt field bf with
    | Some bitfield -> to_singles env (slices_of_bitfield bitfield)
    | None -> raise NoSingleField

  let should_fields_reduce_to_call env name ty fields =
    match ty.desc with
    | T_Bits (_, bf) when should_reduce_to_call env name -> (
        try Some (name, list_concat_map (field_to_single env bf) fields)
        with NoSingleField -> None)
    | _ -> None

  let should_field_reduce_to_call env name ty field =
    should_fields_reduce_to_call env name ty [ field ]

  (* -------------------------------------------------------------------------

                              Annotate AST

     -------------------------------------------------------------------------- *)

  let check_type_satisfies' env t1 t2 () =
    let () =
      if false then
        Format.eprintf "@[<hv 2>Checking %a@ <: %a@]@." PP.pp_ty t1 PP.pp_ty t2
    in
    if Types.type_satisfies env t1 t2 then () else assumption_failed ()

  let get_bitvector_width' env t =
    match (Types.get_structure env t).desc with
    | T_Bits (n, _) -> n
    | _ -> assumption_failed ()

  let get_bitvector_width loc env t =
    try get_bitvector_width' env t
    with TypingAssumptionFailed -> conflict loc [ default_t_bits ] t

  let get_bitvector_const_width loc env t =
    let e_width = get_bitvector_width loc env t in
    match reduce_constants env e_width with
    | L_Int z -> Z.to_int z
    | _ -> assert false

  (** [check_type_satisfies t1 t2] if [t1 <: t2]. *)
  let check_type_satisfies loc env t1 t2 () =
    let () =
      if false then
        Format.eprintf "@[<hv 2>Checking %a@ <: %a@]@." PP.pp_ty t1 PP.pp_ty t2
    in
    if Types.type_satisfies env t1 t2 then () else conflict loc [ t2.desc ] t1

  (* CheckStructureBoolean *)

  (** [check_structure_boolean env t1] checks that [t1] has the structure of a boolean. *)
  let check_structure_boolean loc env t1 () =
    match (Types.get_structure env t1).desc with
    | T_Bool -> ()
    | _ -> conflict loc [ T_Bool ] t1
  (* End *)

  (* CheckStructureBits *)
  let check_structure_bits loc env t () =
    match (Types.get_structure env t).desc with
    | T_Bits _ -> ()
    | _ -> conflict loc [ default_t_bits ] t
  (* End *)

  (* Begin CheckStructureInteger *)
  let check_structure_integer loc env t () =
    let () =
      if false then
        Format.eprintf "Checking that %a is an integer.@." PP.pp_ty t
    in
    match (Types.make_anonymous env t).desc with
    | T_Int _ -> ()
    | _ -> conflict loc [ integer' ] t
  (* End *)

  (* Begin CheckConstrainedInteger *)
  let check_constrained_integer ~loc env t () =
    match (Types.make_anonymous env t).desc with
    | T_Int UnConstrained -> fatal_from loc Error.(ConstrainedIntegerExpected t)
    | T_Int (WellConstrained _ | UnderConstrained _) -> ()
    | _ -> conflict loc [ integer' ] t
  (* End *)

  (* Begin CheckStructureException *)
  let check_structure_exception loc env t () =
    let t_struct = Types.get_structure env t in
    match t_struct.desc with
    | T_Exception _ -> ()
    | _ -> conflict loc [ T_Exception [] ] t_struct
  (* End *)

  (* Begin StorageIsPure *)
  let global_storage_is_pure ~loc env s =
    match IMap.find_opt s env.global.storage_types with
    | Some (_, (GDK_Constant | GDK_Config | GDK_Let)) -> true
    | Some (_, GDK_Var) -> false
    | None -> undefined_identifier loc s

  let local_storage_is_pure ~loc env s =
    match IMap.find_opt s env.local.storage_types with
    | Some (_, (LDK_Constant | LDK_Let)) -> true
    | Some (_, LDK_Var) -> false
    | None -> undefined_identifier loc s
  (* End *)

  (* Begin CheckStaticallyEvaluable *)
  let is_statically_evaluable ~loc (env : env) ses =
    SE.for_all' ses @@ function
    | StringSpecified _ | Throwing _ | WriteGlobal _ | RecursiveCall _ -> false
    | ReadGlobal s -> global_storage_is_pure ~loc env s
    | ReadLocal s -> local_storage_is_pure ~loc env s
    | WriteLocal _ ->
        (* Cannot happen in an expression *)
        assert false
  (* End *)

  let check_statically_evaluable env ses e =
    check_true (is_statically_evaluable ~loc:e env ses) @@ fun () ->
    fatal_from e (UnpureExpression e)

  let check_bits_equal_width' env t1 t2 () =
    let n = get_bitvector_width' env t1 and m = get_bitvector_width' env t2 in
    if bitwidth_equal (StaticModel.equal_in_env env) n m then ()
    else assumption_failed ()

  (* Begin CheckBitsEqualWidth *)
  let check_bits_equal_width loc env t1 t2 () =
    try check_bits_equal_width' env t1 t2 ()
    with TypingAssumptionFailed ->
      fatal_from loc (Error.UnreconciliableTypes (t1, t2))
  (* End *)

  let has_bitvector_structure env t =
    match (Types.get_structure env t).desc with T_Bits _ -> true | _ -> false

  let expr_is_strict_positive e =
    match e.desc with
    | E_Literal (L_Int i) -> Z.sign i = 1
    | E_Var _n -> false
    | _ -> fatal_from e Error.(UnsupportedExpr (Static, e))

  let constraint_is_strict_positive = function
    | Constraint_Exact e | Constraint_Range (e, _) -> expr_is_strict_positive e

  let constraints_is_strict_positive =
    List.for_all constraint_is_strict_positive

  let expr_is_non_negative e =
    match e.desc with
    | E_Literal (L_Int i) -> Z.sign i != -1
    | E_Var _n -> false
    | _ -> fatal_from e Error.(UnsupportedExpr (Static, e))

  let constraint_is_non_negative = function
    | Constraint_Exact e | Constraint_Range (e, _) -> expr_is_non_negative e

  let constraints_is_non_negative = List.for_all constraint_is_non_negative

  let constraint_binop env op cs1 cs2 =
    let res = constraint_binop op cs1 cs2 |> reduce_constraints env in
    let () =
      if false then
        Format.eprintf
          "Reduction of binop %s@ on@ constraints@ %a@ and@ %a@ gave@ %a@."
          (PP.binop_to_string op) PP.pp_int_constraints cs1
          PP.pp_int_constraints cs2 PP.pp_ty
          (T_Int res |> add_dummy_pos)
    in
    res

  (* Begin TypeOfArrayLength *)
  let type_of_array_length ~loc = function
    | ArrayLength_Enum (s, _) -> T_Named s |> add_pos_from loc
    | ArrayLength_Expr _ -> integer |: TypingRule.TypeOfArrayLength
  (* End *)

  (* Begin CheckBinop *)
  let check_binop loc env op t1 t2 : ty =
    let () =
      if false then
        Format.eprintf "Checking binop %s between %a and %a@."
          (PP.binop_to_string op) PP.pp_ty t1 PP.pp_ty t2
    in
    let with_loc = add_pos_from loc in
    either
      (fun () ->
        match op with
        | BAND | BOR | BEQ | IMPL ->
            let+ () = check_type_satisfies' env t1 boolean in
            let+ () = check_type_satisfies' env t2 boolean in
            T_Bool |> with_loc
        | AND | OR | EOR (* when has_bitvector_structure env t1 ? *) ->
            (* Rule KXMR: If the operands of a primitive operation are
               bitvectors, the widths of the operands must be equivalent
               statically evaluable expressions. *)
            let+ () = check_bits_equal_width' env t1 t2 in
            let w = get_bitvector_width' env t1 in
            T_Bits (w, []) |> with_loc
        | (PLUS | MINUS) when has_bitvector_structure env t1 ->
            (* Rule KXMR: If the operands of a primitive operation are
               bitvectors, the widths of the operands must be equivalent
               statically evaluable expressions. *)
            let+ () =
              either
                (check_bits_equal_width' env t1 t2)
                (check_type_satisfies' env t2 integer)
            in
            let w = get_bitvector_width' env t1 in
            T_Bits (w, []) |> with_loc
        | EQ_OP | NEQ ->
            (* Wrong! *)
            let t1_anon = Types.make_anonymous env t1
            and t2_anon = Types.make_anonymous env t2 in
            let+ () =
              any
                [
                  (* If an argument of a comparison operation is a
                     constrained integer then it is treated as an
                     unconstrained integer. *)
                  both
                    (check_type_satisfies' env t1_anon integer)
                    (check_type_satisfies' env t2_anon integer);
                  (* If the arguments of a comparison operation are
                     bitvectors then they must have the same determined
                     width. *)
                  check_bits_equal_width' env t1_anon t2_anon;
                  both
                    (check_type_satisfies' env t1_anon boolean)
                    (check_type_satisfies' env t2_anon boolean);
                  both
                    (check_type_satisfies' env t1_anon real)
                    (check_type_satisfies' env t2_anon real);
                  both
                    (check_type_satisfies' env t1_anon string)
                    (check_type_satisfies' env t2_anon string);
                  (fun () ->
                    match (t1_anon.desc, t2_anon.desc) with
                    | T_Enum li1, T_Enum li2 ->
                        check_true' (list_equal String.equal li1 li2) ()
                    | _ -> assumption_failed ());
                ]
            in
            T_Bool |> with_loc
        | LEQ | GEQ | GT | LT ->
            let+ () =
              either
                (both
                   (check_type_satisfies' env t1 integer)
                   (check_type_satisfies' env t2 integer))
                (both
                   (check_type_satisfies' env t1 real)
                   (check_type_satisfies' env t2 real))
            in
            T_Bool |> with_loc
        | MUL | DIV | DIVRM | MOD | SHL | SHR | POW | PLUS | MINUS -> (
            let struct1 = Types.get_well_constrained_structure env t1
            and struct2 = Types.get_well_constrained_structure env t2 in
            match (struct1.desc, struct2.desc) with
            | T_Int UnConstrained, T_Int _ | T_Int _, T_Int UnConstrained ->
                (* Rule ZYWY: If both operands of an integer binary primitive
                   operator are integers and at least one of them is an
                   unconstrained integer then the result shall be an
                   unconstrained integer. *)
                (* TODO: check that no other checks are necessary. *)
                T_Int UnConstrained |> with_loc
            | T_Int (UnderConstrained _), _ | _, T_Int (UnderConstrained _) ->
                assert false (* We used to_well_constrained before *)
            | T_Int (WellConstrained cs1), T_Int (WellConstrained cs2) ->
                (* Rule KFYS: If both operands of an integer binary primitive
                   operation are well-constrained integers, then it shall
                   return a constrained integer whose constraint is calculated
                   by applying the operation to all possible value pairs. *)
                let+ () =
                  match op with
                  | DIV ->
                      (* TODO cs1 divides cs2 ? How is it expressable in term of constraints? *)
                      check_true' (constraints_is_strict_positive cs2)
                  | DIVRM | MOD ->
                      (* assert cs2 strict-positive *)
                      check_true' (constraints_is_strict_positive cs2)
                  | SHL | SHR ->
                      (* assert cs2 non-negative *)
                      check_true' (constraints_is_non_negative cs2)
                  | _ -> fun () -> ()
                in
                let cs =
                  best_effort UnConstrained (fun _ ->
                      constraint_binop env op cs1 cs2)
                in
                T_Int cs |> with_loc
            | T_Real, T_Real -> (
                match op with
                | PLUS | MINUS | MUL -> T_Real |> with_loc
                | _ -> assumption_failed ())
            | T_Real, T_Int _ -> (
                match op with
                | POW -> T_Real |> with_loc
                | _ -> assumption_failed ())
            | _ -> assumption_failed ())
        | RDIV ->
            let+ () =
              both
                (check_type_satisfies' env t1 real)
                (check_type_satisfies' env t2 real)
            in
            T_Real |> with_loc)
      (fun () -> fatal_from loc (Error.BadTypesForBinop (op, t1, t2)))
      ()
    |: TypingRule.CheckBinop
  (* End *)

  (* Begin CheckUnop *)
  let check_unop loc env op t1 =
    match op with
    | BNOT ->
        let+ () = check_type_satisfies loc env t1 boolean in
        T_Bool |> add_pos_from loc
    | NEG -> (
        let+ () =
          either
            (check_type_satisfies loc env t1 integer)
            (check_type_satisfies loc env t1 real)
        in
        let struct1 = Types.get_well_constrained_structure env t1 in
        match struct1.desc with
        | T_Int UnConstrained -> T_Int UnConstrained |> add_pos_from loc
        | T_Int (WellConstrained cs) ->
            let neg e = E_Unop (NEG, e) |> add_pos_from e in
            let constraint_minus = function
              | Constraint_Exact e -> Constraint_Exact (neg e)
              | Constraint_Range (top, bot) ->
                  Constraint_Range (neg bot, neg top)
            in
            T_Int (WellConstrained (List.map constraint_minus cs))
            |> add_pos_from loc
        | T_Int (UnderConstrained _) ->
            assert false (* We used to_well_constrained just before. *)
        | _ -> (* fail case *) t1)
    | NOT ->
        let+ () = check_structure_bits loc env t1 in
        t1 |: TypingRule.CheckUnop
  (* End *)

  let var_in_env ?(local = true) env x =
    (local && IMap.mem x env.local.storage_types)
    || IMap.mem x env.global.storage_types
    || IMap.mem x env.global.subprograms
    || IMap.mem x env.global.declared_types

  let check_var_not_in_env ?(local = true) loc env x () =
    if var_in_env ~local env x then
      fatal_from loc (Error.AlreadyDeclaredIdentifier x)
    else ()

  let check_var_not_in_genv loc = check_var_not_in_env ~local:false loc

  let get_variable_enum' env e =
    match e.desc with
    | E_Var x -> (
        match IMap.find_opt x env.global.declared_types with
        | Some t -> (
            match (Types.make_anonymous env t).desc with
            | T_Enum li -> Some (x, List.length li)
            | _ -> None)
        | None -> None)
    | _ -> None

  let check_diet_in_width loc slices width diet () =
    let x = Diet.Int.min_elt diet |> Diet.Int.Interval.x
    and y = Diet.Int.max_elt diet |> Diet.Int.Interval.y in
    if 0 <= x && y < width then ()
    else fatal_from loc (BadSlices (Error.Static, slices, width))

  let check_slices_in_width loc env width slices () =
    let diet = disjoint_slices_to_diet loc env slices in
    check_diet_in_width loc slices width diet ()

  (* Begin TBitField *)
  let rec annotate_bitfield ~loc env width bitfield : bitfield =
    match bitfield with
    | BitField_Simple (name, slices) ->
        let slices1 = annotate_constant_slices ~loc env slices in
        let+ () = check_slices_in_width loc env width slices1 in
        BitField_Simple (name, slices1) |: TypingRule.TBitField
    | BitField_Nested (name, slices, bitfields') ->
        let slices1 = annotate_constant_slices ~loc env slices in
        let diet = disjoint_slices_to_diet loc env slices1 in
        let+ () = check_diet_in_width loc slices1 width diet in
        let width' = Diet.Int.cardinal diet |> expr_of_int in
        let bitfields'' = annotate_bitfields ~loc env width' bitfields' in
        BitField_Nested (name, slices1, bitfields'') |: TypingRule.TBitField
    | BitField_Type (name, slices, ty) ->
        let ty' = annotate_type ~loc env ty in
        let slices1 = annotate_constant_slices ~loc env slices in
        let diet = disjoint_slices_to_diet loc env slices1 in
        let+ () = check_diet_in_width loc slices1 width diet in
        let width' = Diet.Int.cardinal diet |> expr_of_int in
        let+ () =
          t_bits_bitwidth width' |> add_dummy_pos
          |> check_bits_equal_width loc env ty
        in
        BitField_Type (name, slices1, ty') |: TypingRule.TBitField
  (* End *)

  (* Begin TBitFields *)
  and annotate_bitfields ~loc env e_width bitfields =
    let+ () =
      match get_first_duplicate bitfield_get_name bitfields with
      | None -> ok
      | Some x -> fun () -> fatal_from loc (Error.AlreadyDeclaredIdentifier x)
    in
    let width =
      let v = reduce_constants env e_width in
      match v with L_Int i -> Z.to_int i | _ -> assert false
    in
    List.map (annotate_bitfield ~loc env width) bitfields
    |: TypingRule.TBitFields
  (* End *)

  and annotate_type ?(decl = false) ~(loc : 'a annotated) env ty : ty =
    let () =
      if false then
        Format.eprintf "Annotating@ %a@ in env:@ %a@." PP.pp_ty ty
          StaticEnv.pp_env env
    in
    let here t = add_pos_from ty t in
    best_effort ty @@ fun _ ->
    match ty.desc with
    (* Begin TString *)
    | T_String -> ty |: TypingRule.TString
    (* Begin TReal *)
    | T_Real -> ty |: TypingRule.TReal
    (* Begin TBool *)
    | T_Bool -> ty |: TypingRule.TBool
    (* Begin TNamed *)
    | T_Named x ->
        let+ () =
          if IMap.mem x env.global.declared_types then ok
          else fun () -> undefined_identifier loc x
        in
        ty |: TypingRule.TNamed
    (* Begin TInt *)
    | T_Int constraints ->
        (match constraints with
        | WellConstrained constraints ->
            let new_constraints =
              List.map (annotate_constraint ~loc env) constraints
            in
            T_Int (WellConstrained new_constraints) |> here
        | UnderConstrained _ | UnConstrained -> ty)
        |: TypingRule.TInt
    (* Begin TBits *)
    | T_Bits (e_width, bitfields) ->
        let e_width' = annotate_static_constrained_integer ~loc env e_width in
        let bitfields' =
          if bitfields = [] then bitfields
          else annotate_bitfields ~loc env e_width' bitfields
        in
        T_Bits (e_width', bitfields') |> here |: TypingRule.TBits
    (* Begin TTuple *)
    | T_Tuple tys ->
        let tys' = List.map (annotate_type ~loc env) tys in
        T_Tuple tys' |> here |: TypingRule.TTuple
    (* Begin TArray *)
    | T_Array (index, t) ->
        let t' = annotate_type ~loc env t
        and index' =
          match index with
          | ArrayLength_Expr e -> (
              match get_variable_enum' env e with
              | Some (s, i) -> ArrayLength_Enum (s, i)
              | None ->
                  let e' = annotate_static_integer ~loc env e in
                  ArrayLength_Expr e')
          | ArrayLength_Enum (s, i) -> (
              let t_s = T_Named s |> here in
              match (Types.make_anonymous env t_s).desc with
              | T_Enum li when List.length li = i -> index
              | _ -> conflict loc [ T_Enum [] ] t_s)
        in
        T_Array (index', t') |> here |: TypingRule.TArray
    (* Begin TRecordExceptionDecl *)
    | (T_Record fields | T_Exception fields) when decl -> (
        let+ () =
          match get_first_duplicate fst fields with
          | None -> ok
          | Some x ->
              fun () -> fatal_from loc (Error.AlreadyDeclaredIdentifier x)
        in
        let fields' =
          List.map (fun (x, ty) -> (x, annotate_type ~loc env ty)) fields
        in
        match ty.desc with
        | T_Record _ ->
            T_Record fields' |> here |: TypingRule.TRecordExceptionDecl
        | T_Exception _ ->
            T_Exception fields' |> here |: TypingRule.TRecordExceptionDecl
        | _ -> assert false
        (* Begin TEnumDecl *))
    | T_Enum li when decl ->
        let+ () =
          match get_first_duplicate Fun.id li with
          | None -> ok
          | Some x ->
              fun () -> fatal_from loc (Error.AlreadyDeclaredIdentifier x)
        in
        let+ () =
         fun () -> List.iter (fun s -> check_var_not_in_genv ty env s ()) li
        in
        ty |: TypingRule.TEnumDecl
        (* Begin TNonDecl *)
    | T_Enum _ | T_Record _ | T_Exception _ ->
        if decl then assert false
        else
          fatal_from loc
            (Error.NotYetImplemented
               " Cannot use non anonymous form of enumerations, record, or \
                exception here.")
          |: TypingRule.TNonDecl
  (* End *)

  and annotate_static_integer ~(loc : 'a annotated) env e =
    let t, e' = annotate_static_expr env e in
    let+ () = check_structure_integer loc env t in
    reduce_expr env e'

  (* Begin StaticConstrainedInteger *)
  and annotate_static_constrained_integer ~(loc : 'a annotated) env e =
    let t, e' = annotate_static_expr env e in
    let+ () = check_constrained_integer ~loc env t in
    reduce_expr env e'
  (* End *)

  and annotate_constraint ~loc env = function
    | Constraint_Exact e ->
        let e' = annotate_static_constrained_integer ~loc env e in
        Constraint_Exact e'
    | Constraint_Range (e1, e2) ->
        let e1' = annotate_static_constrained_integer ~loc env e1
        and e2' = annotate_static_constrained_integer ~loc env e2 in
        Constraint_Range (e1', e2')

  and annotate_slices ~loc env =
    (* Rules:
       - Rule WZCS: The width of a bitslice must be any non-negative,
         statically evaluable integer expression (including zero).
    *)
    let rec tr_one s =
      let () =
        if false then
          Format.eprintf "Annotating slice %a@." PP.pp_slice_list [ s ]
      in
      match s with
      (* Begin SliceSingle *)
      | Slice_Single i ->
          (* LRM R_GXKG:
             The notation b[i] is syntactic sugar for b[i +: 1].
          *)
          tr_one (Slice_Length (i, !$1)) |: TypingRule.SliceSingle
      (* End *)
      (* Begin SliceLength *)
      | Slice_Length (offset, length) ->
          let t_offset, offset', ses_offset = annotate_expr env offset
          and length' =
            annotate_static_constrained_integer ~loc:(to_pos length) env length
          in
          let+ () = check_structure_integer offset' env t_offset in
          (Slice_Length (offset', length'), ses_offset)
          |: TypingRule.SliceLength
      (* End *)
      (* Begin SliceRange *)
      | Slice_Range (j, i) ->
          (* LRM R_GXKG:
             The notation b[j:i] is syntactic sugar for b[i +: j-i+1].
          *)
          let pre_length = binop MINUS j i |> binop PLUS !$1 in
          tr_one (Slice_Length (i, pre_length)) |: TypingRule.SliceRange
      (* End *)
      (* Begin SliceStar *)
      | Slice_Star (factor, pre_length) ->
          (* LRM R_GXQG:
             The notation b[i *: n] is syntactic sugar for b[i*n +: n]
          *)
          let pre_offset = binop MUL factor pre_length in
          tr_one (Slice_Length (pre_offset, pre_length)) |: TypingRule.SliceStar
      (* End *)
    in
    fun slices ->
      let slices', ses = List.map tr_one slices |> List.split in
      (slices', SE.big_non_concurrent_union ~loc ses)

  and try_annotate_slices ~loc env slices =
    best_effort (slices, SE.pure) (fun _ -> annotate_slices ~loc env slices)

  and annotate_constant_slices ~loc env slices =
    let slices', ses = annotate_slices ~loc env slices in
    let+ () =
      check_true (SE.SESet.is_empty ses) @@ fun () ->
      Error.(
        fatal_from loc
          (UnpureExpression (E_Slice (var_ "slices", slices) |> add_dummy_pos)))
    in
    slices'

  and annotate_pattern loc env t = function
    (* Begin PAll *)
    | Pattern_All as p -> p |: TypingRule.PAll
    (* End *)
    (* Begin PAny *)
    | Pattern_Any li ->
        let new_li = List.map (annotate_pattern loc env t) li in
        Pattern_Any new_li |: TypingRule.PAny
    (* End *)
    (* Begin PNot *)
    | Pattern_Not q ->
        let new_q = annotate_pattern loc env t q in
        Pattern_Not new_q |: TypingRule.PNot
    (* End *)
    (* Begin PSingle *)
    | Pattern_Single e ->
        let t_e, e' = annotate_static_expr env e in
        let+ () =
         fun () ->
          let t_struct = Types.make_anonymous env t
          and t_e_struct = Types.make_anonymous env t_e in
          match (t_struct.desc, t_e_struct.desc) with
          | T_Bool, T_Bool | T_Real, T_Real | T_Int _, T_Int _ -> ()
          | T_Bits _, T_Bits _ ->
              check_bits_equal_width loc env t_struct t_e_struct ()
          (* TODO: Multiple discriminants can be matched at once by
             forming a tuple of discriminants and a tuple used in the
             pattern_set.
             Both tuples must have the same number of elements. A
             successful pattern match occurs when each discriminant
             term matches the respective term of the pattern tuple. *)
          | T_Enum li1, T_Enum li2 when list_equal String.equal li1 li2 -> ()
          | _ -> fatal_from loc (Error.BadTypesForBinop (EQ_OP, t, t_e))
        in
        Pattern_Single e' |: TypingRule.PSingle
    (* End *)
    (* Begin PGeq *)
    | Pattern_Geq e ->
        let t_e, e' = annotate_static_expr env e in
        let+ () =
         fun () ->
          let t_struct = Types.get_structure env t
          and t_e_struct = Types.get_structure env t_e in
          match (t_struct.desc, t_e_struct.desc) with
          | T_Real, T_Real | T_Int _, T_Int _ -> ()
          | _ -> fatal_from loc (Error.BadTypesForBinop (GEQ, t, t_e))
        in
        Pattern_Geq e' |: TypingRule.PGeq
    (* End *)
    (* Begin PLeq *)
    | Pattern_Leq e ->
        let t_e, e' = annotate_static_expr env e in
        let+ () =
          both (* TODO: case where they are both real *)
            (check_structure_integer loc env t)
            (check_structure_integer loc env t_e)
        in
        Pattern_Leq e' |: TypingRule.PLeq
    (* End *)
    (* Begin PRange *)
    | Pattern_Range (e1, e2) ->
        let t_e1, e1' = annotate_static_expr env e1
        and t_e2, e2' = annotate_static_expr env e2 in
        let+ () =
         fun () ->
          let t_struct = Types.get_structure env t
          and t_e1_struct = Types.get_structure env t_e1
          and t_e2_struct = Types.get_structure env t_e2 in
          match (t_struct.desc, t_e1_struct.desc, t_e2_struct.desc) with
          | T_Real, T_Real, T_Real | T_Int _, T_Int _, T_Int _ -> ()
          | _, T_Int _, T_Int _ | _, T_Real, T_Real ->
              fatal_from loc (Error.BadTypesForBinop (GEQ, t, t_e1))
          | _ -> fatal_from loc (Error.BadTypesForBinop (GEQ, t_e1, t_e2))
        in
        Pattern_Range (e1', e2') |: TypingRule.PRange
    (* End *)
    (* Begin PMask *)
    | Pattern_Mask m as p ->
        let+ () = check_structure_bits loc env t in
        let+ () =
          let n = !$(Bitvector.mask_length m) in
          let t_m = T_Bits (n, []) |> add_pos_from loc in
          check_type_satisfies loc env t t_m
        in
        p |: TypingRule.PMask
    (* End *)
    (* Begin PTuple *)
    | Pattern_Tuple li -> (
        let t_struct = Types.get_structure env t in
        match t_struct.desc with
        | T_Tuple ts when List.compare_lengths li ts != 0 ->
            Error.fatal_from loc
              (Error.BadArity
                 ("pattern matching on tuples", List.length li, List.length ts))
        | T_Tuple ts ->
            let new_li = List.map2 (annotate_pattern loc env) ts li in
            Pattern_Tuple new_li |: TypingRule.PTuple
        | _ -> conflict loc [ T_Tuple [] ] t
        (* End *))

  and annotate_call loc env name args eqs call_type =
    let () = assert (List.length eqs == 0) in
    (* Begin FindCheckDeduce *)
    let () =
      if false then
        Format.eprintf "Annotating call to %S (%s) at %a.@." name
          (Serialize.subprogram_type_to_string call_type)
          PP.pp_pos loc
    in
    let caller_arg_typed = List.map (annotate_expr env) args in
    let caller_arg_types, args1, ses_list1 = list_split3 caller_arg_typed in
    let ses1 = SE.big_non_concurrent_union ~loc ses_list1 in
    let extra_nargs, name1, callee, callee_ses =
      Fn.try_find_name loc env name caller_arg_types
    in
    let ses2 = SE.union ses1 callee_ses in
    let () =
      if false then
        Format.eprintf "@[Found candidate decl:@ @[%a@]@]@." PP.pp_t
          [ D_Func callee |> add_dummy_pos ]
    in
    let+ () =
      check_true (callee.subprogram_type = call_type) @@ fun () ->
      fatal_from loc (MismatchedReturnValue name)
    in
    let () =
      if false then
        let open Format in
        eprintf "Parameters for this call: %a@."
          (pp_print_list ~pp_sep:pp_print_space (fun f (name, e) ->
               fprintf f "%S<--%a" name (pp_print_option PP.pp_ty) e))
          callee.parameters
    in
    let () =
      if false then
        match extra_nargs with
        | [] -> ()
        | _ ->
            Format.eprintf "@[<2>%a: Adding@ @[{%a}@]@ to call of %s@."
              PP.pp_pos loc
              (Format.pp_print_list
                 ~pp_sep:(fun f () -> Format.fprintf f ";@ ")
                 (fun f (n, e) ->
                   Format.fprintf f "@[%s@ <- %a@]" n PP.pp_expr e))
              extra_nargs name
    in
    let eqs1 = List.rev_append eqs extra_nargs in
    let () =
      if List.compare_lengths callee.args args1 != 0 then
        fatal_from loc
        @@ Error.BadArity (name, List.length callee.args, List.length args1)
    in
    let eqs2 =
      let folder acc (_x, ty) t_e =
        match ty.desc with
        | T_Bits ({ desc = E_Var x; _ }, _) -> (
            match (Types.get_structure env t_e).desc with
            | T_Bits (e, _) -> (
                match List.assoc_opt x acc with
                | None -> (x, e) :: acc
                | Some e' ->
                    if StaticModel.equal_in_env env e e' then acc
                    else (x, e) :: acc)
            | _ -> acc)
        | _ -> acc
      in
      match C.check with
      | `TypeCheck -> eqs1
      | `Warn | `Silence ->
          List.fold_left2 folder eqs1 callee.args caller_arg_types
    in
    let eqs3 =
      List.map
        (fun (param_name, e) ->
          let e' = annotate_static_constrained_integer ~loc env e in
          (param_name, e'))
        eqs2
    in
    let eqs4 =
      List.fold_left2
        (fun eqs (callee_x, _) (caller_ty, caller_e, _caller_ses) ->
          if
            List.exists
              (fun (p_name, _ty) -> String.equal callee_x p_name)
              callee.parameters
          then
            let+ () = check_constrained_integer ~loc env caller_ty in
            (callee_x, caller_e) :: eqs
          else eqs)
        eqs3 callee.args caller_arg_typed
    in
    let () =
      if false then
        let open Format in
        eprintf "@[<hov 2>Eqs for this call are: %a@]@."
          (pp_print_list ~pp_sep:pp_print_space (fun f (name, e) ->
               fprintf f "%S<--%a" name PP.pp_expr e))
          eqs4
    in
    let () =
      List.iter2
        (fun (callee_arg_name, callee_arg) caller_arg ->
          let callee_arg = rename_ty_eqs env eqs4 callee_arg in
          let () =
            if false then
              Format.eprintf "Checking calling arg %s from %a to %a@."
                callee_arg_name PP.pp_ty caller_arg PP.pp_ty callee_arg
          in
          let+ () = check_type_satisfies loc env caller_arg callee_arg in
          ())
        callee.args caller_arg_types
    in
    let () =
      if false && not (String.equal name name1) then
        Format.eprintf "Renaming call from %s to %s@ at %a.@." name name1
          PP.pp_pos loc
    in
    let () =
      List.iter
        (function
          | _, None -> ()
          | s, Some { desc = T_Int (UnderConstrained (_, s')); _ }
            when String.equal s' s ->
              ()
          | callee_param_name, Some callee_param_t ->
              let callee_param_t_renamed =
                rename_ty_eqs env eqs4 callee_param_t
              in
              let caller_param_e =
                match List.assoc_opt callee_param_name eqs4 with
                | None ->
                    assert false
                    (* Bad behaviour, there should be a defining expression *)
                | Some e -> e
              in
              let caller_param_t, _ = annotate_static_expr env caller_param_e in
              let () =
                if false then
                  Format.eprintf
                    "Checking calling param %s from %a to %a (i.e. %a)@."
                    callee_param_name PP.pp_ty caller_param_t PP.pp_ty
                    callee_param_t PP.pp_ty callee_param_t_renamed
              in
              let+ () =
                check_type_satisfies loc env caller_param_t
                  callee_param_t_renamed
              in
              ())
        callee.parameters
      |: TypingRule.FindCheckDeduce
    in
    (* End *)
    (* Begin FCall *)
    let ret_ty1 =
      match (call_type, callee.return_type) with
      | (ST_Function | ST_Getter | ST_EmptyGetter), Some ty ->
          Some (rename_ty_eqs env eqs4 ty |> annotate_type env ~loc)
      | (ST_Setter | ST_EmptySetter | ST_Procedure), None -> None
      | _ -> fatal_from loc @@ Error.MismatchedReturnValue name
    in
    let () = if false then Format.eprintf "Annotated call to %S.@." name1 in
    (name1, args1, eqs4, ret_ty1, ses2) |: TypingRule.FCall
  (* End *)

  and annotate_expr env (e : expr) : ty * expr * side_effects =
    let () = if false then Format.eprintf "@[Annotating %a@]@." PP.pp_expr e in
    let here x = add_pos_from e x and loc = to_pos e in
    match e.desc with
    (* Begin ELit *)
    | E_Literal v -> (annotate_literal v |> here, e, SE.pure) |: TypingRule.ELit
    (* End *)
    (* Begin ATC *)
    | E_ATC (e', ty) ->
        let t, e'', ses = annotate_expr env e' in
        let t_struct = Types.get_structure env t in
        let ty' = annotate_type ~loc env ty in
        let ty_struct = Types.get_structure env ty' in
        (if Types.type_equal env t_struct ty_struct then (ty', e'', ses)
         else
           match (t_struct.desc, ty_struct.desc) with
           | T_Bits _, T_Bits _ | T_Int _, T_Int _ ->
               (ty', E_ATC (e'', ty_struct) |> here, ses)
           | _ -> fatal_from e (BadATC (t, ty')))
        |: TypingRule.ATC
    (* End *)
    | E_Var x -> (
        let () = if false then Format.eprintf "Looking at %S.@." x in
        if should_reduce_to_call env x then
          let () =
            if false then
              Format.eprintf "@[Reducing getter %S@ at %a@]@." x PP.pp_pos e
          in
          let name, args, eqs, ty, ses =
            annotate_call (to_pos e) env x [] [] ST_EmptyGetter
          in
          let ty = match ty with Some ty -> ty | None -> assert false in
          (ty, E_Call (name, args, eqs) |> here, ses)
        else
          let () =
            if false then
              Format.eprintf "@[Choosing not to reduce var %S@ at @[%a@]@]@." x
                PP.pp_pos e
          in
          try
            match IMap.find x env.local.storage_types with
            (* Begin ELocalVarConstant *)
            | ty, LDK_Constant ->
                let v = IMap.find x env.local.constant_values in
                let e = E_Literal v |> here in
                (ty, e, SE.pure) |: TypingRule.ELocalVarConstant
            (* End *)
            (* Begin ELocalVar *)
            | ty, _ ->
                (ty, e, (* TODO only store read to mutables? *) SE.read_local x)
                |: TypingRule.ELocalVar
            (* End *)
          with Not_found -> (
            try
              match IMap.find x env.global.storage_types with
              (* Begin EGlobalVarConstant *)
              | ty, GDK_Constant -> (
                  match IMap.find_opt x env.global.constant_values with
                  | Some v ->
                      (ty, E_Literal v |> here, SE.pure)
                      |: TypingRule.EGlobalVarConstantVal
                  (* End *)
                  (* Begin EGlobalVarConstantNoVal *)
                  | None ->
                      (ty, e, SE.pure) |: TypingRule.EGlobalVarConstantNoVal)
              (* End *)
              (* Begin EGlobalVar *)
              | ty, _ ->
                  ( ty,
                    e,
                    (* TODO only store reads to mutables? *) SE.read_global x )
                  |: TypingRule.EGlobalVar
              (* End *)
              (* Begin EUndefIdent *)
            with Not_found ->
              let () =
                if false then
                  Format.eprintf "@[Cannot find %s in env@ %a.@]@." x pp_env env
              in
              undefined_identifier e x |: TypingRule.EUndefIdent))
    (* End *)
    (* Begin Binop *)
    | E_Binop (op, e1, e2) ->
        let t1, e1', ses1 = annotate_expr env e1 in
        let t2, e2', ses2 = annotate_expr env e2 in
        let t = check_binop e env op t1 t2 in
        let ses = SE.non_concurrent_union ~loc:e ses1 ses2 in
        (t, E_Binop (op, e1', e2') |> here, ses) |: TypingRule.Binop
    (* End *)
    (* Begin Unop *)
    | E_Unop (op, e') ->
        let t'', e'', ses = annotate_expr env e' in
        let t = check_unop e env op t'' in
        (t, E_Unop (op, e'') |> here, ses) |: TypingRule.Unop
    (* End *)
    (* Begin ECall *)
    | E_Call (name, args, eqs) ->
        let () = assert (List.length eqs == 0) in
        let name', args', eqs', ty_opt, ses =
          annotate_call (to_pos e) env name args [] ST_Function
        in
        let t = match ty_opt with Some ty -> ty | None -> assert false in
        (t, E_Call (name', args', eqs') |> here, ses) |: TypingRule.ECall
    (* End *)
    (* Begin ECond *)
    | E_Cond (e_cond, e_true, e_false) ->
        let t_cond, e_cond', ses_cond = annotate_expr env e_cond in
        let+ () = check_structure_boolean e env t_cond in
        let t_true, e_true', ses_true = annotate_expr env e_true
        and t_false, e_false', ses_false = annotate_expr env e_false in
        let t =
          best_effort t_true (fun _ ->
              match Types.lowest_common_ancestor env t_true t_false with
              | None ->
                  fatal_from e (Error.UnreconciliableTypes (t_true, t_false))
              | Some t -> t)
        in
        let ses = SE.union ses_cond (SE.union ses_true ses_false) in
        (t, E_Cond (e_cond', e_true', e_false') |> here, ses)
        |: TypingRule.ECond
    (* End *)
    (* Begin ETuple *)
    | E_Tuple li ->
        let ts, es, ses = annotate_expr_list ~loc env li in
        (T_Tuple ts |> here, E_Tuple es |> here, ses) |: TypingRule.ETuple
    (* End *)
    | E_Concat [] -> fatal_from loc UnrespectedParserInvariant
    (* Begin EConcat *)
    | E_Concat (_ :: _ as li) ->
        let ts, es, ses = annotate_expr_list ~loc env li in
        let w =
          let widths = List.map (get_bitvector_width e env) ts in
          let wh = List.hd widths and wts = List.tl widths in
          List.fold_left (width_plus env) wh wts
        in
        (T_Bits (w, []) |> here, E_Concat es |> here, ses) |: TypingRule.EConcat
    (* End *)
    | E_Record (ty, fields) ->
        (* Rule WBCQ: The identifier in a record expression must be a named type
           with the structure of a record type, and whose fields have the values
           given in the field_assignment_list.
           Rule WZWC: The identifier in a exception expression must be a named
           type with the structure of an exception type, and whose fields have
           the values given in the field_assignment_list.
        *)
        let+ () =
          check_true (Types.is_named ty) (fun () ->
              failwith "Typing error: should be a named type")
        in
        let field_types =
          (* Begin EStructuredNotStructured *)
          match (Types.make_anonymous env ty).desc with
          | T_Exception fields | T_Record fields -> fields
          | _ ->
              conflict e [ T_Record [] ] ty
              |: TypingRule.EStructuredNotStructured
          (* End *)
        in
        let ses, fields' =
          best_effort (SE.pure, fields) (fun _ ->
              (* Rule DYQZ: A record expression shall assign every field of the record. *)
              (* TODO: Check that no field is assigned twice. *)
              let () =
                if
                  List.for_all
                    (fun (name, _) -> List.mem_assoc name fields)
                    field_types
                then ()
                else
                  (* Begin EStructuredMissingField *)
                  fatal_from e (Error.MissingField (List.map fst fields, ty))
                  |: TypingRule.EStructuredMissingField
                (* End *)
                (* and whose fields have the values given in the field_assignment_list. *)
              in
              let+ () =
                match get_first_duplicate fst fields with
                | None -> ok
                | Some x ->
                    fun () -> fatal_from loc (Error.AlreadyDeclaredIdentifier x)
              in
              (* Begin ERecord *)
              list_fold_left_map
                (fun ses (name, e') ->
                  let t', e'', ses' = annotate_expr env e' in
                  let t_spec' =
                    match List.assoc_opt name field_types with
                    | None -> fatal_from e (Error.BadField (name, ty))
                    | Some t_spec' -> t_spec'
                  in
                  (* TODO:
                     Rule LXQZ: A storage element of type S, where S is any
                     type that does not have the structure of the
                     under-constrained integer type, may only be assigned
                     or initialized with a value of type T if T
                     type-satisfies S. *)
                  let+ () = check_type_satisfies e env t' t_spec' in
                  let ses = SE.non_concurrent_union ~loc:e ses ses' in
                  (ses, (name, e'')))
                SE.pure fields)
        in
        (ty, E_Record (ty, fields') |> here, ses) |: TypingRule.ERecord
    (* End *)
    (* Begin EUnknown *)
    | E_Unknown ty ->
        let ty1 = annotate_type ~loc env ty in
        let ty2 = Types.get_structure env ty1 in
        (* TODO use of unknown -> side effect *)
        (ty1, E_Unknown ty2 |> here, SE.pure) |: TypingRule.EUnknown
    (* End *)
    | E_Slice (e', slices) -> (
        (* Begin ReduceSlicesToCall *)
        let reduced =
          match e'.desc with
          | E_Var x ->
              should_slices_reduce_to_call env x slices
              |> Option.map (pair x)
              |: TypingRule.ReduceSlicesToCall
          | _ -> None
          (* End *)
        in
        match reduced with
        (* Begin ESetter *)
        | Some (name, args) ->
            let name1, args1, eqs, ty, ses =
              annotate_call (to_pos e) env name args [] ST_Getter
            in
            let ty = match ty with Some ty -> ty | None -> assert false in
            (ty, E_Call (name1, args1, eqs) |> here, ses) |: TypingRule.ESetter
        (* End *)
        | None -> (
            let t_e', e'', ses_e' = annotate_expr env e' in
            let struct_t_e' = Types.make_anonymous env t_e' in
            match struct_t_e'.desc with
            (* Begin ESlice *)
            | T_Int _ | T_Bits _ ->
                let w = slices_width env slices in
                (* TODO: check that:
                   - Rule SNQJ: An expression or subexpression which
                     may result in a zero-length bitvector must not be
                     side-effecting.
                *)
                let slices', ses_slices =
                  try_annotate_slices ~loc:(to_pos e) env slices
                in
                let ses = SE.non_concurrent_union ~loc ses_e' ses_slices in
                (T_Bits (w, []) |> here, E_Slice (e'', slices') |> here, ses)
                |: TypingRule.ESlice
            (* End *)
            (* Begin EGetArray *)
            | T_Array (size, ty') -> (
                match slices with
                | [ Slice_Single e_index ] ->
                    let t_index', e_index', ses_index =
                      annotate_expr env e_index
                    in
                    let wanted_t_index = type_of_array_length ~loc:e size in
                    let+ () =
                      check_type_satisfies e env t_index' wanted_t_index
                    in
                    let ses = SE.non_concurrent_union ~loc ses_e' ses_index in
                    (ty', E_GetArray (e'', e_index') |> here, ses)
                    |: TypingRule.EGetArray
                | _ -> conflict e [ integer'; default_t_bits ] t_e')
            (* End *)
            (* Begin ESliceOrEGetArrayError *)
            | _ ->
                conflict e [ integer'; default_t_bits ] t_e'
                |: TypingRule.ESliceOrEGetArrayError
            (* End *)))
    | E_GetField (e1, field_name) -> (
        let t_e1, e2, ses1 = annotate_expr env e1 in
        let t_e2 = Types.make_anonymous env t_e1 in
        let reduced =
          match e1.desc with
          | E_Var x -> should_field_reduce_to_call env x t_e2 field_name
          | _ -> None
        in
        match reduced with
        | Some (name, args) ->
            let name, args, eqs, ty, ses2 =
              annotate_call (to_pos e) env name args [] ST_Getter
            in
            let ty = match ty with Some ty -> ty | None -> assert false in
            (ty, E_Call (name, args, eqs) |> here, ses2)
        | None -> (
            match t_e2.desc with
            | T_Exception fields | T_Record fields -> (
                match List.assoc_opt field_name fields with
                (* Begin EGetBadRecordField *)
                | None ->
                    fatal_from e (Error.BadField (field_name, t_e2))
                    |: TypingRule.EGetBadRecordField
                (* End *)
                (* Begin EGetRecordField *)
                | Some t ->
                    (t, E_GetField (e2, field_name) |> here, ses1)
                    |: TypingRule.EGetRecordField
                    (* End *))
            | T_Bits (_, bitfields) -> (
                match find_bitfield_opt field_name bitfields with
                (* Begin EGetBadBitField *)
                | None ->
                    fatal_from e (Error.BadField (field_name, t_e2))
                    |: TypingRule.EGetBadBitField
                (* End *)
                (* Begin EGetBitField *)
                | Some (BitField_Simple (_field, slices)) ->
                    let e3 = E_Slice (e1, slices) |> here in
                    annotate_expr env e3 |: TypingRule.EGetBitField
                (* End *)
                (* Begin EGetBitFieldNested *)
                | Some (BitField_Nested (_field, slices, bitfields')) ->
                    let e3 = E_Slice (e2, slices) |> here in
                    let t_e4, new_e, ses3 = annotate_expr env e3 in
                    let t_e5 =
                      match t_e4.desc with
                      | T_Bits (width, _bitfields) ->
                          T_Bits (width, bitfields') |> add_pos_from t_e2
                      | _ -> assert false
                    in
                    let ses = SE.non_concurrent_union ~loc ses1 ses3 in
                    (t_e5, new_e, ses) |: TypingRule.EGetBitFieldNested
                (* End *)
                (* Begin EGetBitFieldTyped *)
                | Some (BitField_Type (_field, slices, t)) ->
                    let e3 = E_Slice (e2, slices) |> here in
                    let t_e4, new_e, ses3 = annotate_expr env e3 in
                    let+ () = check_type_satisfies new_e env t_e4 t in
                    let ses = SE.non_concurrent_union ~loc ses1 ses3 in
                    (t, new_e, ses) |: TypingRule.EGetBitFieldTyped
                    (* End *))
            (* Begin EGetTupleItem *)
            | T_Tuple tys ->
                let index =
                  try Scanf.sscanf field_name "item%u" Fun.id
                  with Scanf.Scan_failure _ | Failure _ | End_of_file ->
                    fatal_from e (Error.BadField (field_name, t_e2))
                in
                if 0 <= index && index < List.length tys then
                  ( List.nth tys index,
                    E_GetItem (e2, index) |> add_pos_from e,
                    ses1 )
                else
                  fatal_from e (Error.BadField (field_name, t_e2))
                  |: TypingRule.EGetTupleItem
            (* End *)
            (* Begin EGetBadField *)
            | _ ->
                fatal_from e (Error.BadField (field_name, t_e2))
                |: TypingRule.EGetBadField)
        (* End *))
    | E_GetFields (e_1, fields) -> (
        let t_e', e_2, ses_1 = annotate_expr env e_1 in
        let t_e' = Types.make_anonymous env t_e' in
        let reduced =
          match e_1.desc with
          | E_Var x -> should_fields_reduce_to_call env x t_e' fields
          | _ -> None
        in
        match reduced with
        | Some (name, args) ->
            let name, args, eqs, ty, ses =
              annotate_call (to_pos e) env name args [] ST_Getter
            in
            let ty = match ty with Some ty -> ty | None -> assert false in
            (ty, E_Call (name, args, eqs) |> here, ses)
        | None -> (
            match t_e'.desc with
            | T_Bits (_, bitfields) ->
                let one_field field =
                  match find_bitfields_slices_opt field bitfields with
                  | None -> fatal_from e (Error.BadField (field, t_e'))
                  | Some slices -> slices
                in
                E_Slice (e_1, list_concat_map one_field fields)
                |> here |> annotate_expr env |: TypingRule.EGetBitFields
            | T_Record tfields ->
                let one_field field =
                  match List.assoc_opt field tfields with
                  | None -> fatal_from e (Error.BadField (field, t_e'))
                  | Some t -> get_bitvector_width loc env t
                in
                let widths = List.map one_field fields in
                let w =
                  let wh = List.hd widths and wts = List.tl widths in
                  List.fold_left (width_plus env) wh wts
                in
                (T_Bits (w, []) |> here, E_GetFields (e_2, fields) |> here, ses_1)
            | _ -> conflict e [ default_t_bits ] t_e'))
    (* End *)
    (* Begin EPattern *)
    | E_Pattern (e1, pat) ->
        (*
         Rule ZNDL states that

         The IN operator is equivalent to testing its first operand for
         equality against each value in the (possibly infinite) set denoted
         by the second operand, and taking the logical OR of the result.
         Values denoted by a bitmask_lit comprise all bitvectors that could
         match the bit-mask. It is not an error if any or all of the values
         denoted by the first operand can be statically determined to never
         compare equal with the second operand.

         e IN pattern            is sugar for
             "-"                      ->       TRUE
           | e1=expr                  ->       e == e1
           | bitmask_lit              ->       not yet implemented
           | e1=expr ".." e2=expr     ->       e1 <= e && e <= e2
           | "<=" e1=expr             ->       e <= e1
           | ">=" e1=expr             ->       e >= e1
           |  { p0 , ... pN }         ->       e IN p0 || ... e IN pN
           | !{ p0 , ... pN }         ->       not (e IN p0) && ... e IN pN

         We cannot reduce them here (as otherwise e might be evaluated a
         bad number of times), but we will apply the same typing rules as for
         those desugared expressions.
         *)
        let t_e2, e2, ses = annotate_expr env e1 in
        let pat' = best_effort pat (annotate_pattern e env t_e2) in
        (T_Bool |> here, E_Pattern (e2, pat') |> here, ses)
        |: TypingRule.EPattern
    (* End *)
    | E_GetItem _ -> assert false
    | E_GetArray _ -> assert false |: TypingRule.EGetArray

  and annotate_static_expr env e =
    let t_e, e', ses = annotate_expr env e in
    let+ () = check_statically_evaluable env ses e' in
    (t_e, e')

  and annotate_expr_list ~loc env es =
    let t_es, es', ses_list = List.map (annotate_expr env) es |> list_split3 in
    (t_es, es', SE.big_non_concurrent_union ~loc ses_list)

  and annotate_sef_expr env e =
    let t_es, e', ses = annotate_expr env e in
    let+ () =
      check_true (SE.is_side_effect_free ses) @@ fun () ->
      Error.(fatal_from e (UnpureExpression e))
    in
    (t_es, e')

  let annotate_rexpr env le =
    let e = expr_of_lexpr le in
    let t_e, _e, ses = annotate_expr env e in
    let+ () =
      check_true (SE.is_side_effect_free ses) @@ fun () ->
      Error.(fatal_from le (UnpureExpression e))
    in
    t_e

  let rec annotate_lexpr env le t_e : lexpr * side_effects =
    let () =
      if false then
        Format.eprintf "Typing lexpr: @[%a@] to @[%a@]@." PP.pp_lexpr le
          PP.pp_ty t_e
    in
    let here x = add_pos_from le x in
    match le.desc with
    (* Begin LEDiscard *)
    | LE_Discard -> (le, SE.pure |: TypingRule.LEDiscard)
    (* End *)
    | LE_Var x ->
        (* TODO: Handle setting global var *)
        let ses =
          (* Begin LELocalVar *)
          match IMap.find_opt x env.local.storage_types with
          | Some (ty, LDK_Var) ->
              let+ () = check_type_satisfies le env t_e ty in
              SE.write_local x |: TypingRule.LELocalVar
          (* End *)
          | Some _ -> fatal_from le @@ Error.AssignToImmutable x
          | None -> (
              (* Begin LEGlobalVar *)
              match IMap.find_opt x env.global.storage_types with
              | Some (ty, GDK_Var) ->
                  let+ () = check_type_satisfies le env t_e ty in
                  SE.write_global x |: TypingRule.LEGlobalVar
              (* End *)
              | Some _ -> fatal_from le @@ Error.AssignToImmutable x
              | None -> undefined_identifier le x)
        in
        (le, ses)
    (* Begin LEDestructuring *)
    | LE_Destructuring les ->
        (match t_e.desc with
        | T_Tuple sub_tys ->
            if List.compare_lengths sub_tys les != 0 then
              Error.fatal_from le
                (Error.BadArity
                   ("LEDestructuring", List.length sub_tys, List.length les))
            else
              let les', sess =
                List.map2 (annotate_lexpr env) les sub_tys |> List.split
              in
              let ses = SE.big_non_concurrent_union ~loc:le sess in
              (LE_Destructuring les' |> here, ses)
        | _ -> conflict le [ T_Tuple [] ] t_e)
        |: TypingRule.LEDestructuring
    (* End *)
    | LE_Slice (le1, slices) -> (
        let t_le1, _, _ = expr_of_lexpr le1 |> annotate_expr env in
        let struct_t_le1 = Types.make_anonymous env t_le1 in
        (* Begin LESlice *)
        match struct_t_le1.desc with
        | T_Bits _ ->
            let le2, ses2 = annotate_lexpr env le1 t_le1 in
            let+ () =
             fun () ->
              let width = slices_width env slices |> reduce_expr env in
              let t = T_Bits (width, []) |> here in
              check_type_satisfies le env t_e t ()
            in
            let slices2, slices_ses =
              try_annotate_slices ~loc:(to_pos le) env slices
            in
            let ses = SE.non_concurrent_union ~loc:le ses2 slices_ses in
            let+ () = check_disjoint_slices le env slices2 in
            (LE_Slice (le2, slices2) |> here, ses |: TypingRule.LESlice)
        (* End *)
        (* Begin LESetArray *)
        | T_Array (size, t) -> (
            let le2, ses2 = annotate_lexpr env le1 t_le1 in
            let+ () = check_type_satisfies le2 env t_e t in
            match slices with
            | [ Slice_Single e_index ] ->
                let t_index', e_index', ses_index' =
                  annotate_expr env e_index
                in
                let wanted_t_index = type_of_array_length ~loc:le size in
                let+ () =
                  check_type_satisfies le2 env t_index' wanted_t_index
                in
                let ses = SE.non_concurrent_union ~loc:le ses2 ses_index' in
                ( LE_SetArray (le2, e_index') |> here,
                  ses |: TypingRule.LESetArray )
            (* End *)
            | _ -> invalid_expr (expr_of_lexpr le1))
        | _ -> conflict le1 [ default_t_bits ] t_le1)
    | LE_SetField (le1, field) ->
        (let t_le1 = annotate_rexpr env le1 in
         let t_le1_struct = Types.make_anonymous env t_le1 in
         let le2, ses2 = annotate_lexpr env le1 t_le1 in
         match t_le1_struct.desc with
         | T_Exception fields | T_Record fields ->
             let t =
               match List.assoc_opt field fields with
               (* Begin LESetBadStructuredField *)
               | None ->
                   fatal_from le (Error.BadField (field, t_le1))
                   |: TypingRule.LESetBadStructuredField
               (* End *)
               (* Begin LESetStructuredField *)
               | Some t -> t
             in
             let+ () = check_type_satisfies le env t_e t in
             ( LE_SetField (le2, field) |> here,
               ses2 |: TypingRule.LESetStructuredField )
             (* End *)
         | T_Bits (_, bitfields) ->
             let bits slices bitfields =
               T_Bits (slices_width env slices, bitfields) |> here
             in
             let t, slices =
               match find_bitfield_opt field bitfields with
               (* Begin LESetBadBitField *)
               | None ->
                   fatal_from le1 (Error.BadField (field, t_le1_struct))
                   |: TypingRule.LESetBadBitField
               (* End *)
               (* Begin LESetBitField *)
               | Some (BitField_Simple (_field, slices)) ->
                   (bits slices [], slices) |: TypingRule.LESetBitField
               (* End *)
               (* Begin LESetBitFieldNested *)
               | Some (BitField_Nested (_field, slices, bitfields')) ->
                   (bits slices bitfields', slices)
                   |: TypingRule.LESetBitFieldNested
               (* End *)
               (* Begin LESetBitFieldTyped *)
               | Some (BitField_Type (_field, slices, t)) ->
                   let t' = bits slices [] in
                   let+ () = check_type_satisfies le env t' t in
                   (t, slices) |: TypingRule.LESetBitFieldTyped
               (* End *)
             in
             let+ () = check_type_satisfies le1 env t_e t in
             let le2 = LE_Slice (le1, slices) |> here in
             annotate_lexpr env le2 t_e
         (* Begin LESetBadField *)
         | _ -> conflict le1 [ default_t_bits; T_Record []; T_Exception [] ] t_e)
        |: TypingRule.LESetBadField
        (* End *)
    | LE_SetFields (le', fields, []) -> (
        let t_le' = annotate_rexpr env le' in
        let le', ses = annotate_lexpr env le' t_le' in
        let t_le'_struct = Types.get_structure env t_le' in
        match t_le'_struct.desc with
        | T_Bits (_, bitfields) ->
            let one_field field =
              match find_bitfields_slices_opt field bitfields with
              | None -> fatal_from le (Error.BadField (field, t_le'_struct))
              | Some slices -> slices
            in
            let new_le =
              LE_Slice (le', list_concat_map one_field fields) |> here
            in
            annotate_lexpr env new_le t_e |: TypingRule.LESetFields
        | T_Record tfields ->
            let one_field field (start, slices) =
              match List.assoc_opt field tfields with
              | None -> fatal_from le (Error.BadField (field, t_le'_struct))
              | Some t ->
                  let w = get_bitvector_const_width le env t in
                  (start + w, (start, w) :: slices)
            in
            let length, slices = List.fold_right one_field fields (0, []) in
            let t = T_Bits (expr_of_int length, []) |> here in
            let+ () = check_type_satisfies le env t_e t in
            LE_SetFields (le', fields, slices) |> here, ses
        | _ -> conflict le [ default_t_bits ] t_le')
    | LE_SetArray _ -> assert false
    | LE_SetFields (_, _, _ :: _) -> assert false
    (* Begin LEConcat *)
    | LE_Concat (les, _) ->
        let t_e_eq = annotate_rexpr env le in
        let+ () = check_bits_equal_width' env t_e_eq t_e in
        let bv_length t = get_bitvector_const_width le env t in
        let annotate_one (les, widths, ses, sum) le =
          let t_e1 = annotate_rexpr env le in
          let width = bv_length t_e1 in
          let t_e2 = T_Bits (expr_of_int width, []) |> add_pos_from le in
          let le1, ses2 = annotate_lexpr env le t_e2 in
          let ses' = SE.non_concurrent_union ~loc:le ses ses2 in
          (le1 :: les, width :: widths, ses', sum + width)
        in
        let rev_les, rev_widths, ses, _real_width =
          List.fold_left annotate_one ([], [], SE.pure, 0) les
        in
        (* as the first check, we have _real_width == bv_length t_e *)
        let les1 = List.rev rev_les and widths = List.rev rev_widths in
        ( LE_Concat (les1, Some widths) |> add_pos_from le,
          ses |: TypingRule.LEConcat )
  (* End *)

  let can_be_initialized_with env s t =
    (* Rules:
       - ZCVD: It is illegal for a storage element whose type has the
         structure of the under-constrained integer to be initialized with a
         value whose type has the structure of the under-constrained integer,
         unless the type is omitted from the declaration (and therefore the
         type can be unambiguously inferred) or the initialization expression
         is omitted (and therefore the type is not omitted from the
         declaration).
       - LXQZ: A storage element of type S, where S is
         any type that does not have the structure of
         the under-constrained integer type, may only be
         assigned or initialized with a value of type T
         if T type-satisfies S)
    *)
    let s_struct = Types.get_structure env s in
    match s_struct.desc with
    | T_Int (UnderConstrained _) -> (* TODO *) assert false
    | _ -> Types.type_satisfies env t s

  let check_can_be_initialized_with loc env s t () =
    if can_be_initialized_with env s t then () else conflict loc [ s.desc ] t

  let rec annotate_local_decl_item loc (env : env) ty ldk ldi =
    match ldi with
    (* Begin LDDiscard *)
    | LDI_Discard -> (env, ldi) |: TypingRule.LDDiscard
    (* End *)
    (* Begin LDTyped *)
    | LDI_Typed (ldi', t) ->
        let t' = annotate_type ~loc env t in
        let+ () = check_can_be_initialized_with loc env t' ty in
        let new_env, new_ldi' = annotate_local_decl_item loc env t' ldk ldi' in
        (new_env, LDI_Typed (new_ldi', t')) |: TypingRule.LDTyped
    (* End *)
    (* Begin LDVar *)
    | LDI_Var x ->
        (* Rule LCFD: A local declaration shall not declare an identifier
           which is already in scope at the point of declaration. *)
        let+ () = check_var_not_in_env loc env x in
        let new_env = add_local x ty ldk env in
        (new_env, LDI_Var x) |: TypingRule.LDVar
    (* End *)
    (* Begin LDTuple *)
    | LDI_Tuple ldis ->
        let tys =
          match (Types.make_anonymous env ty).desc with
          | T_Tuple tys when List.compare_lengths tys ldis = 0 -> tys
          | T_Tuple tys ->
              fatal_from loc
                (Error.BadArity
                   ("tuple initialization", List.length tys, List.length ldis))
          | _ -> conflict loc [ T_Tuple [] ] ty
        in
        let new_env, new_ldis =
          List.fold_right2
            (fun ty' ldi' (env', les) ->
              let env', le = annotate_local_decl_item loc env' ty' ldk ldi' in
              (env', le :: les))
            tys ldis (env, [])
        in
        (new_env, LDI_Tuple new_ldis) |: TypingRule.LDTuple
  (* End *)

  let annotate_local_decl_item_uninit loc (env : env) ldi =
    (* Here implicitly ldk=LDK_Var *)
    match ldi with
    | LDI_Discard -> (env, LDI_Discard)
    | LDI_Var _ ->
        fatal_from loc (Error.BadLDI ldi) |: TypingRule.LDUninitialisedVar
    | LDI_Tuple _ldis ->
        fatal_from loc (Error.BadLDI ldi) |: TypingRule.LDUninitialisedTuple
    | LDI_Typed (ldi', t) ->
        let t' = annotate_type ~loc env t in
        let new_env, new_ldi' =
          annotate_local_decl_item loc env t' LDK_Var ldi'
        in
        (new_env, LDI_Typed (new_ldi', t')) |: TypingRule.LDUninitialisedTyped

  let declare_local_constant loc env t_e v ldi =
    let rec add_constants env ldi =
      match ldi with
      | LDI_Discard -> env
      | LDI_Var x -> add_local_constant x v env
      | LDI_Tuple ldis -> List.fold_left add_constants env ldis
      | LDI_Typed (ldi, _ty) -> add_constants env ldi
    in
    let env, ldi = annotate_local_decl_item loc env t_e LDK_Constant ldi in
    (add_constants env ldi, ldi)

  let rec annotate_stmt env s : stmt * StaticEnv.env * side_effects =
    let () =
      if false then
        match s.desc with
        | S_Seq _ -> ()
        | _ -> Format.eprintf "@[<3>Annotating@ @[%a@]@]@." PP.pp_stmt s
    in
    let here x = add_pos_from s x and loc = to_pos s in
    match s.desc with
    (* Begin SPass *)
    | S_Pass -> (s, env, SE.pure) |: TypingRule.SPass
    (* Begin SSeq *)
    | S_Seq (s1, s2) ->
        let new_s1, env1, ses1 = try_annotate_stmt env s1 in
        let new_s2, env2, ses2 = try_annotate_stmt env1 s2 in
        let ses = SE.union ses1 ses2 in
        (S_Seq (new_s1, new_s2) |> here, env2, ses) |: TypingRule.SSeq
    (* Begin SAssign *)
    | S_Assign (le, re, ver) ->
        (let () =
           if false then
             Format.eprintf "@[<3>Annotating assignment@ @[%a@]@]@." PP.pp_stmt
               s
         in
         let reduced = setter_should_reduce_to_call_s env le re in
         match reduced with
         | Some (new_s, ses) -> (new_s, env, ses)
         | None ->
             let t_re, re1, ses1 = annotate_expr env re in
             let env1 =
               match ver with
               | V1 -> env
               | V0 -> (
                   (*
                    * In version V0, variable declaration is optional,
                    * As a result typing will be partial and some
                    * function calls may lack extra parameters.
                    * Fix this by typing first assignments of
                    * undeclared variables as declarations.
                    *)
                   match ASTUtils.lid_of_lexpr le with
                   | None -> env
                   | Some ldi ->
                       let rec undefined = function
                         | LDI_Discard -> true
                         | LDI_Var x -> StaticEnv.is_undefined x env
                         | LDI_Tuple ldis -> List.for_all undefined ldis
                         | LDI_Typed (ldi', _) -> undefined ldi'
                       in
                       if undefined ldi then
                         let () =
                           if false then
                             Format.eprintf
                               "@[<3>Assignment@ @[%a@] as declaration@]@."
                               PP.pp_stmt s
                         in
                         let ldk = LDK_Var in
                         let env2, _ldi =
                           annotate_local_decl_item loc env t_re ldk ldi
                         in
                         env2
                       else env)
             in
             let le1, ses2 = annotate_lexpr env1 le t_re in
             let ses = SE.union ses1 ses2 in
             (S_Assign (le1, re1, ver) |> here, env1, ses))
        |: TypingRule.SAssign
    (* End *)
    (* Begin SCall *)
    | S_Call (name, args, eqs) ->
        let () = assert (List.length eqs == 0) in
        let new_name, new_args, new_eqs, ty, ses =
          annotate_call loc env name args eqs ST_Procedure
        in
        let () = assert (ty = None) in
        (S_Call (new_name, new_args, new_eqs) |> here, env, ses)
        |: TypingRule.SCall
    (* End *)
    | S_Return e_opt ->
        (* Rule NYWH: A return statement appearing in a setter or procedure must
           have no return value expression. *)
        (* Rule PHNZ: A return statement appearing in a getter or function
           requires a return value expression that type-satisfies the return
           type of the subprogram. *)
        (match (env.local.return_type, e_opt) with
        (* Begin SReturnOne *)
        | None, Some _ | Some _, None ->
            fatal_from loc (Error.BadReturnStmt env.local.return_type)
            |: TypingRule.SReturnOne
        (* End *)
        (* Begin SReturnNone *)
        | None, None ->
            (S_Return None |> here, env, SE.pure) |: TypingRule.SReturnNone
        (* End *)
        (* Begin SReturnSome *)
        | Some t, Some e ->
            let t_e', e', ses = annotate_expr env e in
            let () =
              if false then
                Format.eprintf
                  "Can I return %a(of type %a) when return_type = %a?@."
                  PP.pp_expr e PP.pp_ty t_e' PP.pp_ty t
            in
            let+ () = check_type_satisfies s env t_e' t in
            (S_Return (Some e') |> here, env, ses))
        |: TypingRule.SReturnSome
    (* End *)
    (* Begin SCond *)
    | S_Cond (e, s1, s2) ->
        let t_cond, e_cond, ses_cond = annotate_expr env e in
        let+ () = check_type_satisfies e_cond env t_cond boolean in
        let s1', ses1 = try_annotate_block env s1 in
        let s2', ses2 = try_annotate_block env s2 in
        let ses = SE.union ses_cond @@ SE.union ses1 ses2 in
        (S_Cond (e_cond, s1', s2') |> here, env, ses) |: TypingRule.SCond
    (* End *)
    (* Begin SCase *)
    | S_Case (e, cases) ->
        let t_e, e1, ses1 = annotate_expr env e in
        let annotate_case case =
          let { pattern = p0; where = w0; stmt = s0 } = case.desc in
          let p1 = annotate_pattern e1 env t_e p0
          and s1, ses1 = try_annotate_block env s0
          and w1 =
            match w0 with
            | None -> None
            | Some e_w0 ->
                let twe, e_w1, ses2 = (annotate_expr env) e_w0 in
                let+ () = check_structure_boolean e_w0 env twe in
                let+ () =
                  check_true (SE.is_side_effect_free ses2) @@ fun () ->
                  Error.(fatal_from e_w0 (UnpureExpression e_w0))
                in
                Some e_w1
          in
          (add_pos_from_st case { pattern = p1; where = w1; stmt = s1 }, ses1)
        in
        let cases1, sess = List.map annotate_case cases |> List.split in
        let ses = SE.unions (ses1 :: sess) in
        (S_Case (e1, cases1) |> here, env, ses) |: TypingRule.SCase
    (* End *)
    (* Begin SAssert *)
    | S_Assert e ->
        let t_e', e', ses = annotate_expr env e in
        let+ () = check_type_satisfies s env t_e' boolean in
        (S_Assert e' |> here, env, ses) |: TypingRule.SAssert
    (* End *)
    (* Begin SWhile *)
    | S_While (e1, s1) ->
        let t, e2, ses1 = annotate_expr env e1 in
        let+ () = check_type_satisfies e2 env t boolean in
        let s2, ses2 = try_annotate_block env s1 in
        let ses = SE.union ses1 ses2 in
        (S_While (e2, s2) |> here, env, ses) |: TypingRule.SWhile
    (* End *)
    (* Begin SRepeat *)
    | S_Repeat (s1, e1) ->
        let s2, ses2 = try_annotate_block env s1 in
        let t, e2, ses1 = annotate_expr env e1 in
        let+ () = check_type_satisfies e2 env t boolean in
        let ses = SE.union ses1 ses2 in
        (S_Repeat (s2, e2) |> here, env, ses) |: TypingRule.SRepeat
    (* End *)
    (* Begin SFor *)
    | S_For (id, e1, dir, e2, s') ->
        let t1, e1', ses1 = annotate_expr env e1
        and t2, e2', ses2 = annotate_expr env e2 in
        let struct1 = Types.get_well_constrained_structure env t1
        and struct2 = Types.get_well_constrained_structure env t2 in
        let cs =
          match (struct1.desc, struct2.desc) with
          | T_Int UnConstrained, T_Int _ | T_Int _, T_Int UnConstrained ->
              UnConstrained
          | T_Int (WellConstrained cs1), T_Int (WellConstrained cs2) -> (
              let bot_cs, top_cs =
                match dir with Up -> (cs1, cs2) | Down -> (cs2, cs1)
              in
              try
                let bot = min_constraints env bot_cs
                and top = max_constraints env top_cs in
                if bot <= top then
                  WellConstrained
                    [ Constraint_Range (expr_of_z bot, expr_of_z top) ]
                else WellConstrained cs1
              with ConstraintMinMaxTop -> (
                match (bot_cs, top_cs) with
                | [ Constraint_Exact e_bot ], [ Constraint_Exact e_top ] ->
                    WellConstrained [ Constraint_Range (e_bot, e_top) ]
                | _ ->
                    (* TODO: this case is not specified by the LRM. *)
                    UnConstrained))
          | T_Int (UnderConstrained _), T_Int _
          | T_Int _, T_Int (UnderConstrained _) ->
              assert false
          | T_Int _, _ -> conflict s [ integer' ] t2
          | _, _ -> conflict s [ integer' ] t1
          (* only happens in relaxed type-checking mode because of check_structure_integer earlier. *)
        in
        let ty = T_Int cs |> here in
        let s'', ses3 =
          let+ () = check_var_not_in_env s' env id in
          let env' = add_local id ty LDK_Let env in
          try_annotate_block env' s'
        in
        let ses = SE.non_concurrent_union ~loc ses3 (SE.union ses1 ses2) in
        (S_For (id, e1', dir, e2', s'') |> here, env, ses) |: TypingRule.SFor
    (* End *)
    | S_Decl (ldk, ldi, e_opt) -> (
        match (ldk, e_opt) with
        (* Begin SDeclSome *)
        | _, Some e ->
            let t_e, e', ses = annotate_expr env e in
            let env', ldi' =
              if ldk = LDK_Constant then
                let v = reduce_constants env e in
                declare_local_constant loc env t_e v ldi
              else annotate_local_decl_item loc env t_e ldk ldi
            in
            (S_Decl (ldk, ldi', Some e') |> here, env', ses)
            |: TypingRule.SDeclSome
        (* End *)
        (* Begin SDeclNone *)
        | LDK_Var, None ->
            let env', ldi' = annotate_local_decl_item_uninit loc env ldi in
            (S_Decl (LDK_Var, ldi', None) |> here, env', SE.pure)
            |: TypingRule.SDeclNone
        | (LDK_Constant | LDK_Let), None ->
            fatal_from s UnrespectedParserInvariant)
    (* End *)
    (* Begin SThrowSome *)
    | S_Throw (Some (e, _)) ->
        let t_e, e', ses' = annotate_expr env e in
        let ses = SE.SESet.add (Throwing (name_of_type t_e)) ses' in
        let+ () = check_structure_exception s env t_e in
        (S_Throw (Some (e', Some t_e)) |> here, env, ses)
        |: TypingRule.SThrowSome
    (* End *)
    (* Begin SThrowNone *)
    | S_Throw None ->
        let ses = SE.SESet.singleton SideEffect.implicitly_thrown in
        (s, env, ses) |: TypingRule.SThrowNone
    (* End *)
    (* Begin STry *)
    | S_Try (s', catchers, otherwise) ->
        let s'', ses1 = try_annotate_block env s' in
        let (ses1_caught, catchers_ses), catchers' =
          list_fold_left_map (annotate_catcher loc env) (ses1, SE.pure) catchers
        in
        let ses2 = SE.union catchers_ses ses1_caught in
        let otherwise', ses4 =
          match otherwise with
          | None -> (None, ses2)
          | Some block ->
              let block', ses3 = try_annotate_block env block in
              let ses4 = SE.union (SE.remove_throwings ses2) ses3 in
              (Some block', ses4)
        in
        (S_Try (s'', catchers', otherwise') |> here, env, ses4)
        |: TypingRule.STry
    (* End *)
    | S_Print { args; debug } ->
        let _t_args', args', ses = annotate_expr_list ~loc env args in
        (S_Print { args = args'; debug } |> here, env, ses) |: TypingRule.SDebug

  and annotate_catcher loc env (ses_thrower, ses_prev_catchers)
      (name_opt, ty, stmt) =
    let ty' = annotate_type ~loc env ty in
    let+ () = check_structure_exception ty' env ty' in
    let env' =
      match name_opt with
      (* Begin CatcherNone *)
      | None -> env |: TypingRule.CatcherNone
      (* End *)
      (* Begin CatcherSome *)
      | Some name ->
          let+ () = check_var_not_in_env stmt env name in
          add_local name ty' LDK_Let env |: TypingRule.CatcherSome
      (* End *)
    in
    let new_stmt, ses_block = try_annotate_block env' stmt in
    let ses_out, ses_block =
      match ty'.desc with
      | T_Named s ->
          let open SE in
          let ses_out = SESet.remove (Throwing s) ses_thrower
          and ses_block =
            if SESet.mem SideEffect.implicitly_thrown ses_block then
              SESet.remove SideEffect.implicitly_thrown ses_block
              |> SESet.add (Throwing s)
            else ses_block
          in
          (ses_out, ses_block)
      | _ -> assert false
    in
    ((ses_out, SE.union ses_block ses_prev_catchers), (name_opt, ty, new_stmt))

  (* Begin Block *)
  and try_annotate_block env s : stmt * side_effects =
    (*
        See rule JFRD:
           A local identifier declared with var, let or constant
           is in scope from the point immediately after its declaration
           until the end of the immediately enclosing block.

        From that follows that we can discard the environment at the end
        of an enclosing block.
    *)
    best_effort (s, SE.pure) (fun _ ->
        let s, _env, ses = annotate_stmt env s in
        (s, ses))
    |: TypingRule.Block
  (* End *)

  and try_annotate_stmt env s : stmt * env * side_effects =
    best_effort (s, env, SE.pure) (fun _ -> annotate_stmt env s)

  and set_fields_should_reduce_to_call env le x fields e =
    (*
     * Field indices are extracted from the return type
     * of "associated" getter.
     *)
    if not (should_reduce_to_call env x) then None
    else
      let ( let* ) = Option.bind in
      let _, _, callee, _ =
        try Fn.try_find_name le env x []
        with Error.ASLException _ -> assert false
      in
      let* ty = callee.return_type in
      let ty = Types.make_anonymous env ty in
      let* name, args = should_fields_reduce_to_call env x ty fields in
      let name, args, eqs, ret_ty, ses =
        annotate_call (to_pos le) env name (e :: args) [] ST_Setter
      in
      let () = assert (ret_ty = None) in
      Some (S_Call (name, args, eqs) |> add_pos_from le, ses)

  and setter_should_reduce_to_call_s env le e : (stmt * side_effects) option =
    let () =
      if false then
        Format.eprintf "@[<2>setter_..._s@ @[%a@]@ @[%a@]@]@." PP.pp_lexpr le
          PP.pp_expr e
    in
    let here d = add_pos_from le d in
    let s_then = s_then in
    let to_expr = expr_of_lexpr in
    let with_temp old_le sub_le =
      let x = fresh_var "setter_setfield" in
      let le_x = LE_Var x |> here in
      match setter_should_reduce_to_call_s env sub_le (E_Var x |> here) with
      | None -> None
      | Some (s, ses) ->
          let s1 = S_Assign (le_x, to_expr sub_le, V1) |> here
          and s2 = S_Assign (old_le le_x, e, V1) |> here in
          Some (s_then (s_then s1 s2) s, ses)
    in
    match le.desc with
    | LE_Discard -> None
    | LE_SetField ({ desc = LE_Var x; _ }, field) ->
        set_fields_should_reduce_to_call env le x [ field ] e
    | LE_SetField (sub_le, field) ->
        let old_le le' = LE_SetField (le', field) |> here in
        with_temp old_le sub_le
    | LE_SetFields ({ desc = LE_Var x; _ }, fields, _) ->
        set_fields_should_reduce_to_call env le x fields e
    | LE_SetFields (sub_le, fields, slices) ->
        let old_le le' = LE_SetFields (le', fields, slices) |> here in
        with_temp old_le sub_le
    | LE_Slice ({ desc = LE_Var x; _ }, slices) -> (
        let slices = Slice_Single e :: slices in
        match should_slices_reduce_to_call env x slices with
        | None -> None
        | Some args ->
            let name, args, eqs, ret_ty, ses =
              annotate_call (to_pos le) env x args [] ST_Setter
            in
            let () = assert (ret_ty = None) in
            Some (S_Call (name, args, eqs) |> here, ses))
    | LE_Slice (sub_le, slices) ->
        let old_le le' = LE_Slice (le', slices) |> here in
        with_temp old_le sub_le
    | LE_Destructuring _ -> None
    | LE_Var x ->
        if should_reduce_to_call env x then
          let name, args, eqs, ret_ty, ses =
            annotate_call (to_pos le) env x [ e ] [] ST_EmptySetter
          in
          let () = assert (ret_ty = None) in
          Some (S_Call (name, args, eqs) |> here, ses)
        else None
    | LE_Concat (_les, _) -> None
    | LE_SetArray _ -> assert false

  let fold_types_func_sig folder f init =
    let from_args =
      List.fold_left (fun acc (_x, t) -> folder acc t) init f.args
    in
    match f.return_type with None -> from_args | Some t -> folder from_args t

  (** Returns the set of variables that are parameter defining, without the
      ones previously declared in the environment. *)
  let get_undeclared_defining env =
    let rec of_ty acc ty =
      match ty.desc with
      | T_Bits ({ desc = E_Var x; _ }, _) ->
          if StaticEnv.is_undefined x env then ISet.add x acc else acc
      | T_Tuple tys -> List.fold_left of_ty acc tys
      | _ -> acc
    in
    fun f -> fold_types_func_sig of_ty f ISet.empty

  let use_func_sig f =
    fold_types_func_sig (Fun.flip ASTUtils.use_ty) f ISet.empty

  let annotate_func_sig ~loc env (f : AST.func) : env * AST.func =
    let () =
      if false then
        Format.eprintf "Annotating %s in env:@ %a.@." f.name StaticEnv.pp_env
          env
    in
    (* Build typing local environment. *)
    let env1 = { env with local = empty_local } in
    let potential_params = get_undeclared_defining env1 f in
    (* Add explicit parameters *)
    let env2, declared_params =
      let () =
        if false then
          Format.eprintf "Defined potential parameters: %a@." ISet.pp_print
            potential_params
      in
      let folder (env1', acc) (x, ty_opt) =
        let+ () = check_var_not_in_env loc env1' x in
        let+ () =
          check_true (ISet.mem x potential_params) @@ fun () ->
          fatal_from loc (Error.ParameterWithoutDecl x)
        in
        let t =
          match ty_opt with
          | None | Some { desc = T_Int UnConstrained; _ } ->
              Types.under_constrained_ty x
          | Some t -> annotate_type ~loc env1 t
          (* Type should be valid in the env with no param declared. *)
        in
        let+ () = check_constrained_integer ~loc env1 t in
        (add_local x t LDK_Let env1', IMap.add x t acc)
      in
      List.fold_left folder (env1, IMap.empty) f.parameters
    in
    let () = if false then Format.eprintf "Explicit parameters added.@." in
    (* Add arguments as parameters. *)
    let env3, arg_params =
      let used =
        use_func_sig f
        |> ISet.filter (fun s ->
               StaticEnv.is_undefined s env1 && not (IMap.mem s declared_params))
      in
      let () =
        if false then
          Format.eprintf "Undefined used in func sig: %a@." ISet.pp_print used
      in
      let folder (env2', acc) (x, ty) =
        if ISet.mem x used then
          let+ () = check_var_not_in_env loc env2' x in
          let t =
            match ty.desc with
            | T_Int UnConstrained -> Types.under_constrained_ty x
            | _ -> annotate_type ~loc env2 ty
            (* Type sould be valid in env with explicit parameters added, but no implicit parameter from args added. *)
          in
          let+ () = check_constrained_integer ~loc env2 t in
          (add_local x t LDK_Let env2', IMap.add x t acc)
        else (env2', acc)
      in
      List.fold_left folder (env2, IMap.empty) f.args
    in
    let parameters =
      List.append (IMap.bindings declared_params) (IMap.bindings arg_params)
      |> List.map (fun (x, t) -> (x, Some t))
    in
    let env3, parameters =
      (* Do not transliterate, only for v0: promote potential params as params. *)
      if C.check = `TypeCheck then (env3, parameters)
      else
        let folder x (env3', parameters) =
          if var_in_env env3 x then (env3', parameters)
          else
            let t = Types.under_constrained_ty x in
            (add_local x t LDK_Let env3', (x, Some t) :: parameters)
        in
        ISet.fold folder potential_params (env3, parameters)
    in
    let () =
      if false then
        Format.eprintf "@[<hov>Annotating arguments in env:@ %a@]@."
          StaticEnv.pp_env env3
    in
    let () =
      if false then
        let open Format in
        eprintf "@[Parameters identified for func %s:@ @[%a@]@]@." f.name
          (pp_print_list ~pp_sep:pp_print_space (fun f (s, ty_opt) ->
               fprintf f "%s:%a" s (pp_print_option PP.pp_ty) ty_opt))
          parameters
    in
    (* Add arguments. *)
    let env4, args =
      let one_arg env3' (x, ty) =
        if IMap.mem x arg_params then
          let ty' = annotate_type ~loc env2 ty in
          (env3', (x, ty'))
        else
          let () = if false then Format.eprintf "Adding argument %s.@." x in
          let+ () = check_var_not_in_env loc env3' x in
          (* Subtility here: the type should be valid in the env with parameters declared, i.e. [env3]. *)
          let ty' = annotate_type ~loc env3 ty in
          let env3'' = add_local x ty' LDK_Let env3' in
          (env3'', (x, ty'))
      in
      list_fold_left_map one_arg env3 f.args
    in
    (* Check return type. *)
    let env5, return_type =
      match f.return_type with
      | None -> (env4, f.return_type)
      | Some ty ->
          let () =
            if false then
              Format.eprintf "@[<hov>Annotating return-type in env:@ %a@]@."
                StaticEnv.pp_env env3
          in
          (* Subtility here: the type should be valid in the env with parameters declared, i.e. [env3]. *)
          let ty' = annotate_type ~loc env3 ty in
          let return_type = Some ty' in
          let env4' =
            StaticEnv.{ env4 with local = { env4.local with return_type } }
          in
          (env4', return_type)
    in
    (env5, { f with parameters; args; return_type })

  (* Begin Subprogram *)
  let annotate_subprogram (env : env) (f : AST.func) : AST.func * side_effects =
    let () =
      if false then
        Format.eprintf "@[<hov>Annotating body in env:@ %a@]@." StaticEnv.pp_env
          env
    in
    (* Annotate body *)
    let body =
      match f.body with SB_ASL body -> body | SB_Primitive _ -> assert false
    in
    let new_body, ses = try_annotate_block env body in
    ({ f with body = SB_ASL new_body }, ses |: TypingRule.Subprogram)
  (* End *)

  let try_annotate_subprogram env f =
    best_effort (f, SE.pure) (fun _ -> annotate_subprogram env f)

  (******************************************************************************)
  (*                                                                            *)
  (*                           Global env and funcs                             *)
  (*                                                                            *)
  (******************************************************************************)

  let initial_side_effect_func f =
    match f.body with
    | SB_ASL _ -> SE.pure
    | SB_Primitive li ->
        List.map SideEffect.string_specified li |> SE.SESet.of_list

  let check_setter_has_getter ~loc env (func_sig : AST.func) =
    let fail () =
      fatal_from loc (Error.SetterWithoutCorrespondingGetter func_sig)
    in
    let check_true thing = check_true thing fail in
    match func_sig.subprogram_type with
    | ST_Getter | ST_EmptyGetter | ST_Function | ST_Procedure -> ok
    | ST_EmptySetter | ST_Setter ->
        let ret_type, args =
          match func_sig.args with
          | [] -> fatal_from loc Error.UnrespectedParserInvariant
          | (_, ret_type) :: args -> (ret_type, List.map snd args)
        in
        let _, _, func_sig', _ =
          try Fn.find_name loc env func_sig.name args
          with
          | Error.(
              ASLException
                { desc = NoCallCandidate _ | TooManyCallCandidates _; _ })
          ->
            fail ()
        in
        (* TODO conditions on getter's side-effects? *)
        (* Check that func_sig' is a getter *)
        let wanted_st =
          match func_sig.subprogram_type with
          | ST_Setter -> ST_Getter
          | ST_EmptySetter -> ST_EmptyGetter
          | _ -> assert false
        in
        let+ () = check_true (func_sig'.subprogram_type = wanted_st) in
        let+ () =
          (* Check that args match *)
          let () = assert (List.compare_lengths func_sig'.args args = 0) in
          check_true
          @@ List.for_all2
               (fun (_, t1) t2 -> Types.type_equal env t1 t2)
               func_sig'.args args
        in
        let+ () =
          (* Check that return types match. *)
          match func_sig'.return_type with
          | None ->
              assert
                false (* By type-checking invariant: func_sig' is a getter. *)
          | Some t -> check_true @@ Types.type_equal env ret_type t
        in
        ok

  (* Begin DeclareOneFunc *)
  let declare_one_func ~loc (func_sig : func) env =
    let env, name' =
      best_effort (env, func_sig.name) @@ fun _ ->
      Fn.add_new_func loc env func_sig.name func_sig.args
        func_sig.subprogram_type
    in
    let () =
      if false then
        let open Format in
        eprintf
          "@[<hov>Adding function %s to env with@ return-type: %a@ and \
           argtypes:@ %a@."
          name' (pp_print_option PP.pp_ty) func_sig.return_type
          (pp_print_list ~pp_sep:pp_print_space PP.pp_typed_identifier)
          func_sig.args
    in
    let+ () = check_var_not_in_genv loc env name' in
    let+ () = check_setter_has_getter ~loc env func_sig in
    let func_sig = { func_sig with name = name' } in
    let ses = initial_side_effect_func func_sig in
    (add_subprogram name' func_sig ses env, func_sig)

  let annotate_and_declare_func ~loc func env =
    let env, func = annotate_func_sig ~loc env func in
    declare_one_func ~loc func env
  (* End DeclareOneFunc*)

  let add_global_storage loc name keyword env ty =
    if is_global_ignored name then env
    else
      let+ () = check_var_not_in_genv loc env name in
      add_global_storage name ty keyword env

  let declare_const loc name t v env =
    add_global_storage loc name GDK_Constant env t |> add_global_constant name v

  (* Begin DeclareType *)
  let declare_type loc name ty s env =
    let () =
      if false then Format.eprintf "Declaring type %s of %a@." name PP.pp_ty ty
    in
    let+ () = check_var_not_in_genv loc env name in
    let env, ty =
      match s with
      | None -> (env, ty)
      | Some (s, extra_fields) ->
          let+ () =
           fun () ->
            if Types.subtype_satisfies env ty (T_Named s |> add_pos_from loc)
            then ()
            else conflict loc [ T_Named s ] ty
          in
          let ty =
            if extra_fields = [] then ty
            else
              match IMap.find_opt s env.global.declared_types with
              | Some { desc = T_Record fields; _ } ->
                  T_Record (fields @ extra_fields) |> add_pos_from_st ty
              | Some { desc = T_Exception fields; _ } ->
                  T_Exception (fields @ extra_fields) |> add_pos_from_st ty
              | Some _ -> conflict loc [ T_Record []; T_Exception [] ] ty
              | None -> undefined_identifier loc s
          and env = add_subtype name s env in
          (env, ty)
    in
    let ty' = annotate_type ~decl:true ~loc env ty in
    let env = add_type name ty' env in
    let res =
      match ty'.desc with
      | T_Enum ids ->
          let t = T_Named name |> add_pos_from ty in
          let declare_one (env, i) x =
            (declare_const loc x t (L_Int (Z.of_int i)) env, succ i)
          in
          let env, _ = List.fold_left declare_one (env, 0) ids in
          env
      | _ -> env
    in
    let () = if false then Format.eprintf "Declared %s.@." name in
    res
  (* End *)

  let try_add_global_constant name env e =
    try
      let v = reduce_constants env e in
      add_global_constant name v env
    with Error.(ASLException { desc = UnsupportedExpr _; _ }) -> env

  (* Begin DeclareGlobalStorage *)
  let declare_global_storage loc gsd env =
    let () = if false then Format.eprintf "Declaring %s@." gsd.name in
    best_effort (gsd, env) @@ fun _ ->
    let { keyword; initial_value; ty; name } = gsd in
    let+ () = check_var_not_in_genv loc env name in
    let ty' =
      match ty with Some ty -> Some (annotate_type ~loc env ty) | None -> ty
    in
    let initial_value', initial_value_type =
      match initial_value with
      | Some e ->
          let t, e' = annotate_sef_expr env e in
          (Some e', Some t)
      | None -> (None, None)
    in
    let declared_t =
      match (initial_value_type, ty') with
      | Some t, Some ty ->
          let+ () = check_type_satisfies loc env t ty in
          ty
      | None, Some ty -> ty
      | Some t, None -> t
      | None, None -> Error.fatal_from loc UnrespectedParserInvariant
    in
    let env1 = add_global_storage loc name keyword env declared_t in
    let env2 =
      match (keyword, initial_value') with
      | GDK_Constant, Some e -> try_add_global_constant name env1 e
      | (GDK_Constant | GDK_Let), None ->
          Error.fatal_from loc UnrespectedParserInvariant
      | _ -> env1
    in
    ({ gsd with ty = ty'; initial_value = initial_value' }, env2)
  (* End *)

  let rename_primitive loc env (f : AST.func) =
    let name =
      best_effort f.name @@ fun _ ->
      let _, name, _, _ = Fn.find_name loc env f.name (List.map snd f.args) in
      name
    in
    { f with name }

  (******************************************************************************)
  (*                                                                            *)
  (*                                Entry point                                 *)
  (*                                                                            *)
  (******************************************************************************)

  let type_check_decl d (acc, env) =
    let here = add_pos_from_st d and loc = to_pos d in
    let () =
      if false then
        Format.eprintf "@[<v>Typing with %s in env:@ %a@]@." strictness_string
          StaticEnv.pp_env env
      else if false then Format.eprintf "@[Typing %a.@]@." PP.pp_t [ d ]
    in
    match d.desc with
    | D_Func ({ body = SB_ASL _; _ } as f1) ->
        let env1, f2 = annotate_and_declare_func ~loc f1 env in
        let f3, ses = try_annotate_subprogram env1 f2 in
        let env2 = add_subprogram f3.name f3 ses env1 in
        let d = D_Func f3 |> here in
        (d :: acc, env2)
    | D_Func ({ body = SB_Primitive _; _ } as f) ->
        let env, f = annotate_and_declare_func ~loc f env in
        let d = D_Func f |> here in
        (d :: acc, env)
    | D_GlobalStorage gsd ->
        let gsd', env' = declare_global_storage loc gsd env in
        let d' = D_GlobalStorage gsd' |> here in
        (d' :: acc, env')
    | D_TypeDecl (x, ty, s) ->
        let env = declare_type loc x ty s env in
        (d :: acc, env)

  let type_check_mutually_rec ds (acc, env) =
    let () =
      if false then
        let open Format in
        eprintf "@[Type-checking@ mutually@ recursive@ declarations:@ %a@]@."
          (pp_print_list ~pp_sep:pp_print_space pp_print_string)
          (List.map identifier_of_decl ds)
    in
    let env_and_fs =
      List.map
        (fun d ->
          match d.desc with
          | D_Func f ->
              let loc = to_pos d in
              let env', f = annotate_func_sig ~loc env f in
              (env'.local, f, loc)
          | _ ->
              fatal_from d
                (Error.BadRecursiveDecls
                   (List.map ASTUtils.identifier_of_decl ds)))
        ds
    in
    let env_and_fs =
      (* Setters last as they need getters declared. *)
      let others, setters =
        List.partition
          (fun (_, f, _) ->
            match f.subprogram_type with
            | ST_Setter | ST_EmptySetter -> true
            | _ -> false)
          env_and_fs
      in
      List.rev_append setters others
    in
    let genv1, fs =
      list_fold_left_map
        (fun genv (lenv, f, loc) ->
          let env = { global = genv; local = lenv } in
          let env', f = declare_one_func ~loc f env in
          (env'.global, (env'.local, f, loc)))
        env.global env_and_fs
    in
    let genv2, ds =
      list_fold_left_map
        (fun genv (lenv, f, loc) ->
          let here = add_pos_from loc in
          let env' = { local = lenv; global = genv } in
          match f.body with
          | SB_ASL _ ->
              let () =
                if false then Format.eprintf "@[Analysing decl %s.@]@." f.name
              in
              let f, ses = try_annotate_subprogram env' f in
              let env' = add_subprogram f.name f ses env' in
              (env'.global, D_Func f |> here)
          | SB_Primitive _ ->
              (env'.global, D_Func (rename_primitive loc env' f) |> here))
        genv1 fs
    in
    (List.rev_append ds acc, { env with global = genv2 })

  (* Begin Specification *)
  let type_check_ast =
    let fold = function
      | TopoSort.ASTFold.Single d -> type_check_decl d
      | TopoSort.ASTFold.Recursive ds -> type_check_mutually_rec ds
    in
    let fold_topo ast acc = TopoSort.ASTFold.fold fold ast acc in
    fun ast env ->
      let ast_rev, env = fold_topo ast ([], env) in
      (List.rev ast_rev, env)
end
(* End *)

module TypeCheck = Annotate (struct
  let check = `TypeCheck
end)

module TypeInferWarn = Annotate (struct
  let check = `Warn
end)

module TypeInferSilence = Annotate (struct
  let check = `Silence
end)

let type_check_ast = function
  | `TypeCheck -> TypeCheck.type_check_ast
  | `Warn -> TypeInferWarn.type_check_ast
  | `Silence -> TypeInferSilence.type_check_ast
