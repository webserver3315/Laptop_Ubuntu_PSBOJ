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

    addi s9, a0, 0      # s0 == p
    addi s1, a1, 0      # s1 == len
    addi s2, zero, 15   # s2 == 15 (MAX COLUMN)

    addi s5, zero, 0    # s5 == x
    addi s6, zero, -1   # s6 == y
    addi s7, zero, 1    # s7 == cnt
    addi s8, zero, 1    # s8 == turn

    # addi s0, s0, 200
    addi s1, s1, 100

_exit:
    ld a0, 0(sp)
    ld a1, 8(sp)
    ld ra, 16(sp)
    addi sp, sp, 24
    jalr zero, 0(ra)


#---------------------------------------------------------------------------
#	you can write your code here: END
#---------------------------------------------------------------------------
