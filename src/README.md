# Overview of the CBQN source

## clangd

Run `build/build clangd` to generate a `compile_commands.json` file which clangd will use to resolve the flags CBQN expects. Other `build/build` flags will also be respected, e.g. `build/build replxx singeli native clangd` will result in clangd assuming the `SINGELI` and `USE_REPLXX` macros are defined, and will resolve generated Singeli sources to ones `build/build replxx singeli native` generates (along with everything else the configurations change).  
(you may need to restart clangd or your editor after a modified `compile_commands.json`)

## Conventions

Functions starting with `m_` makes a new object (some NaN-boxed, some heap-allocated).  
Functions starting with `q_` are queries/predicates, and return a boolean.  
Functions ending with `R` are either supposed to be called rarely, or the caller expects that a part of it happens rarely.  
Functions ending with `N` are non-inlined versions of another function.  
Functions ending with `F` are infrequently needed fallback parts of a function.  
Functions ending with `P` (or sometimes containing `p` or `P` or `v` or `V`) take a pointer argument (as opposed to a (NaN-boxed) `B`).  
Functions ending with `U` return (or take) a non-owned object (`U` = "unincremented").  
Functions ending with `_c1` are monadic implementations, `_c2` are dyadic (see [builtin implementations](#builtin-implementations))  
Functions ending with `G` can only be called with some guarantee (e.g. argument is heap-allocated, or fits in some type, etc).  
Variables starting with `bi_` are builtins (primitives or special values).  
Which arguments are consumed usually is described in a comment after the function or its prototype. Otherwise, check the source.  

```
src/
  builtins/
    sfns.c      structural functions
    fns.c       other functions
    arithd.c    dyadic arithmetic functions
    arithm.c    monadic arithmetic functions (incl •math stuff)
    cmp.c       dyadic comparison functions
    md1.c       1-modifiers
    md2.c       2-modifiers
    sysfn.c     •-definitions
  utils/      utilities included as needed
    file.h      file system operations
    hash.h      hashing things
    mut.h       temporary mutable array operations
    talloc.h    temporary buffer allocations (described more below)
    utf.h       UTF-8 things
  singeli/    Singeli-specific things
    src/        *.singeli files
    c/          C files specifically for Singeli stuff
  opt/        files which aren't needed for every build configuration
  gen/        generated files
  jit/        simple JIT compiler for x86-64
  core/       things included everywhere
  h.h         core CBQN definitions
  builtins.h  definitions of all built-in functions (excluding things defined by means of nfns.c)
  core.h      file imported everywhere that defines the base BQN model
  nfns.c      native functions for things that need to keep some state (e.g. •FLines needs to also hold the path its relative to)
  load.c      loads the self-hosted compiler, runtime and formatter, initializes CBQN globals
  main.c      main function & commandline stuff
  ns.c        namespaces
  vm.c        virtual machine interpreter
)
```

### Random example functions

* `c1`, `c2` in `h.h` - correspondingly monadically or dyadically invoke a function
* `evalBC` in `vm.c` - VM bytecode interpreter
* `slash_c2` in `builtins/slash.c` - implementation of `𝕨/𝕩`
* See `load.c` `fruntime` items for more builtins (remove leading `bi_` & append `_c1`/`_c2` to get the implementation function)
* `load_init` in `load.c` - loads the BQN runtime & compiler
* `bqn_comp` in `load.c` - execute BQN code from a string
* `BN(allocL)` in `opt/mm_buddyTemplate.h` - fast path of buddy memory allocator; invoked from `opt/mm_buddy.h`
* `builtins/arithd.c` - dyadic pervasive builtins
  * non-Singeli `÷√⋆|`: `GC2f`; `×∧∨⌊⌈+-` array F array: `AR_I_AA`, atom F array: `AR_I_SA`
  * Singeli: implementations in `src/singeli/src/dyarith.singeli`, requirements/tables generated by `src/singeli/src/genArithTables.bqn`

## Base

`B`, a 64-bit NaN-boxed value, represents any BQN object. Some of the NaN-boxed types, determined by the top 16 bits, are heap-allocated (i.e. low 48 bits are a `Value*`), some aren't. The heap-allocated ones are reference-counted.
```C
Type checks (all are safe to execute on any B object):
  test           tag    description     heap-allocated
  isF64(x)       N/A    a number        no
  isC32(x)     C32_TAG  a character     no
  isAtm(x)      [many]  !isArr(x)       depends
  isVal(x)      [many]  heap-allocated  yes
  isArr(x)     ARR_TAG  an array type   yes
  isFun(x)     FUN_TAG  a function      yes
  isMd1(x)     MD1_TAG  a 1-modifier    yes
  isMd2(x)     MD2_TAG  a 2-modifier    yes
  isMd (x)      [many]  any modifier    yes
  isCallable(x) [many]  isFun|isMd      yes
  isNsp(x)     NSP_TAG  a namespace     yes
  isObj(x)     OBJ_TAG  internal        yes
  and then there are some extra types for variable slot references for the VM & whatever; see h.h *_TAG definitions

tag(x,*_TAG) // pointer → B
taga(x) // pointer → array B; == tag(x, ARR_TAG)

Functions for converting/using atom types:
  m_f64(x)  // f64 → B
  m_c32(x)  // codepoint → B
  m_i32(x)  // i32 → B
  m_usz(x)  // usz → B
  
  // convert B to an atom type (first one errors on invalid, second assumes the conversion is doable losslessly):
  o2b(x)   o2bG(x)   // bool
  o2i(x)   o2iG(x)   // i32
  o2c(x)   o2cG(x)   // c32
  o2s(x)   o2sG(x)   // usz
  o2f(x)   o2fG(x)   // f64
  o2i64(x) o2i64G(x) // i64
  o2u64(x) o2u64G(x) // u64
  
  // test if f64 or B fit in a specified type:
  q_fbit(x) q_bit(x)
  q_fi8(x)  q_i8(x)
  q_fi16(x) q_i16(x)
  q_fi32(x) q_i32(x)
  q_fi64(x) q_i64(x)
  q_fu64(x) q_u64(x)
  q_fusz(x) q_usz(x)
  
  q_N(x)    // query if x is · (≡ bi_N)
  noFill(x) // query if x represents undefined fill (which returned by getFill*; aka test if equal to bi_noFill)

type field for heap-allocated objects:
  // note that this is distinct from the tag; use TY(x) / PTY(x) to read this field
  t_empty // empty bucket; EmptyValue
  t_funBI, t_md1BI, t_md2BI // function/1-modifier/2-modifier builtins; BFn, BMd1, BMd2
  t_funBl, t_md1Bl, t_md2Bl // function/1-modifier/2-modifier blocks; FunBlock, Md1Block, Md2Block
  t_shape // shape object
  
  t_fork, t_atop // (F G H), (F G); Fork, Atop
  t_md1D, t_md2D // (F _m), (F _m_ G); Md1D, Md2D
  
  t_harr // array with generic items and no fill; HArr
  t_fillarr // array with generic items and a fill; FillArr
  t_bitarr, t_i8arr, t_i16arr, t_i32arr, t_c8arr, t_c16arr, t_c32arr, t_f64arr // arrays with typed elements; TyArr
  t_hslice, t_fillslice, t_i8slice, t_i16slice, t_i32slice, t_c8slice, t_c16slice, t_c32slice, t_f64slice // slice types of the above (except bitarr!); Slice, TySlice, HSlice, FillSlice
  
  t_mmapH // mmap-ped data; MmapHolder
  t_harrPartial // partially-written HArr
  t_comp, t_block, t_body, t_scope, t_scopeExt, t_blBlocks // various compiled object things; see vm.h/vm.c
  t_fldAlias, t_arrMerge, t_vfyObj // various mutation target data holders; see vm.h/vm.c
  t_ns, t_nsDesc // namespace, namespace descriptor; NS, NSDesc
  t_nfn, t_nfnDesc // native function, native function descriptor; NFn/NFnDesc
  t_ffiType // FFI data object; BQNFFIType
  t_customObj // type with dynamic visit & free methods; CustomObj
  t_arbObj // generic arbitrary heap-allocated object
  t_talloc, t_temp // temporary allocation types; multiple uses
  t_hashmap // hashmap
  t_freed // object mid-freeing during GC
  t_invalid // placeholder type for places where a type shouldn't be
  
  t_funWrap, t_md1Wrap, t_md2Wrap // types wrapping builtins for RT_WRAP; see rtwrap.c

See src/h.h for more basic operations
```

An object can be allocated with `mm_alloc(sizeInBytes, t_something)`. The returned object starts with the structure of `Value`, so custom data must be after that. `mm_free` can be used to force-free a heap-allocated object regardless of its reference count.

Any such allocation is guaranteed to have at least 1024 bytes readable & writable both before & after the allocation, though of course the read values should not affect any visible behavior, and writes need to write back exactly the data that was there before.

A heap-allocated object from type `B` can be cast to a `Value*` with `v(x)`, to an `Arr*` with `a(x)`, or to a specific pointer type with `c(Type,x)`.

The reference count of any `B` object can be incremented/decremented with `inc(x)`/`dec(x)`, and any subtype of `Value*` can use `ptr_inc(x)`/`ptr_dec(x)`. `inc(x)` and `ptr_inc(x)` will return the argument, so you can use it inline. `dec(x)` and `ptr_dec(x)` will free the object if the refcount as a result goes to zero. `incBy` / `incByG` offset the reference count by the specified amount, but will not free the object if it results in a reference count of zero.

Since reference counting is hard, there's `make heapverify` that verifies that any code executed does it right (and screams unreadable messages when it doesn't). After any changes, I'd suggest running `test/mainCfgs.sh path/to/mlochbaum/BQN`, which'll run a couple primary configurations, including said `heapverify`.

Temporary allocations can be made with `utils/talloc.h`:
```C
#include "utils/talloc.h"
TALLOC(char, buf, 123); // allocate char* buf with 123 elements
// buf is now a regular char* and can be stored/passed around as needed
char* buf = TALLOCP(char, 123); // alternative syntax, useful if buf is declared elsewhere
buf = TREALLOC(buf, 456); // extend buf; may reuse, may allocate new space; won't ever truncate
TFREE(buf); // free buf
// if the size is guaranteed to be small enough, using VLAs is potentially fine
// but even a rank-sized buffer is probably better off in a TALLOC (if impossible to write directly in a shape ahead-of-time)

TSALLOC(i32, stack, 10); // allocate an i32 stack with initially reserved 10 items (initial reserve must be positive!)
TSADD(stack, 15); // add a single item
TSADDA(stack, (i32*){1,2,3}, 3); // add many items
usz sz = TSSIZE(stack); // get the current height of the stack
// stack is an i32*, pointing to the bottom of the stack
TSFREE(stack); // free the stack
// note that TSALLOC creates multiple local variables, and as such cannot be passed around to other functions
```

## Virtual functions

All virtual method accesses require that the argument is heap-allocated.

You can get a virtual function of a `B` object with `TI(x, something)`. There's also `TIv(x, something)` for a pointer `x` instead. See `#define FOR_TI` in `src/h.h` for available functions.

Call a BQN function object with `c1(f, x)` or `c2(f, w, x)`. A specific builtin can be called by looking up the appropriate name in `src/builtins.h`, adding the `bi_` prefix, and invoking it with `c1`/`c2`. Note that these functions consume `w` and `x`, but leave the refcount of `f` untouched. (usually, which arguments are consumed is specified in a comment after either the function definition or prototype)

Calling a modifier involves deriving it with `m1_d`/`m2_d`, using a regular `c1`/`c2`, and managing the refcounts of everything while at that.

## Builtin implementations

The list of builtin functions is specified in the initial macros of `src/builtins.h`, where `A`/`M`/`D` are used for ambivalent/monadic/dyadic. Once added, `bi_yourName` will be available, and the required of the following functions must be defined somewhere in the source:

```C
// functions:
B yourName_c1(B t, B x);
B yourName_c2(B t, B w, B x);
// 1-modifiers:
B yourName_c1(Md1D* d, B x);
B yourName_c2(Md1D* d, B w, B x);
// 2-modifiers:
B yourName_c1(Md2D* d, B x);
B yourName_c2(Md2D* d, B w, B x);
```

For functions, in most cases, the `t` parameter (representing `𝕊`/"this") is unused (it _must_ be ignored for functions managed by `builtins.h`), but can be used for objects from `nfns.h` to store state with a function.

For modifiers, the `d` parameter stores the operands and the modifier itself. Use `d->f` for `𝔽`, `d->g` for `𝔾`, `d->m1` for `_𝕣`, `d->m2` for `_𝕣_`, and `tag(d,FUN_TAG)` for `𝕊`.

The implementation should consume the `w`/`x` arguments, but not `t`/`d`.

## Inverses

```C
// im - monadic inverse
// ix - 𝕩-inverse - w⊸F⁼ x aka w F⁼ x
// iw - 𝕨-inverse - F⟜x⁼ w
// the calls for these must be in some `whatever_init()` function, and apply only to builtins specified in builtins.h
c(BFn,bi_someFunction)->im = someFunction_im; // set the monadic inverse; someFunction_im has the signature of a regular monadic call implementation
c(BFn,bi_someFunction)->ix = someFunction_ix; // etc
c(BFn,bi_someFunction)->iw = someFunction_iw;
c(BMd1,bi_some1mod)->ix = some1mod_ix;
c(BMd2,bi_some2mod)->im = some2mod_im; // you get the idea
// for new types, the appropriate virtual functions (fn_im/fn_is/fn_iw/fn_ix/m1_im/m1_iw/m1_ix/m2_im/m2_iw/m2_ix) can be set
```

## Arrays

There exist various macros to view the main metadata of an array:

| operation                          | `B x;`    | `Value* x` / `Arr* x` / etc   | result type   |
|------------------------------------|-----------|-------------------------------|---------------|
| get shape                          | `SH(x)`   | `PSH(x)`                      | `usz*`        |
| get item amount (product of shape) | `IA(x)`   | `PIA(x)`                      | `usz`         |
| get rank                           | `RNK(x)`  | `PRNK(x)`                     | `ur`          |
| set rank                           | `SRNK(x)` | `SPRNK(x)`                    | N/A           |


The shape pointer of a rank≤1 array will point to the object's own `ia` field (the one read by `IA(x)`). Otherwise, it'll point within a reference-counted `t_shape` object (`ShArr`'s `a` field).

Allocating an array:
```C
i32* rp; B r = m_i32arrv(&rp, 123); // allocate a 123-element i32 list
i32* rp; B r = m_i32arrc(&rp, x); // allocate an array with the same shape as x (x must be an array; x isn't consumed)

i32* rp; Arr* r = m_i32arrp(&rp, 123); // allocate a 123-element i32-array without allocating shape
// then at some point do one of these:
arr_shVec(r); // set shape of r to a list
usz* sh = arr_shAlloc(r, 4); // allocate a rank 4 shape; write to sh the individual items; sh will be NULL for ranks 0 and 1
arr_shCopy(r, x); // copy the shape object of x (doesn't consume x)
// then get the final array:
B result = taga(r);
// see stuff.h for m_shArr/arr_shSet* for ways to batch-assign a single shape object to multiple objects

u32* rp; B r = m_c32arrv(%rp, 10); // 10-char string
// etc for m_(i8|i16|i32|c8|c16|c32|f64)arr[vcp]


// arbitrary object arrays:
// initialized with all elements being 0.0s, which you can replace with `r.a[i]=val`, and get the result with `r.b`; simple, but may not be optimal
HArr_p r = m_harr0v(10); // new 10-item list
HArr_p r = m_harr0c(10, x); // new 10-item array with the same shape as x
HArr_p r = m_harr0p(10); // new 10-item array without any set shape. Use the arr_shWhatever(r.c, …)

// safe known size array creation without preinitialization:
M_HARR(r, 123) // allocate a 123-item arbitrary object array
HARR_ADD(r, i, val); // write val to the next position in the array. The 'i' variable is just a hint, all calls must be consecutive either way
HARR_ADDA(r, val); // the above but without needing the useless 'i' parameter
// then do one of these to get the finished object:
B result = HARR_FV(r); // sets shape to a list
B result = HARR_FC(r, x); // copies the shape of x, doesn't consume x
B result = HARR_FCD(r, x); // copies the shape of x and consumes it
usz* sh = HARR_FA(r, 4); // allocate shape for a rank 4 array. To get the result `B` object, do HARR_O(r).b later
Arr* result = HARR_FP(r); // don't allocate/set any shape
// If at any point you want to free the object before finishing it, do HARR_ABANDON(r)

// If you're sure GC cannot happen (that includes no allocating) before all items in the array are set, you can use:
HArr_p r = m_harrUv(10); // 10-item list
HArr_p r = m_harrUc(10, x); // 10-item array with the same shape as x
HArr_p r = m_harrUp(10); // 10-item array without any set shape. Use the arr_shWhatever(r.c, …)
// run `NOGC_E;` after filling in the items to resume allowing allocations (not necessary if item count is 0)

// you can use withFill to add a fill element to a created array (or manually create a fillarr, see src/core/fillarr.h)

B r = m_c32vec(U"⟨1⋄2⋄3⟩", 7); // a constant string with unicode chars
B r = m_c32vec_0(U"⟨1⋄2⋄3⟩"); // ..or with implicit length
B r = m_c8vec("hello", 5); // a constant ASCII string
B r = m_c8vec_0("hello"); // ..or with implicit length
B r = utf8Decode("⟨1⋄2⋄3⟩", 17) // decode UTF-8 from a char*
B r = utf8Decode0("⟨1⋄2⋄3⟩") // ..or with implicit length
#include "utils/utf.h"
u64 sz = utf8lenB(x); TALLOC(char, buf, sz+1); toUTF8(x, buf); buf[sz]=0; /*use buf as a C-string*/ TFREE(buf);

// src/utils/mut.h provides a way to build an array by copying parts of other arrays

// some functions for making specific arrays:
B r = m_unit(x); // equivalent to <𝕩
B r = m_hunit(x); // like the above, except no fill is set
B r = m_atomUnit(x); // if x is likely to be an atom, this is a better alternative to m_unit
B r = m_hVec1(a); // ⟨a⟩
B r = m_hVec2(a,b); // ⟨a,b⟩
B r = m_hVec3(a,b,c); // ⟨a,b,c⟩
B r = m_hVec4(a,b,c,d); // ⟨a,b,c,d⟩
B r = emptyHVec(); // an empty vector with no fill
B r = emptyIVec(); // an empty integer vector
B r = emptyCVec(); // an empty character vector
B r = emptySVec(); // an empty string vector
```


Retrieving data from arrays:
```C
// generic methods:
SGet(x) // initializes the getter for fast reads; the argument must be a variable name
B c = Get(x,n); // in a loop, reading the n-th item

SGetU(x)
B c = GetU(x,n); // alternatively, GetU can be used to not increment the result. Useful for temporary usage of the item or if it is known to not be heap-allocated (or code throws an error if it is)

B c = IGet(x,n); // skip the initialize/call separation; not suggested in loops
B c = IGetU(x,n);

// for specific array types:
if (TI(x,elType)==el_i32) i32* xp = i32any_ptr(x); // for either t_i32arr or t_i32slice; for t_i32arr only, there's i32arr_ptr(x); same for all other primitive element types (bitarr has bitany_ptr but no slice type yet)
if (TI(x,elType)!=el_B) void* xp = tyany_ptr(x); // alternative equivalent check: IS_ANY_ARR(TY(x)); tyarr_ptr if the input is also known to not be a slice
if (TY(x)==t_harr) B* xp = harr_ptr(x); // similarly, hslice_ptr, fillarrv_ptr, fillslicev_ptr for specific types
B* xp = arr_bptr(x); // will return NULL if the array isn't backed by a contiguous B*
// while currently there are no types with eltype el_B for which arr_bptr isn't NULL, that could change in the future and so should still be handled
// testable with f=-DARR_BPTR_NEVER, which makes arr_bptr & arrv_bptr always return NULL
// use arr_bptrG & arrv_bptrG if you know that the input is B*-backed and want to rely on it (never returns NULL; unaffected by ARR_BPTR_NEVER)

// most arr_* fns have a arrv_* variant that takes an untagged pointer instead of B

// functions to convert arrays to a specific type array: (all consume their argument, and assume that the elements losslessly fit in the desired type)
I8Arr* a = toI8Arr(x); // convert x to an I8Arr instance (returns the argument if it already is)
I8Arr* a = (I8Arr*)cpyI8Arr(x); // get an I8Arr with reference count 1 with the same items & shape
B a = toI8Any(x); // get an object which be a valid argument to i8any_ptr
// same logic applies for:
// toBitArr/toI8Arr/toI16Arr/toI32Arr/toF64Arr/toC8Arr/toC16Arr/toC32Arr/toHArr
// cpyBitArr/cpyI8Arr/cpyI16Arr/cpyI32Arr/cpyF64Arr/cpyC8Arr/cpyC16Arr/cpyC32Arr/cpyHArr
// toI8Any/toI16Any/toI32Any/toF64Any/toC8Any/toC16Any/toC32Any
```

## Errors

Throw an error with `thrM("some message")` or `thr(some B object)` or `thrOOM()`. Leaving reference counts at a higher-than-necessary reference count is acceptable.

A fancier message can be created with `thrF(message, …)` with printf-like (but different!!) varargs (source in `do_fmt`):
```
%i   decimal i32 (also for i8/i16/ur)
%l   decimal i64
%ui  decimal u32 (also for u8/u16)
%ul  decimal u64
%xi  hex u32
%xl  hex u64
%s   decimal usz
%f   f64
%p   pointer
%c   unicode character (u32)
%S   char* C-string consisting of ASCII
%U   char* of UTF-8 data
%R   a B object of a number or string (string is printed without quotes or escaping)
%H   the shape of a B object
%2H  a shape, passed in by a ur & usz*
%B   a B object, formatted by •Repr (be very very careful to not give a potentially large object, which'd lead to unreadably long messages!)
%%   "%"
```
See `#define CATCH` in `src/h.h` for how to catch errors.

Use `assert(predicate)` for checks (for optimized builds they're replaced with `if (!predicate) invoke_undefined_behavior();` so it's still invoked!!). `UD;` can be used to explicitly invoke undefined behavior (equivalent in behavior to `assert(false);`), which is useful for things like untaken `default` branches in `switch` statements.

There's also `fatal("message")` that (at least currently) is kept in optimized builds as-is, and always kills the process on being called.

## Garbage collector

The garbage collector can run either at the top level (currently, between lines of REPL input) at full capability, where all unreferenced objects will be freed, or potentially during any allocation in a severely restricted mode where any object with a reference count not matching the expected value is assumed as a GC root (intention being that it's referred to by live code on the C stack, but it could also be a leak if an error left reference counts too high).

Therefore, at any point of execution where an allocation or error happens, the heap must be in a valid state (that is, most allocated objects need all their pointer/object fields initialized (more precisely, anything used by the object's `void [type]_visit()` function (and `[type]_free` if the object may be GC'd))). Manually `mm_alloc`ing an object will result in an invalid initial state for most types, but higher-level allocation function helpers usually initialize them to a valid state (e.g. `m_c8arrv`, `m_tyarrp`, `m_md2D`, `m_scope`, `m_harr0p`, `m_fillarr0p`, `m_fillarrpEmpty`), but some do not (e.g. `m_harrUv`, `m_fillarrp`); those will need a `NOGC_E;` statement to be added after you've initialized them (and be careful to do that only when actually done - the debugging options for a GC during an incompletely-initialized heap aren't nice!)

To add a permanent GC root, use `gc_add(B x)`. To add dynamic roots, the options are `gc_add_ref(B* x)`, which checks & uses `*x` as a GC root, or `gc_addFn(vfn f)`, where the given function should invoke `mm_visit` or `mm_visitP` on the objects it wants to assume as roots. `gc_add` and `gc_add_ref` and `mm_visit` accept non-heap-allocated values (i.e. numbers, characters, `bi_N`), but `mm_visitP` must not be passed the null pointer.

## GDB

A couple functions for simple actions within GDB/LLDB are defined:

```C
void g_pst()         // print a BQN stacktrace; might not work if paused in the middle of stackframe manipulation, but it tries
void g_p(B x)        // print x
void g_i(B x)        // print •internal.Info x
void g_pv(Value* x)  // g_p but for an untagged value
void g_iv(Value* x)  // g_i but for an untagged value
Value* g_v(B x)      // untag a value
Arr*   g_a(B x)      // untag a value to Arr*
B      g_t (void* x) // tag pointer with OBJ_TAG
B      g_ta(void* x) // tag pointer with ARR_TAG
B      g_tf(void* x) // tag pointer with FUN_TAG
// invoke with "p g_p(whatever)"; requires a build with debug symbols for best experience, but e.g. "p (void)g_pst()" can be used without one
```

## Various `#define`s

Most toggles require a value of `1` to be enabled.

```c
// (effective) usual default value is listed; (u) marks being not defined
// defaults may change under some conditions (DEBUG, USE_SETJMP, heapverify, among maybe other things)
// some things fully configured by the build system may not be listed

// general config:
#define REPL_INTERRUPT 0 // support ctrl+c for interrupting some REPL execution
#define ENABLE_GC 1      // enable garbage collection
#define MM 1             // memory manager; 0 - malloc (no GC); 1 - buddy; 2 - 2buddy
#define HEAP_MAX ~0ULL   // initial heap max size (overridden by -M)
#define JIT_ENABLED (u)  // force-enable or force-disable JIT (x86_64-only)
#define RANDSEED 0       // random seed used to make •rand (0 uses time)
#define JIT_START 2      // number of calls for when to start JITting (x86_64-only); default is 2, defined in vm.h
        // -1: never JIT (≈ JIT_ENABLED=0)
        //  0: JIT everything
        // >0: JIT after n non-JIT invocations; max ¯1+2⋆16

// runtime configuration:
#define ALL_R0 0 // use all of r0.bqn for runtime_0
#define ALL_R1 0 // use all of r1.bqn for runtime
#define NO_RT  0 // whether to completely disable self-hosted runtime loading
#define FAKE_RUNTIME 0 // disable the self-hosted runtime
#define FORMATTER    1 // use self-hosted formatter for output
#define NO_EXPLAIN   0 // disable )explain
#define NO_RYU       0 // disable usage of Ryu
#define EACH_FILLS   0 // compute fills for ¨ and ⌜; may be forcibly disabled
#define SFNS_FILLS   1 // compute fills for structural functions (∾, ≍, etc)
#define CHECK_VALID  1 // check for valid arguments in places where that would be detrimental to performance
        // e.g. left argument sortedness of ⍋/⍒, incompatible changes in ⌾, etc
#define USE_SETJMP   1 // whether setjmp is available & should be used for error catching (makes refcounts leakable)
#define SEMANTIC_CATCH USE_SETJMP // whether catching should be assumed to be usable for operations which need to semantically change depending on that
#define SEMANTIC_CATCH_BI SEMANTIC_CATCH // whether ⎊ will catch stuff

#define RYU_OPTIMIZE_SIZE 0 // reduce size of Ryu tables at the cost of some performance for number •Repr
#define FFI_CHECKS   1 // check for valid arguments passed to FFI-d functions
#define UNSAFE_SIZES 0 // disable safety checks on array length overflows

// debugging stuff:
#define DEBUG           0 // the regular debug build
#define HEAP_VERIFY     0 // heapverify
#define RT_VERIFY       0 // compare native and runtime versions of primitives
#define WARN_SLOW       0 // log on various slow operations
#define USE_PERF        0 // write a /tmp/perf-<pid>.map for JITted things for linux perf
#define GC_LOG_DETAILED 0 // slightly more stats on GC logging
#define DEBUG_VM        0 // print evaluation of every bytecode
#define USE_VALGRIND    0 // adjust memory manager & code for valgrind usage
#define VERIFY_TAIL   (u) // number of bytes after the end of an array to verify not being improperly modified; 64 in DEBUG
#define NEEQUAL_NEGZERO 0 // make negative zero not equal zero for •internal.EEqual
#define RT_VERIFY_ARGS  1 // rtverify: preserve arguments for printing on failure
#define GC_EVERY_NTH_ALLOC (u) // force a GC on every n'th allocation (<=1 to GC on every alloc)

// some somewhat-outdated/unmaintained things:
#define RT_PERF   0   // time runtime primitives
#define ALLOC_STAT  0 // store basic allocation statistics
#define ALLOC_SIZES 0 // store per-type allocation size statistics
#define DONT_FREE 0   // don't actually ever free objects, such that they can be printed after being freed for debugging
#define TYPED_ARITH 1 // enable specialized loops for typed arith
#define VM_POS 1      // whether to store detailed execution position information for stacktraces
#define OBJ_COUNTER 0 // store a unique allocation number with each object; superseded by the existence of https://rr-project.org/
#define OBJ_TRACK (u) // object ID to track
```
