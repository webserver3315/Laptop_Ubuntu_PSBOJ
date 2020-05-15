.data
    star double '*'
    empty double 0x0a

.text
    global _start
    
_start:
    movl $1, %rax ;시스템콜 설정
    movl $1, %rdi ;기본출력모드
    movl $1, %rdx ;출력길이설정
    movl $0, %r10 ; 인덱스
    movl (rsp+16), %r9 ;입력된 문자열 찾기

    cmp $0, %r9;입력없는경우
    je _done;종료

    movl (%r9), cl ;cl은 r9가 가리키는 문자열에서 오직 한 바이트만 받는다는 뜻.
    movzx cl, %r9 ;cl에는 한 아스키코드만 담겨있는데, 이를 r9로
    sub $0x30, %r9;

_done:

