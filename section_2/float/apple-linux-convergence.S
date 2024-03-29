/*  Macros to permit the "same" assembly language to build on ARM64
    Linux systems as well as Apple Silicon systems.

    See the fuller documentation at:
    https://github.com/pkivolowitz/asm_book/blob/main/macros/README.md

    Perry Kivolowitz
    A Gentle Introduction to Assembly Language
*/

.macro  GLD_PTR     xreg, label
#if defined(__APPLE__)
        adrp	    \xreg, _\label@GOTPAGE
        ldr	        \xreg, [\xreg, _\label@GOTPAGEOFF]
#else
        ldr         \xreg, =\label
        ldr         \xreg, [\xreg]
#endif
.endm

.macro  GLD_ADDR    xreg, label     // Get a global address
#if defined(__APPLE__)
        adrp	    \xreg, _\label@GOTPAGE
        add         \xreg, \xreg, _\label@GOTPAGEOFF
#else
        ldr         \xreg, =\label
#endif
.endm

.macro  LLD_ADDR xreg, label
#if defined(__APPLE__)
        adrp    \xreg, \label@PAGE
        add     \xreg, \xreg, \label@PAGEOFF
#else
        ldr         \xreg, =\label
#endif
.endm

.macro  LLD_DBL xreg, dreg, label
#if defined(__APPLE__)
        adrp    \xreg, \label@PAGE
        add     \xreg, \xreg, \label@PAGEOFF
        ldur    \dreg, [\xreg]
//      fmov    \dreg, \xreg
#else
        ldr     \xreg, =\label
        ldur    \dreg, [\xreg]
#endif
.endm

.macro  LLD_FLT xreg, sreg, label
#if defined(__APPLE__)
        adrp    \xreg, \label@PAGE
        add     \xreg, \xreg, \label@PAGEOFF
        ldur    \sreg, [\xreg]
#else
        ldr     \xreg, =\label
        ldur    \sreg, [\xreg]
#endif
.endm

.macro GLABEL label
#if defined(__APPLE__)
        .global _\label
#else
        .global \label
#endif
.endm

.macro MAIN
#if defined(__APPLE__)
_main:
#else
main:
#endif
.endm

.macro  CRT label
#if defined(__APPLE__)
        bl  _\label
#else
        bl  \label
#endif
.endm

.macro  START_PROC          // after starting label
        .cfi_startproc
.endm

.macro  END_PROC            // after the return
        .cfi_endproc
.endm

.macro  PUSH_P  a, b 
        stp     \a, \b, [sp, -16]!
.endm

.macro  PUSH_R  a 
        str     \a, [sp, -16]!
.endm

.macro  POP_P   a, b 
        ldp     \a, \b, [sp], 16
.endm

.macro  POP_R   a 
        ldr     \a, [sp], 16
.endm

.macro  MIN     src_a, src_b, dest
        csel    \dest, \src_a, \src_b, GT
.endm

.macro  MAX     src_a, src_b, dest
        csel    \dest, \src_a, \src_b, LT
.endm
