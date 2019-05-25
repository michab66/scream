(AUTOLOAD-FROM-FILE
   (%SYSTEM-FILE-NAME "COMPILER.FSL")
   '(CREATE-SCHEME-MACRO %EXPAND-SYNTAX-FORM PCS-MACRO-EXPAND 
     PCS-SIMPLIFY PCS-CLOSURE-ANALYSIS PCS-GENCODE PCS-POSTGEN 
     PCS-PRINCODE PCS-ASSEMBLER LOAD COMPILE-FILE %COMPILE-TIMINGS 
     %COMPILE COMPILE PCS-COMPILE-TO-AL PCS-EXECUTE-AL OPTIMIZE! 
     PCS-CHK-ID PCS-CHK-LENGTH= PCS-CHK-LENGTH>= PCS-CHK-BVL 
     PCS-CHK-PAIRS PCS-CHK-BVAR EXPAND-MACRO EXPAND-MACRO-1 EXPAND 
     INITIATE-EDWIN EDWIN %PCS-STL-DEBUG-FLAG %PCS-STL-HISTORY 
     PCS-LOCAL-VAR-COUNT PCS-INTEGRATE-INTEGRABLES 
     PCS-INTEGRATE-PRIMITIVES PCS-INTEGRATE-T-AND-NIL 
     PCS-INTEGRATE-DEFINE PCS-DEBUG-MODE PCS-PERMIT-PEEP-1 
     PCS-PERMIT-PEEP-2 PCS-VERBOSE-FLAG PCS-DISPLAY-WARNINGS PME= PSIMP= 
     PCG= PPEEP= PASM= EVAL PCS-DEFINE-PRIMOP PCS-PRIMOP-STD-N2 
     PCS-PRIMOP-APPEND* PCS-PRIMOP-+ PCS-PRIMOP-- PCS-PRIMOP-* 
     PCS-PRIMOP-/ PCS-PRIMOP-VECTOR PCS-PRIMOP-LIST PCS-PRIMOP-LIST* 
     PCS-PRIMOP-MAKE-VECTOR PCS-PRIMOP-IO-1 PCS-PRIMOP-IO-2 
     PCS-DEFINE-OPCODE)
   USER-GLOBAL-ENVIRONMENT)