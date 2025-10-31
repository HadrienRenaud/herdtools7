# Herd/ASL interface description

## Our implementations

### Standard mode

_i.e. file `implementations.asl`

Taken from the Arm ARM, to be removed by PR #1521:
- `Features`
- `SCTLR_Type`
- `HPFAR_EL2_Type`
- `HPFAR_EL2`

Initialisation value for a few registers:
- `SCTLR_EL1`
- ``

#### ConstrainUnpredictableBool()

Our implementation:
```
func ConstrainUnpredictableBool(which:Unpredictable) => boolean
begin
  return ARBITRARY: boolean;
end;
```

#### IsFeatureImplemented()

Our implementation:
```
func IsFeatureImplemented(f : Feature) => boolean
begin
  return FALSE;
end;
```

This implementation is probably a bit errouneous, as some features might be
implemented in herd. For example, `FEAT_LSE` is needed to implement `CAS`
according to the [Arm
ARM](https://developer.arm.com/documentation/ddi0602/2025-09/Base-Instructions/CAS--CASA--CASAL--CASL--Compare-and-swap-word-or-doubleword-in-memory-?lang=en).
However, we don't need to say we implement it because it is only tested once in
the whole `shared_pseudocode.asl`, in a function we don't use
(`TakeGPCException`).

#### HaveAArch32() and HaveAArch64()

Our implementation:

```
func HaveAArch32() => boolean
begin
  return FALSE;
end;

func HaveAArch64() => boolean
begin
  return TRUE;
end;
```

In this context, we are always in 64-bits mode and never in 32-bits mode.

#### HaveEL()

Our implementation:
```
func HaveEL(el: bits(2)) => boolean
begin
    if el IN {EL1,EL0} then
        return TRUE;                             // EL1 and EL0 must exist
    else
        return FALSE; // boolean IMPLEMENTATION_DEFINED;
    end;
end;
```

We only support exception levels 0 and 1.

#### _R

Just a trick to plug our read and write register primitives.

```
accessor _R (n : integer) <=> value: bits(64)
begin
  getter
    return read_register(n);
  end;

  setter
    write_register(n, value);
  end;
end;
```

#### Exclusives

```
// ClearExclusiveByAddress()
// =========================
// Clear the global Exclusives monitors for all PEs EXCEPT processorid if they
// record any part of the physical address region of size bytes starting at paddress.
// It is IMPLEMENTATION DEFINED whether the global Exclusives monitor for processorid
// is also cleared if it records any part of the address region.

func ClearExclusiveByAddress(paddress : FullAddress, processorid : integer, size : integer)
begin
  pass;
end;
```

#### Barriers

```
func InstructionSynchronizationBarrier()
begin
  primitive_isb();
end;

func DataMemoryBarrier(domain : MBReqDomain, types : MBReqTypes)
begin
  primitive_dmb(domain, types);
end;

func DataSynchronizationBarrier
  (domain : MBReqDomain,
   types : MBReqTypes,
   nXS : boolean)
begin
  assert !nXS; // nXS is not supported by herd
  primitive_dsb(domain, types);
end;
```

Those are directly interpreted by the herd primitives, which simply creates the
correct effects, depending on the arguments passed.

#### SecureOnlyImplementation

In the Arm ARM, it is currently a IMPDEF.
```
// SecureOnlyImplementation()
// ==========================
// Returns TRUE if the security state is always Secure for this implementation.

boolean SecureOnlyImplementation()
    return boolean IMPLEMENTATION_DEFINED "Secure-only implementation";
```

```
func SecureOnlyImplementation() => boolean
begin
  return FALSE;
end;
```

## Our implementation of memory prmitives

### Standard mode

#### PhysMemWrite

We simply call the primitive to generate the corresponding memory event.
We always return an status without fault. This is the matching semantics for
herd7.

```
func PhysMemWrite{N}(
  desc:AddressDescriptor,
  accdesc:AccessDescriptor,
  value:bits(N*8)
) => PhysMemRetStatus
begin
  write_memory_gen{N*8}(desc.vaddress,value,accdesc,VIR);
  return PhysMemRetStatus {
    statuscode = Fault_None,
    extflag = '0',
    merrorstate = ErrorState_CE,  // ??
    store64bstatus = Zeros{64}
  };
end;
```

### PhysMemRead

We get the value read from a primitive. As for PhysMemWrite, the retrurn status
is never faulty.
Our implementation:
```
func PhysMemRead{N} (
  desc:AddressDescriptor,
  accdesc:AccessDescriptor
) => (PhysMemRetStatus, bits(N*8))
begin
  let value = read_memory_gen{N*8}(desc.vaddress,accdesc,VIR);
  let ret_status = PhysMemRetStatus {
    statuscode = Fault_None,
    extflag = '0',
    merrorstate = ErrorState_CE,  // ??
    store64bstatus = Zeros{64}
  };
  return (ret_status, value);
end;
```

## Our handling of exclusives

TODO

## Our patches

### Alignment

Here we suppose that addresses are correctly aligned.

We need this simplification because the `shared_pseudocode.asl` is doing some
bitvector arithmetic that is not supported by our current interpreter on
symbolic addresses.

Arm ARM's implementation:
```
boolean IsAligned(bits(N) x, integer y)
    return x == Align(x, y);
```

Our implementation:
```
func IsAligned{N}(x : bits(N), y:integer) => boolean
begin
  return TRUE;
end;
```

### BigEndian

We only use BigEndian, so we're overriding the settings.

```
func BigEndian(acctype: AccessType) => boolean
begin
  return FALSE;
end;
```

### TranslateAddress (only for non-VMSA mode)

We disable translation.

As for the rest of herd, we have constant memory attributes, defined in
`NormalWBISHMemAttr()`. We simply construct an address descriptor around the
input address and the wanted memory attributes.

```
func NormalWBISHMemAttr() => MemoryAttributes
begin
  return MemoryAttributes {
    memtype = MemType_Normal,
    inner = MemAttrHints {
      attrs = MemAttr_WB,
      hints = MemHint_No, // ??
      transient = FALSE // Only applies to cacheable memory
    },
    outer = MemAttrHints {
      attrs = MemAttr_WB,
      hints = MemHint_No, // ??
      transient = FALSE // Only applies to cacheable memory
    },
    shareability = Shareability_ISH,
    tags = MemTag_Untagged, // ??
    device = DeviceType_GRE, // Not relevant for Normal
    notagaccess = TRUE, // Not used in shared_pseudocode
    xs = '0' // If I understand correctly WalkMemAttrs
  };
end;

func AArch64_TranslateAddress(address:bits(64), accdesc:AccessDescriptor, aligned:boolean, size:integer) => AddressDescriptor
begin
  var full_addr : FullAddress;
  return CreateAddressDescriptor(address, full_addr, NormalWBISHMemAttr(), accdesc);
end;
```

The Arm ARM's implementation, does an address translation, which we don't
support here.

### PSTATE

We simply change it from a record to a collection.

### PointerCheckAtEL()

We disable checked pointer arithmetic, because it's not supported by symbolic
memory addresses.

Our implementation:
```
func PointerCheckAtEL(el: bits(el), result: bits(64), base: bits(64),
                      cptm_detected: boolean) => bits(64)
begin
  return result;
end;
```

### BranchAddr

Another pointer arithmetic that we disable because it's not supported by
symbolic memory addresses.

Our implementation:
```
func AArch64_BranchAddr (vaddress:bits(64), el:bits(2)) => bits(64)
begin
  return vaddress;
end;
```

### MemSingleGranule

Arm ARM's implementation:

```
// MemSingleGranule()
// ==================
// When FEAT_LSE2 is implemented, for some memory accesses if all bytes
// of the accesses are within 16-byte quantity aligned to 16-bytes and
// satisfy additional requirements - then the access is guaranteed to
// be single copy atomic.
// However, when the accesses do not all lie within such a boundary, it
// is CONSTRAINED UNPREDICTABLE if the access is single copy atomic.
// In the pseudocode, this CONSTRAINED UNPREDICTABLE aspect is modeled via
// MemSingleGranule() which is IMPLEMENTATION DEFINED and, is at least 16 bytes
// and at most 4096 bytes.
// This is a limitation of the pseudocode.

integer MemSingleGranule()
    size = integer IMPLEMENTATION_DEFINED "Aligned quantity for atomic access";
    // access is assumed to be within 4096 byte aligned quantity to
    // avoid multiple translations for a single copy atomic access.
    assert (size >= 16) && (size <= 4096);
    return size;
```

Our Implementation:
```
func MemSingleGranule() => integer
  begin
    let size = 32;
    // access is assumed to be within 4096 byte aligned quantity to
    // avoid multiple translations for a single copy atomic access.
    assert (size >= 16) && (size <= 4096);
    return size;
  end;
```

### CheckOriginalSVEEnabled()

Arm ARM has a long and complex check of various system registers at different
ELs. We simply enable it.

```
func CheckOriginalSVEEnabled()
begin
  return;
end;
```

### BranchNotTaken()

We add the add to `PC`, that is missing from this instruction. Usually we add
it automatically, but for instructions that _could_ branch, we don't do it
automatically, so it needs to be set if no assignment to `PC` is made.

Arm ARM's implementation:

```
BranchNotTaken(BranchType branchtype, boolean branch_conditional)
    constant boolean branchtaken = FALSE;
    if IsFeatureImplemented(FEAT_SPE) then
        SPEBranch(bits(64) UNKNOWN, branchtype, branch_conditional, branchtaken);
    return;
```

Our implementation:
```
func BranchNotTaken(branchtype:BranchType, branch_conditional:boolean)
begin
    _PC() = _PC()+4;
   let branchtaken = FALSE;
   if IsFeatureImplemented(FEAT_SPE) then
     SPEBranch{64}
       (ARBITRARY:bits(64), branchtype, branch_conditional, branchtaken);
    end;
    return;
end;
```

