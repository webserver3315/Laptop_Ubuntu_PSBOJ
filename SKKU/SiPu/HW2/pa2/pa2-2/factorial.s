/*
SWE2001 System Program (Spring 2020)
Prof:	Jinkyu Jeong (jinkyu@skku.edu)

TA: 	Sunghwan Kim(sunghwan.kim@csi.skku.edu)
	Jiwon Woo(jiwon.woo@csi.skku.edu)
Semiconductor Building #400509
Author: Sunghwan Kim
Description: Find nth factnacci number
***Copyright (c) 2020 SungKyunKwan Univ. CSI***
*/

.data
buffer: 	.space 	4
BUFSIZE: 	.int 	4
file_in:	.string "pa2-2.in"
msg_print:	.string "fact[%d] = %d\n"
msg_nl:		.string "\n"

/* code section start */
.text
.globl	main
main: 
/* === file open === */
movq $2, %rax		/* open(	; syscall #: 2 */
movq $file_in, %rdi	/* "hw2-3.in"	; filename */
movq $0x000, %rsi	/* O_RDONLY	; flags */
movq $0644, %rdx	/* 0644		; mode */
syscall			/* );		; */

movq %rax, %rbx		/* save fd */
/* === file read === */
movq $0, %rax		/* read (	; syscall #: 0 */
movq %rbx, %rdi		/* fd 		; file descriptor */
movq $buffer, %rsi	/* buf 		; buffer address */
movq $BUFSIZE, %rdx	/* BUFSIZE	; read size (byte unit) */
syscall			/* ); */

/* === file close === */
movq $3, %rax
movq %rbx, %rdi
syscall

/* === call fact() === */
push %rax
movq $buffer, %r12
movl (%r12), %edi	/* Corrected */
call _fact
movq %rax, %rbx
pop %rax

/* === print result === */
movq $msg_print, %rdi
movq $buffer, %r12
movl (%r12), %esi	/* Corrected */
movq %rbx, %rdx
call printf

/* === exit === */
movq $60, %rax
movq $0, %rdi
syscall

_fact:
/* ============= Start of your code ================== */
	pushq %rbx
    movq %rdi, %rbx
    movl $1, %eax
    cmpq $1, %rdi
    jle .L35
    leaq -1(%rdi), %rdi
    call _fact
    imulq %rbx, %rax
.L35:
    popq %rbx
    ret
/* ============== End of your code =================== */

