#-------------------------------------------------------------
#
#SWE3005_42 Introduction of Computer Architecture(Spring 2021)
#
#Instructor :Prof.Tae Hee Han(than@skku.edu)
#
#Editor: Jae eun Shim(david4466@g.skku.edu)
#
#Description : Spiral Matrix in RISC-V
#
#Copyright(C) 2021 SungKyunKwan University
#
#-------------------------------------------------------------

.section .text
.globl spiral

#------------------------------------------------------------
#                       spiral function
#------------------------------------------------------------



#---------------------------------------------------------------------------
#	you can write your code here: START
#---------------------------------------------------------------------------

spiral: 
    addi sp, sp, -24
    sd ra, 16(sp)
    sd a1, 8(sp)
    sd a0, 0(sp)

    addi p_s9, a0, 0      # p_s9 == p
    addi len_s10, a1, 0     # len_s10 == len => main에서도 바뀌는걸보면 len 은 메모리에 있고 주소값 자체를 옮겨버리는듯
    addi 15_s2, zero, 15   # 15_s2 == 15 (MAX COLUMN)

    addi x_s5, zero, 0    # x_s5 == x
    addi y_s6, zero, -1   # y_s6 == y
    addi cnt_s7, zero, 1    # cnt_s7 == cnt
    addi turn_s8, zero, 1    # turn_s8 == turn

_while:
    blt len_s10, zero, _exit

    addi i_t2, zero, 0    # i_t2 == i
_for1:
    bge p_s9, len_s10, _for1_exit
    add y_s6, y_s6, turn_s8      # y = y+turn
    
    # Making p[x][y] address to t1
    # 주소: p + 15*8*x + 8*y => (15*x)+y => (((x<<4)-x))+y)<<3 + p
    # 아, 혹시 이게 아닌가? p[x]가 가리키는 주소가 베이스인가...?
    addi t1, zero, 0    # t1 Initialize to zero
    slli t1, x_s5, 4      # t1 <- x<<4
    sub t1, t1, x_s5      # t1-=x
    add t1, t1, y_s6     # t1 += y
    slli t1, t1, 3      # t1<<3
    add t1, t1, p_s9      # t1 <- t1 + p_s9(p's base address)

    sd cnt_s7, 0(t1)        # p[x][y]=cnt
    addi cnt_s7, cnt_s7, 1

    addi i_t2, i_t2, 1
    jal zero, _for1
_for1_exit:
    addi len_s10, len_s10, -1
    addi i_t2, zero, 0
_for2:
    bge i_t2, len_s10, _for2_exit
    add x_s5, x_s5, turn_s8      # x = x+turn

    # Making p[x][y] address to t1
    addi t1, zero, 0    # t1 Initialize to zero
    slli t1, x_s5, 4      # t1 <- x<<4
    sub t1, t1, x_s5      # t1-=x
    add t1, t1, y_s6     # t1 += y
    slli t1, t1, 3      # t1<<3
    add t1, t1, p_s9      # t1 <- t1 + p_s9(p's base address)

    sd cnt_s7, 0(t1)        # p[x][y]=cnt
    addi cnt_s7, cnt_s7, 1

    addi i_t2, i_t2, 1
    jal zero, _for2
_for2_exit:
    sub turn_s8, zero, turn_s8    # negative
    jal zero, _while

_exit:
    ld a0, 0(sp)
    ld a1, 8(sp)
    ld ra, 16(sp)
    addi sp, sp, 24
    jalr zero, 0(ra)


#---------------------------------------------------------------------------
#	you can write your code here: END
#---------------------------------------------------------------------------
