#-------------------------------------------------------------------------#
#
#SWE3005_42 Introduction of Computer Architecture(Spring 2021)
#
#Instructor :Prof.Tae Hee Han(than@skku.edu)
#
#Editor: Shim jae Eun(david4466@g.skku.com), Key Heon Lee (aemincrest@g.skku.edu)
#
#Description : Binary Search in RISC-V
#
#Copyright(C) 2021 SungKyunKwan University
#
#-------------------------------------------------------------------------#

.section .text
.globl binary_search




#------------------------------------------------------------
#                       binary_search function
#------------------------------------------------------------



#---------------------------------------------------------------------------
#	you can write your code here: START
#---------------------------------------------------------------------------

binary_search:
    # a0 <- point, a1 <- size, a2 <- target
    # s0 <- start, s1 <- mid, s2 <- end
    # t1 <- &point[mid], t2 <- (mid<<3), t3 <- point[mid]
    addi sp, sp, -32
    sd ra, 24(sp)
    sd s0, 16(sp)
    sd s1, 8(sp)
    sd s2, 0(sp)

    addi s0, zero, 0    # start <- 0
    addi s2, zero, 48   # end <- 48
    add s1, s0, s2      # mid <- (start+end)
    srli s1, s1, 1      # mid /= 2

_binary_search_while:
    blt s2, s0, _binary_search_exit_false   # if end < start , then goto exit_false
    add s1, s0, s2      # mid <- (start+end)
    srli s1, s1, 1      # mid /= 2
_binary_search_if:
    addi t1, zero, 0    # Initialize t1 to 0
    slli t2, s1, 3      # t2 <- (mid<<3)
    add t1, a0, t2      # t1 <- &point[mid]
    ld t3, 0(t1)        # t3 <- point[mid]
    beq a2, t3, _binary_search_exit_true    # if target == point[mid], then goto exit_true
    blt a2, t3, _binary_search_else         # if target < point[mid], goto else
_binary_search_elif:                        # ELSE IF
    addi s0, s1, 1                          # start <- mid + 1
    jal zero, _binary_search_while          # continue
_binary_search_else:                        # ELSE
    addi s2, s1, -1                         # end <- mid - 1
    jal zero, _binary_search_while          # continue

_binary_search_exit_true:
    addi a0, s1, 0      # ret <- mid
    jal zero, _binary_search_exit
_binary_search_exit_false:
    addi a0, zero, -1   # if NOT FOUND, return -1
    jal zero, _binary_search_exit
_binary_search_exit:
    ld s2, 0(sp)
    ld s1, 8(sp)
    ld s0, 16(sp)
    ld ra, 24(sp)
    addi sp, sp, 32
    jalr zero, 0(ra)








#---------------------------------------------------------------------------
#	you can write your code here: END
#---------------------------------------------------------------------------