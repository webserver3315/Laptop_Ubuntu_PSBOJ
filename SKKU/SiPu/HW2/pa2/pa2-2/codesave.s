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