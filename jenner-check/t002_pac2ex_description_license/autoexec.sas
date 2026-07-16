/* cap input rows for the captured run */
options obs=100;

/* %pac2ex() normally does: libname PAC2EX "<work>/PAC2EX"; after dcreate().
   We point PAC2EX straight at WORK -- same libref name the macro expects,
   no behavior difference for this bundle. */
libname PAC2EX "%sysfunc(pathname(work))";
