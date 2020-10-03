.globl main
.data
hello: .string "Hello world!\n"

.text
main:
; movl $1, %eax # write(1, hello, strlen(hello))
; movl $1, %ebx
; movl $hello, %ecx
; movl $13, %edx
movq $1, %rax # write(1, hello, strlen(hello))
movq $1, %rbx
movq $hello, %rcx
movq $13, %rdx
syscall

movq $60, %rax # exit(0)
movq $0, %rbx
syscall
