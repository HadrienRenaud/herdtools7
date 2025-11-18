/*
 * SPDX-FileCopyrightText: Copyright 2022-2023 Arm Limited and/or its affiliates <open-source-office@arm.com>
 * SPDX-License-Identifier: BSD-3-Clause
 */

/*

    implementations-vmsa.asl
    ------------------------

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

Those declarations are made to be included with the rest of implementations in
implementations.asl, in the case where stage one translation is activated.
*/


// SynchronizeContext()
// ====================
// Context Synchronization event, includes Instruction Fetch Barrier effect

func SynchronizeContext()
begin
 return;
end;

// ThisInstrLength()
// =================

func ThisInstrLength() => integer
begin
  return 32;
end;

// IsPhysicalSErrorPending()
// =========================
// Returns TRUE if a physical SError interrupt is pending.

func IsPhysicalSErrorPending() => boolean
begin
  return FALSE;
end;

// PendSErrorInterrupt()
// =====================
// Pend the SError Interrupt.

func PendSErrorInterrupt(fault:FaultRecord)
begin
  return;
end;

// AArch64.PAMax()
// ===============
// Returns the IMPLEMENTATION DEFINED maximum number of bits capable of representing
// physical address for this processor
// Let us define it.

func AArch64_PAMax() => integer
begin
    return 48;
end;

// AArch64.S1TxSZFaults()
// ======================
// Detect whether configuration of stage 1 TxSZ field generates a fault
// Luc: Override: does not occur, never.

func AArch64_S1TxSZFaults (regime:Regime,walkparams:S1TTWParams) => boolean
begin
  return FALSE;
end;

// ExternalInvasiveDebugEnabled()
// ==============================
// The definition of this function is IMPLEMENTATION DEFINED.
// In the recommended interface, this function returns the state of the DBGEN signal.

func ExternalInvasiveDebugEnabled() => boolean
begin
    return FALSE;
end;

