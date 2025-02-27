(****************************************************************************)
(*                           the diy toolsuite                              *)
(*                                                                          *)
(* Jade Alglave, University College London, UK.                             *)
(* Luc Maranget, INRIA Paris-Rocquencourt, France.                          *)
(*                                                                          *)
(* Copyright 2017-present Institut National de Recherche en Informatique et *)
(* en Automatique and the authors. All rights reserved.                     *)
(*                                                                          *)
(* This software is governed by the CeCILL-B license under French law and   *)
(* abiding by the rules of distribution of free software. You can use,      *)
(* modify and/ or redistribute the software under the terms of the CeCILL-B *)
(* license as circulated by CEA, CNRS and INRIA at the following URL        *)
(* "http://www.cecill.info". We also give a copy in LICENSE.txt.            *)
(****************************************************************************)

open Printf

module type Config = sig
(* Names *)
  val check_name : string -> bool
  val check_rename : string -> string option
  val check_kind : string -> ConstrGen.kind option
  val check_cond : string -> string option
(* Parameters *)
  val verbose : int
  val hexa : bool
  val litmus : string
  val is_out : bool
  val size : int
  val runs : int
  val avail : int option
  val stride : KStride.t
  val barrier : KBarrier.t
  val affinity : KAffinity.t
  val rcu : Rcu.t
  val expedited : bool
  val tarname : string
  val pad : int
  val ccopts : string list
  val sharelocks : int option
  val delay : int
  val carch : Archs.System.t
  val variant : Variant_litmus.t -> bool
end

module Top(O:Config)(Tar:Tar.S) = struct

  module OX = struct
    let debuglexer = O.verbose > 2
    let debug = debuglexer
    include O
    include Template.DefaultConfig
    let mode = Mode.Std
    let asmcommentaslabel = false
  end

  module H = LitmusUtils.Hash(O)
  module W = Warn.Make(O)

  let exit_not_compiled fname =
    W.warn "%s Test not compiled" (Pos.str_pos0 fname) ;
    raise Misc.Exit

  let wrap_allocate have_rcu allocate =
    fun fname parsed ->
      let p = allocate parsed in
      let ok = match O.rcu with
      | Rcu.Yes -> true
          | Rcu.No -> not (have_rcu p.MiscParser.prog)
          | Rcu.Only -> have_rcu p.MiscParser.prog in
      if ok then p
      else exit_not_compiled fname


  module Utils(A:Arch_litmus.Base)(MemType:MemoryType.S)
      (Lang:Language.S with type t = A.Out.t)
      (Pseudo:PseudoAbstract.S with type ins = A.instruction) =
    struct
      module T = Test_litmus.Make(O)(A)(Pseudo)
      module O = struct
        include O
        let sysarch = Archs.get_sysarch A.arch O.carch
      end
      let dump source doc compiled =
        let outname = Tar.outname source in
        try
          Misc.output_protect
            (fun chan ->
              let module Out =
                Indent.Make(struct let hexa = O.hexa let out = chan end) in
              let module S = KSkel.Make(O)(Pseudo)(A)(MemType)(T)(Out)(Lang) in
              S.dump doc compiled)
            outname
        with e ->
          begin try Sys.remove outname with _ -> () end ;
          raise e

      let compile parse count_procs  compile allocate
          fname (hash_env,id) chan splitted =
        let parsed = parse chan splitted in
        close_in chan ;

        let avail_ok = match O.avail with
        | None -> true
        | Some a -> count_procs parsed.MiscParser.prog <= a in

        if avail_ok then begin
          let doc = splitted.Splitter.name in
          let tname = doc.Name.name in
          let hash = H.mk_hash_info fname parsed.MiscParser.info in
          let hash_ok = H.hash_ok hash_env tname hash in
          if hash_ok then begin
            let hash_env = StringMap.add tname hash hash_env in
            let base = sprintf "%s%0*i" O.litmus O.pad id in
            let src = sprintf "%s.c" base in
            let parsed = allocate parsed in
            let compiled =  compile doc parsed in
            dump src doc compiled ;
            (base,tname),(hash_env,id+1)
          end else begin
            exit_not_compiled fname
          end
        end else begin
          exit_not_compiled fname
        end
    end

  module MakeLISA =
    struct
      module LISAInstr =
        Instr.No(struct type instr = BellBase.instruction end)
      module V = Int64Constant.Make(LISAInstr)
      module A = LISAArch_litmus.Make(V)
      module LexParse = struct
        type instruction = A.parsedPseudo
        type token = LISAParser.token
        module Lexer = BellLexer.Make(OX)
        let lexer = Lexer.token
        let parser = LISAParser.main
      end
      module LISAComp = LISACompile.Make(V)
      module Pseudo = LitmusUtils.Pseudo(A)
      module Lang = LISALang.Make(V)
      module Utils = Utils(A)(MemoryType.No)(Lang)(Pseudo)
      module P = GenParser.Make(OX)(A)(LexParse)
      module T = Utils.T

      module Alloc =
        SymbReg.Make
          (struct
            include A
            type v = V.v
            let maybevToV = A.maybevToV
            type global = Global_litmus.t
            let maybevToGlobal = A.tr_global
          end)

      let allocate fname src =
        let have_rcu p =
          List.exists
            (fun (_,code) ->
              List.exists
                (fun p ->
                  A.pseudo_fold
                    (fun r ins -> match ins with
                    | A.Pfence
                        (A.Fence
                           ([("sync"|"sync_expedited")],_))
                      -> true
                    | _ -> r)
                    false p)
                code)
            p in
        wrap_allocate have_rcu Alloc.allocate_regs fname src


      module Comp = Compile.Make (Compile.Default)(A)(T)(LISAComp)

      let compile fname =
        Utils.compile
          P.parse MiscParser.count_procs Comp.compile (allocate fname)
          fname
    end


  module MakeC = struct

    module A = CArch_litmus.Make(OX)
    module LexParse = struct
      type token = CParser.token
      module CL = CLexer.Make(struct let debug = false end)
      let lexer = CL.token false
      let parser lexer buf = fst (CParser.shallow_main lexer buf)
    end
    module Pseudo =
      struct
        type ins = CBase.instruction
        include DumpCAst
        let code_exists _ _ = false
        let exported_labels_code _ = Label.Full.Set.empty
        let from_labels _ _ = []
        let all_labels _ = []
      end
    module Lang = CLang.Make(CLang.DefaultConfig)
        (struct
          let verbose = O.verbose
          let noinline = false
          let simple = true
        end)
    module Utils = Utils(A)(MemoryType.X86_64)(Lang)(Pseudo)
    module T = Utils.T
    module P = CGenParser_litmus.Make(OX)(Pseudo)(A)(LexParse)
    module CComp =
      CCompile_litmus.Make
        (struct
          include Compile.Default
          let kernel = true
          let rcu =
            O.expedited &&
            (match  O.rcu with
            | Rcu.Yes | Rcu.Only -> true
            | Rcu.No -> false)
        end)(T)
    module Alloc = CSymbReg.Make(A)

    let have_rcu =
      fun p ->
        List.exists
          (fun code -> match code with
          | CAst.Test {CAst.body=body; _}
          | CAst.Global body -> LexHaveRcu.search body)
          p

    let allocate = wrap_allocate have_rcu Alloc.allocate_regs

    let compile fname =
      Utils.compile P.parse A.count_procs CComp.compile (allocate fname)
        fname

  end

  module MakeX86_64 = struct
    module V = Int64Constant.Make(X86_64Base.Instr)
    module OC = struct
      include OX
      let asmcomment = None
    end
    module A = X86_64Arch_litmus.Make(OC)(V)

    module LexParse = struct
      type instruction = A.pseudo
      type token = X86_64Parser.token
      module Lexer = X86_64Lexer.Make(OX)
      let lexer = Lexer.token
      let parser = MiscParser.mach2generic X86_64Parser.main
    end

    module XXXComp =
      X86_64Compile_litmus.Make
        (struct let sse = false let reason = "klitmus" end)
        (V)(OC)

    module Pseudo = LitmusUtils.Pseudo(A)

    module ASMConfig = struct
      let hexa = O.hexa
      let memory = Memory.Direct
      let cautious = false
      let mode = Mode.Std
      let asmcommentaslabel = false
      let noinline = false
      let variant _ = false
    end

    module ALang = struct
      include A.I
      module RegSet = A.Out.RegSet
      module RegMap = A.Out.RegMap
    end

    module Lang = ASMLang.Make(ASMConfig)(ALang)(A.Out)(A)

    module Utils = Utils(A)(MemoryType.X86_64)(Lang)(Pseudo)

    module P = GenParser.Make(OX)(A)(LexParse)

    module Comp = Compile.Make(Compile.Default)(A)(Utils.T)(XXXComp)

    module AllocArch = struct
        include A
        type v = A.V.v
        let maybevToV = A.maybevToV
        type global = Global_litmus.t
        let maybevToGlobal = A.tr_global
      end

    module Alloc = SymbReg.Make(AllocArch)

    let compile fname =
      Utils.compile P.parse List.length Comp.compile Alloc.allocate_regs
        fname
  end

  module SP = Splitter.Make(OX)

  let from_chan hash_env fname chan =
    let { Splitter.arch=arch ; _ } as splitted =
      SP.split fname chan in
    let tname = splitted.Splitter.name.Name.name in
    if O.check_name tname then begin
(* Then call appropriate compiler, depending upon arch *)
      match arch with
      | `LISA ->
          MakeLISA.compile fname hash_env chan splitted
      | `C ->
         MakeC.compile fname hash_env chan splitted
      | `X86_64 ->
         MakeX86_64.compile fname hash_env chan splitted
      | _ ->
          W.warn "%s, cannot handle arch %s" (Pos.str_pos0 fname)
            (Archs.pp arch) ;
          raise Misc.Exit
    end else raise Misc.Exit

  let from_file fname (srcs,hash_env as k) =
    try
      let src,hash_env =
        Misc.input_protect (from_chan hash_env fname) fname in
      src::srcs,hash_env
    with
    | Misc.Exit -> k
    | Misc.Fatal msg
    | Misc.UserError msg ->
        eprintf "%a %s\n%!" Pos.pp_pos0 fname msg ;
        k
    | e ->
        let msg = sprintf "exception %s"  (Printexc.to_string e) in
        eprintf "%a %s\n%!" Pos.pp_pos0 fname msg ;
        raise e (* asserrt false *)

  let dump_makefile srcs =
    let fname = Tar.outname "Makefile" in
    Misc.output_protect
      (fun chan ->
        let module Out =
          Indent.Make(struct let hexa = O.hexa let out = chan end) in
        Out.f "ccflags-y += %s"
          (String.concat " "
             ("-std=gnu99"::"-Wno-declaration-after-statement"::O.ccopts)) ;
        List.iter (fun (src,_) -> Out.f "obj-m += %s.o" src) srcs ;
        Out.o "" ;
        Out.o "all:" ;
        Out.o "\t$(MAKE) -C /lib/modules/$(shell uname -r)/build/ M=$(PWD) modules" ;
        Out.o "" ;
        Out.o "clean:" ;
        Out.o "\t$(MAKE) -C /lib/modules/$(shell uname -r)/build/ M=$(PWD) clean" ;
        ())
      fname

  let dump_run srcs =
    let fname = Tar.outname "run.sh" in
    Misc.output_protect
      (fun chan ->
        let module Out =
          Indent.Make(struct let hexa = O.hexa let out = chan end) in
        Out.f "LOCKDIR=/tmp/k%s-locked" O.litmus ;
        Out.o "trap \"rmdir $LOCKDIR 2>/dev/null; exit\" INT TERM" ;
        Out.o "if ! mkdir $LOCKDIR 2>/dev/null; then" ;
        Out.o "  echo \"Already running, locked by $LOCKDIR\"" ;
        Out.o "  exit 1" ;
        Out.o "fi" ;
        Out.o "OPT=\"$*\"" ;
        Out.o "date" ;
        Out.f "echo Compilation command: \"%s\""
          (String.concat " " (Array.to_list Sys.argv)) ;
        Out.o "echo \"OPT=$OPT\"" ;
        Out.o "echo \"uname -r=$(uname -r)\"" ;
        Out.o "echo" ;
        Out.o "" ;
        Out.o "zyva () {" ;
        Out.oi "name=$1" ;
        Out.oi "ko=$2" ;
        Out.oi "if test -f  $ko" ;
        Out.oi "then" ;
        Out.oii "insmod $ko $OPT" ;
        Out.fii "cat /proc/%s" O.litmus;
        Out.oii "rmmod $ko" ;
        Out.oi "fi" ;
        Out.o "}" ;
        Out.o "" ;
        List.iter
          (fun (src,name) ->
            Out.f "zyva %S %s.ko" name src)
          srcs ;
        Out.o "rmdir $LOCKDIR 2>/dev/null" ;
        Out.o "date" ;
        ())
      fname

  let dump_readme _sources =
    let fname = Tar.outname "README.txt" in
    Misc.output_protect
      (fun chan ->
        let pl fmt = ksprintf (fun s -> fprintf chan "%s\n" s) fmt in
        pl "Kernel modules produced by klitmus7" ;
        pl "" ;
        pl "REQUIREMEMTS" ;
        pl "  - kernel headers for compiling modules." ;
        pl "  - commands insmod and rmmod for installing and removing kernel modules." ;
        pl "" ;
        pl "COMPILING" ;
        pl "  Once kernel headers are installed, just type 'make'" ;
        pl "" ;
        pl "RUNNING" ;
        pl "  Run script 'run.sh' as root, e.g. as 'sudo sh run.sh'" ;
        pl "  Some parameters can be passed to the script by adding" ;
        pl "  key=value command line arguments." ;
        pl "  Main arguments are as follows:" ;
        pl "    * size=<n>   Tests operate on arrays of size <n>." ;
        pl "    * nruns=<n>  And are repeated <n> times." ;
        pl "    * stride=<n> Arrays are scanned with stride <n>." ;
        pl "    * avail=<n>  Number of cores are devoted to tests." ;
        pl "" ;
        pl "  If <avail> is the special value zero or exceeds <a>, the number of actually online cores," ;
        pl "  then tests will occupy <a> cores." ;
        pl "" ;
        pl "  By default the script runs as if called as:" ;
        pl "    sudo sh run.sh size=%i nruns=%i stride=%s avail=%i\n"
          O.size O.runs
          (let open KStride in
          match O.stride with
          | St i -> sprintf "%i" i
          | Adapt -> "adapt")
          (match O.avail with None -> 0 | Some i -> i) ;
        ())
      fname

  let from_files args =
    let sources,_ =
      Misc.fold_argv_or_stdin from_file args ([],(StringMap.empty,0))in
    let sources = List.rev sources in
    dump_makefile sources ;
    dump_run sources ;
    dump_readme sources ;
    Tar.tar () ;
    ()

end
