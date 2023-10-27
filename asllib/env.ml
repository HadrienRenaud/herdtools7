(*
 * SPDX-FileCopyrightText: Copyright 2022-2023 Arm Limited and/or its affiliates <open-source-office@arm.com>
 * SPDX-License-Identifier: BSD-3-Clause
 *)

open AST
open ASTUtils

module type RunTimeConf = sig
  type v
  type primitive

  val unroll : int
end

module RunTime (C : RunTimeConf) = struct
  type func = int ref * C.primitive AST.func

  type global = {
    static : StaticEnv.global;
    storage : C.v Storage.t;
    funcs : func IMap.t;
  }

  type int_stack = int list

  type local = {
    storage : C.v Storage.t;
    scope : AST.scope;
    unroll : int_stack;
    declared : identifier list;
  }

  type env = { global : global; local : local }

  let empty_local =
    {
      storage = Storage.empty;
      scope = Scope_Local ("", 0);
      unroll = [];
      declared = [];
    }

  let empty_scoped scope = { empty_local with scope }
  let get_scope env = env.local.scope
  let same_scope env1 env2 = scope_equal env1.local.scope env2.local.scope

  let to_static env =
    let global = env.global.static in
    StaticEnv.{ empty with global }

  (* --------------------------------------------------------------------------*)
  (* Loop unrolling controls. *)

  let set_unroll env unroll = { env with local = { env.local with unroll } }

  (** [tick_push env] is [env] with [C.unroll] pushed on its unrolling stack. *)
  let tick_push env = set_unroll env (C.unroll :: env.local.unroll)

  (** [tick_push_bis env] is [env] with [C.unroll -1] pushed on its unrolling
      stack. *)
  let tick_push_bis env = set_unroll env ((C.unroll - 1) :: env.local.unroll)

  (** [tick_pop env] is [env] with removed the unrolling stack first element. *)
  let tick_pop env =
    match env.local.unroll with
    | [] -> assert false
    | _ :: unroll -> set_unroll env unroll

  (** [tick_decr env] decrements the unrolling stack of env and returns
      wheather it has poped something or not. *)
  let tick_decr env =
    match env.local.unroll with
    | [] -> assert false
    | x :: xs ->
        let x = x - 1 in
        if x <= 0 then (true, set_unroll env xs)
        else (false, set_unroll env (x :: xs))

  (* --------------------------------------------------------------------------*)
  (* Retrieval utils *)

  type 'a env_result = Local of 'a | Global of 'a | NotFound

  let find x env =
    try Local (Storage.find x env.local.storage)
    with Not_found -> (
      try Global (Storage.find x env.global.storage)
      with Not_found -> NotFound)

  let mem x env =
    Storage.mem x env.local.storage || Storage.mem x env.global.storage

  (* --------------------------------------------------------------------------*)
  (* Assignments utils *)

  let declare_local x v env =
    {
      env with
      local =
        {
          env.local with
          storage = Storage.add x v env.local.storage;
          declared = x :: env.local.declared;
        };
    }

  let assign_local x v env =
    {
      env with
      local = { env.local with storage = Storage.assign x v env.local.storage };
    }

  let declare_global x v env =
    {
      env with
      global = { env.global with storage = Storage.add x v env.global.storage };
    }

  let assign_global x v env =
    {
      env with
      global =
        { env.global with storage = Storage.assign x v env.global.storage };
    }

  let remove_local x env =
    {
      env with
      local =
        {
          env.local with
          storage = Storage.remove x env.local.storage;
          declared =
            List.filter (fun s -> not (String.equal s x)) env.local.declared;
        };
    }

  let assign x v env =
    try Local (assign_local x v env)
    with Not_found -> (
      try Global (assign_global x v env) with Not_found -> NotFound)

  (* --------------------------------------------------------------------------*)
  (* Scope swapping utils *)

  let push_scope env = { env with local = { env.local with declared = [] } }

  let pop_scope parent child =
    let local_storage =
      Storage.patch_mem ~t_env:parent.local.storage ~t_mem:child.local.storage
        child.local.declared
    in
    { child with local = { parent.local with storage = local_storage } }
end
