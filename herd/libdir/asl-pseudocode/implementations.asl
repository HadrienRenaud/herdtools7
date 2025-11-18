/*
 * SPDX-FileCopyrightText: Copyright 2022-2023 Arm Limited and/or its affiliates <open-source-office@arm.com>
 * SPDX-License-Identifier: BSD-3-Clause
 */

/*

    implementations.asl
    -------------------

This file is a list of implementations for use in herd of functions left non-
-implemented in the ARM Reference Manual. We copy the explanations from it.

The ARM Reference Manual is available here:
    https://developer.arm.com/documentation/ddi0602/2025-09/

The first two type declarations have been extracted from the ARM Reference
manual with a regex search.
We suppose that they are enough for our experiments.

The rest of the file are hand-written implementations: they are mostly the
smallest AST that would type-check, but sometimes also call some logic relative
to herd primitives.
The Arm ARM does not contain any implementations for those functions. This file
provide a possible implementation for those functions. For some of those
declarations, the Arm ARM does not provide any implementation.

*/


// =============================================================================

// Non present in shared-pseudocode, they are here because their types are
// needed by shared_pseudocode.

// The types MAIR_EL1_Type, S2PIR_EL2_Type, SCR_Type, and SCTLR_EL1_Type are
// automatically generated from the XML sources released by Arm.

type MAIRType of MAIR_EL1_Type;
type S2PIRType of S2PIR_EL2_Type;
type S1PIRType of S2PIRType;
type SCRType of SCR_Type;
type SCTLRType of SCTLR_EL1_Type;

// =============================================================================

// Initialisation function for system registers.
// By default, registers have a zero value, which is not good enough in our
// case for some system registers.

func _SetUpRegisters (is_vmsa: boolean)
begin
  // Value found on Rasberry 4B, ArmBian
  // uname -a:
  // Linux cheilly 5.4.0-1089-raspi #100-Ubuntu SMP PREEMPT Thu Jun 22 09:59:38 UTC 2023 aarch64 aarch64 aarch64 GNU/Linux
  _TCR_EL1 = '0000000000000000000000000000010011110101100100000111010100010000';

  _SCTLR_EL1 =
    // Bit number 2 -> cache enabled, the rest probably is inaccurate.
    // '0000000000000000000000000000000000000000000000000000000000000100'
    // Value found on Rasberry 4B, Ubuntu 20.04.2
    // uname -a:
    // Linux cheilly 5.4.0-1115-raspi #127-Ubuntu SMP PREEMPT Wed Aug 7 14:38:47 UTC 2024 aarch64 aarch64 aarch64 GNU/Linux
       '0000000000000000000000000000000000000000110001010001100000111101'
    // Another value from the same machine
    // '0000000000000000000000000000000000110000110100000001100110000101'
    ;

  if is_vmsa then
    _SCTLR_EL1.M = '1';
  end;
end;

// =============================================================================

// The various SP registers are not declared in shared_pseudocode.

var _SP_EL0: bits(64);

accessor SP_EL0() <=> v: bits(64)
begin
  getter
    return _SP_EL0;
  end;

  setter
    _SP_EL0 = v;
  end;
end;

var SP_EL0: bits(64);

// =============================================================================

// ConstrainUnpredictableBool()
// ============================
// This is a variant of the ConstrainUnpredictable function where the result is either
// Constraint_TRUE or Constraint_FALSE.

// The ConstrainUnpredictableBool function is used by the ASL code to make
// non-deterministic choices. We thus implement it as a newly generated
// symbolic variable.

func ConstrainUnpredictableBool(which:Unpredictable) => boolean
begin
  return ARBITRARY: boolean;
end;

// =============================================================================

// Not declared in shared_pseudoocode

// We only implement the mininum required features.

func IsFeatureImplemented(f : Feature) => boolean
begin
  case f of
    when FEAT_AA64EL0 => return TRUE;
    otherwise => return FALSE;
  end;
end;

// =============================================================================

// InstructionSynchronizationBarrier()
// ===================================

// Simply a primitive call that will generate the correct effect.

func InstructionSynchronizationBarrier()
begin
  primitive_isb();
end;

// DataMemoryBarrier()
// ===================

// Simply a primitive call that will generate the correct effect.

func DataMemoryBarrier(domain : MBReqDomain, types : MBReqTypes)
begin
  primitive_dmb(domain, types);
end;

// DataSynchronizationBarrier()
// ============================

// Simply a primitive call that will generate the correct effect.
// nXS is not implemented in herd

func DataSynchronizationBarrier
  (domain : MBReqDomain,
   types : MBReqTypes,
   nXS : boolean)
begin
  primitive_dsb(domain, types);
end;

// =============================================================================

// Hint_Branch()
// =============
// Report the hint passed to BranchTo() and BranchToAddr(), for consideration when processing
// the next instruction.

// We do not support any hint.

func Hint_Branch(hint : BranchType)
begin
  return;
end;

// =============================================================================

// SecureOnlyImplementation()
// ==========================
// Returns TRUE if the security state is always Secure for this implementation.

// Is Implementation defined in the Arm ARM.

func SecureOnlyImplementation() => boolean
begin
  return FALSE;
end;

// =============================================================================

// Code used by our interface with herd, in either `physmem-std.asl` or
// `physmem-vmsa.asl`

// Type of underlying accesses (same order as lib/access.mli),
// as recorder un events.

type EventAccess of enumeration {
     REG,
     VIR,
     PHY,
     PTE,
     TLB,
     TAG,
     PHY_PTE,
};

type BRBINF_EL1_Type of bits(64);
type BRBSRC_EL1_Type of bits(64);
type BRBTGT_EL1_Type of bits(64);

readonly func ImpDefBool(s: string) => boolean
begin
  case s of
    when "Secure-only implementation" => return FALSE;
    otherwise =>
      print "Unknown ImpDef: " ++ s;
      assert FALSE;
  end;
end;
