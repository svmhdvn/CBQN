#include <stdlib.h>
#include <malloc.h>
extern GLOBAL u64 mm_heapAlloc;
extern GLOBAL u64 mm_heapMax;

static void mm_free(Value* x) {
  preFree(x, false);
  free(x);
}

static void* mm_alloc(u64 sz, u8 type) {
  Value* x = malloc(sz);
  preAlloc(sz, type);
  x->flags = x->extra = x->mmInfo = x->type = 0;
  x->refc = 1;
  x->type = type;
  return x;
}

#define gc_running 0
static void gc_disable() { }
static void gc_enable() { }
static void mm_visit(B x) { }
static void mm_visitP(void* x) { }

bool gc_maybeGC(bool);
void gc_forceGC(bool);
#define gc_depth 0
void mm_forHeap(V2v f);
void mm_dumpHeap(FILE* f);

static u64  mm_round(usz x) { return x; }
static u64  mm_size(Value* x) {
  size_t r = malloc_usable_size(x);
  if (((ssize_t)r) < 16) fatal("MM=0 requires working malloc_usable_size");
  return r;
}
static u64  mm_totalAllocated() { return -1; }
