#pragma once
#if REPL_INTERRUPT && !__has_include(<signal.h>)
  #undef REPL_INTERRUPT
#endif

bool cbqn_takeInterrupts(bool b);

#if REPL_INTERRUPT
extern volatile int cbqn_interrupted;
NOINLINE NORETURN void cbqn_onInterrupt();
#define CHECK_INTERRUPT do { if (cbqn_interrupted) cbqn_onInterrupt(); } while(0)
#else
#define CHECK_INTERRUPT
#endif
