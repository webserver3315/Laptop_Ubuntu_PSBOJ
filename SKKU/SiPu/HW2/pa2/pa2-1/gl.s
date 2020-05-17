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
cmpq %rsi, %rdi # rsi -> m, rdi -> n
jg .L13 # if n>m, goto L13
jmp .L14 # else goto L14

.L15: # 반복문 돌입 전 준비단계
movq %r8, %r9 # r9 = i, r8 = j, i=j
movq %r9, %rax
imulq %r8 # r8 * rax 를 rax 및 rdx에 저장
movq %rax, %r10 # m*n값을 r10에 저장
subq %r8, %r9 # r9 - r8 = i - j
jmp .L12 # 반목문 돌입

.L12: # 반복문
addq %r8, %r9
cmpq %r10, %r9 # i>m*n이면 break
jg done2 #  break

movq %r9, %rax # i 를 rax에 저장. 나누기 위함
cqto 
idivq %rdi # rdi로 rax를 나누기 -> i(rax)%n(rdi)
cmpq $0, %rdx # 결과가 0이 아니라면 일단 통과
jne .L12 # continue

movq %r9, %rax # i를 다시 r9에 저장
cqto # oct word로 rax 값을 sign extension하고
idivq %rsi # rsi값으로 rax를 나눈다. 즉 i를 m으로 나눈다
cmpq $0, %rdx # m%i!=0
jne .L12 # continue

jmp done2 # 조건문 다 뚫었다면, i는 m%i==0 이면서도 n%i==0이라는 것
ret

.L13:
movq %rdi, %r8 # let r8 == j and put n into j
jmp .L15

.L14:
movq %rsi, %r8 # else, let r8 == j and put m into j
jmp .L15

done2:
# i 를 리턴한다는건 gcd와 똑같음
mov %r9, %rax
ret
