/*
SWE2001 System Program (Spring 2020)
Prof:	Jinkyu Jeong (jinkyu@skku.edu)

TA: 	Sunghwan Kim(sunghwan.kim@csi.skku.edu)
	Jiwon Woo(jiwon.woo@csi.skku.edu)
Semiconductor Building #400509
Author: Sunghwan Kim
Description: Find nth fibonacci number
***Copyright (c) 2020 SungKyunKwan Univ. CSI***
*/

.data
buffer: 	.space 	4
BUFSIZE: 	.int 	4
file_in:	.string "pa2-2.in"
msg_print:	.string "fibo[%d] = %d\n"
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

/* === call fibo() === */
push %rax
movq $buffer, %r12
movl (%r12), %edi	/* Corrected */
call _fibo
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

_fibo:
/* ============= Start of your code ================== */
    cmp $1, %rdi # 1 < %rdi?
    jg recur # bigger than 1 -> recursive
    movq $1, %rax # else: return 1
    ret
/* ============== End of your code =================== */

recur:
    push %rdx # save rdx : local variable
    dec %rdi # decrease rdi : n--
    call _fibo # recursive, and return address saved next
    movq %rax, %rdx # rdx saves fib(n-1)
    dec %rdi # decrease rdi again : fib(n-2)
    call _fibo # rax will save fib(n-2)
    add %rdx, %rax # rax(==fib(n-2))+=rdx(==fib(n-1))

    add $2, %rdi # restore rdi to n
    popq %rdx # restore rdx, which saved

    ret

