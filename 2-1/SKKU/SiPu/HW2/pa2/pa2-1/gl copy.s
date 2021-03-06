/*
SWE2001 System Program (Spring 2020)
Prof:	Jinkyu Jeong (jinkyu@skku.edu)

TA: 	Sunghwan Kim(sunghwan.kim@csi.skku.edu)
	Jiwon Woo(jiwon.woo@csi.skku.edu)
Semiconductor Building #400509
Author: Sunghwan Kim
Description: Find GCD (Greate Common Divisor) and LCM (Least Common Multiple)
***Copyright (c) 2020 SungKyunKwan Univ. CSI***
*/

.data
buffer: 	.space 	8
BUFSIZE: 	.int 	8
file_in:	.string "pa2-1.in"
msg_GCD:	.string "Greate Common Divisor\t[%d, %d] = %d\n"
msg_LCM:	.string "Least Common Multiple\t[%d, %d] = %d\n"

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

/* === call gcd() === */
push %rax
movq $buffer, %r12
movl (%r12), %edi
movl 4(%r12), %esi
call _gcd
movl %eax, %ebx
pop %rax

/* === call lcm() === */
push %rax
movq $buffer, %r12
movl (%r12), %edi
movl 4(%r12), %esi
call _lcm
movl %eax, %ecx
pop %rax

/* === print result === */
push %rax
push %rcx
movq $msg_GCD, %rdi
movq $buffer, %r12
movl (%r12), %esi
movl 4(%r12), %edx
movl %ebx, %ecx
call printf
pop %rcx
pop %rax

movq $msg_LCM, %rdi
movq $buffer, %r12
movl (%r12), %esi
movl 4(%r12), %edx
call printf

/* === exit === */
movq $60, %rax
movq $0, %rdi
syscall

_gcd:
/* ============= Start of your code ================== */

/* ============== End of your code =================== */
ret

_lcm:
/* ============= Start of your code ================== */

/* ============== End of your code =================== */
ret
