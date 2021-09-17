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
    addi sp, sp, -24    # saving three element
    sd ra, 16(sp)
    sd a1, 8(sp)
    sd a0, 0(sp)

    addi s1, a0, 0      # s1 == p
    addi s2, a1, 0     # s2 == len
    addi s8, a1, 0   # s8 == len (MAX COLUMN)

    addi s4, zero, 0    # s4 == x
    addi s5, zero, -1   # s5 == y
    addi s6, zero, 1    # s6 == cnt
    addi s7, zero, 1    # s7 == turn

_while:
    blt s2, zero, _exit # Checking if it can exit while loop

    addi s3, zero, 0    # s3 == i <- 0
_for1:
    bge s3, s2, _for1_exit  # Check if it can exit for1 loop
    add s5, s5, s7      # y = y+turn
    
    # Making p[x][y] address to t1
    # 주소: p + 15*8*x + 8*y => (15*x)+y => (((x<<4)-x))+y)<<3 + p
    addi t1, zero, 0    # t1 Initialize to zero
    slli t1, s4, 4      # t1 <- x<<4
    sub t1, t1, s4      # t1-=x
    add t1, t1, s5     # t1 += y
    slli t1, t1, 3      # t1<<3
    add t1, t1, s1      # t1 <- t1 + s1(p's base address)

    sd s6, 0(t1)        # p[x][y]=cnt
    addi s6, s6, 1

    addi s3, s3, 1
    jal zero, _for1     # goto _for1
_for1_exit:             # exitted _for1, and prepare _for2
    addi s2, s2, -1
    addi s3, zero, 0
_for2:
    bge s3, s2, _for2_exit      # Check if it can exit for2 loop
    add s4, s4, s7      # x = x+turn

    # Making p[x][y] address to t1
    addi t1, zero, 0    # t1 Initialize to zero
    slli t1, s4, 4      # t1 <- x<<4
    sub t1, t1, s4      # t1-=x
    add t1, t1, s5     # t1 += y
    slli t1, t1, 3      # t1<<3
    add t1, t1, s1      # t1 <- t1 + s1(p's base address)

    sd s6, 0(t1)        # p[x][y]=cnt
    addi s6, s6, 1

    addi s3, s3, 1
    jal zero, _for2
_for2_exit:
    sub s7, zero, s7    # negative -> turn=turn*-1
    jal zero, _while    # goto while

_exit:
    ld a0, 0(sp)        # Restore Registor to First state
    ld a1, 8(sp)
    ld ra, 16(sp)
    addi sp, sp, 24
    jalr zero, 0(ra)    # Go back to caller


#---------------------------------------------------------------------------
#	you can write your code here: END
#---------------------------------------------------------------------------
