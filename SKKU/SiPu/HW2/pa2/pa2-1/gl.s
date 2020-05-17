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


/*
n - rdi
m - rsi
i - r9
j - r8
rax - 나눗셈용 버퍼
*/

_gcd:
/* ============= Start of your code ================== */
cmpq %rsi, %rdi # rsi -> m, rdi -> n
jl .L3 # if n<m, goto L3
; cmpq %rsi, %rdi # rsi -> m, rdi -> n
jge .L4 # else goto L4

.L5:
movq %r8, %r9 # r9 = i, r8 = j, i=j
leaq 1(%r9), %r9
jmp .L2 # 반목문 돌입

.L2: # 반복문
dec %r9
cmpq $0, %r9 # i<=0이면 break
jle done #  break

movq %rdi, %rax # idiv 하려고 n, 즉 rdi값을 rax에 저장
cqto # oct word로 rax 값을 sign extension하고
idivq %r9 # rax에 든 n값을 i로 나눈다. 나머지는 rdx에 저장됨
cmpq $0, %rdx # n%i != 0
jne .L2 # continue

movq %rsi, %rax # idiv 하려고 m, 즉 rsi값을 rax에 저장
cqto # oct word로 rax 값을 sign extension하고
idivq %r9 # rax에 든 m값을 i로 나눈다. 나머지는 rdx에 저장됨
cmpq $0, %rdx # m%i!=0
jne .L2 # continue

jmp done # 조건문 다 뚫었다면, i는 gcd라는것
ret

.L3:
movq %rdi, %r8 # let r8 == j and put n into j
jmp .L5

.L4:
movq %rsi, %r8 # else, let r8 == j and put m into j
jmp .L5

done:
movq %r9, %rax # i를 rax에 저장한 뒤, 리턴
ret

_lcm:
/* ============= Start of your code ================== */

/* ============== End of your code =================== */
ret
