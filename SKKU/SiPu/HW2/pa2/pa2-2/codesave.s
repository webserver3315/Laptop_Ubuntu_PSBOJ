_fibo:
/* ============= Start of your code ================== */
	push %ebp
	mov %esp, %ebp
	sub $4, %esp
	mov %eax, (%ebp+8)
	cmp $2, %eax
	call _End # call 맞나? jl 써야하나?
	dec %eax
	push %eax
	call _fibo
	mov %eax, (%eax-4)
	lea -2(%esp),%esp
	call _fibo
	add 4, %esp
	
/* ============== End of your code =================== */
ret

_End:
	mov $1, %eax
	ret

_fibo:
/* ============= Start of your code ================== */
	# 백업 후 1과 비교하여 기본값 반환여부 체크
	push %ebx # n 값은 rbx에 저장되어있음. 또한 pop시 1회 복원가능
	mov %edi, %ebx
	mov $0, %eax # return value = 0 initialized
	cmp $1, %edi # 현재 n값과 1을 비교
	jle done 

	# 1보다 크면
	dec %edi
	call _fibo
	
	dec %edi
	call _fibo

	
/* ============== End of your code =================== */
ret

done:
	popq %rbx
	ret

_End:
	mov $1, %eax
	ret


	_fact:
/* ============= Start of your code ================== */
    cmpq $1, %rdi
    jle .L35 # rdi<=1 == n<=1
	pushq %rbx
    movq %rdi, %rbx # rbx 자리에 현재 인수인 n, 즉 rdi값으로 보존

    dec %rdi
    call _fact
    movq %rax, %rbx
    pop %rax
    add %rbx, %rax

    dec %rdi
    call _fact
    movq %rax, %rbx
    pop %rax
    add %rbx, %rax

    imulq %rbx, %rax
.L35:
    popq %rbx
    ret
/* ============== End of your code =================== */

/*
피보나치 거의 완성. 다만 1씩 밀림
*/


_fibo:
/* ============= Start of your code ================== */
    cmp $2, %rdi # 2 < %rdi?
    jg recur # bigger than 2 -> recursive
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

