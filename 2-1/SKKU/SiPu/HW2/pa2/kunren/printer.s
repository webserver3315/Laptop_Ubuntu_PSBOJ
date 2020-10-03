.globl main
.data
# msg_0: .string "hello_world\n"
msg_0: .int 1
msg_1: .string "bye_world\n"
len_0: int 4
len_1 = . -msg_1

.text
main:
    ; lea -8(%rsp),%rsp
    ; mov $10, %edi
    ; call fact
    ; mov %rax, %rdi
    ; call print
    ; mov $0, %eax
    ; lea 8(%rsp), %rsp

    ; movl $1, %eax		# write (	   | syscall #: 1
    ; movl $1, %edi		# 1,		   | file descriptor (stdout:1)
    ; movl $1, %esi	# "bye_world\n",   | buffer address
    ; movl $1, %edx	# <length of text> | buffer length

    movl $1, %eax		# write (	    | syscall #: 1
    movl $1, %edi		# 1,		    | file descriptor (stdout:1)
    movl $msg_0, %esi 	# "hello_world\n",  | buffer address
    movl $len_0, %edx	# <length of text>  | buffer length
    syscall # printf(1)

    jmp done

fact:
    mov $1, %eax
    jmp fact+15
    imul %rdi, %rax
    sub $1, %rdi
    cmp $1, %rdi
    jg fact+7
    ret

print:
    movq %rax, %r10
    movq $1, %rax
    movq $1, %rdi
    movq %r10, %rsi
    movq $1, %rdx
    syscall
    ret

done:
movl $60, %eax		# exit (	  | syscall #: 60
movl $0, %ebx		# 0		  | error_code
syscall			# )
