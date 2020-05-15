.globl main

.data
hello: .string "Hello world!\n"

.text
main:
movq $0, %rax # write(1, hello, strlen(hello))
movq $1, %rbx
movq $hello, %rcx
movq $13, %rdx
syscall

movq $60, %rax # exit(0)
movq $0, %rbx
syscall