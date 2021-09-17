#SWE3005_42 Introduction of Computer Architecture(Spring 2021)
#
#Instructor :Prof.Tae Hee Han(than@skku.edu)
#
#Editor: Key Heon Lee (aemincrest@g.skku.edu)
#
#Description : Fibonacci Sequence in RISC-V
#
#Copyright(C) 2021 SungKyunKwan University
#
#-------------------------------------------------------------------------

.section .text
.globl fibonacci


#--------------------------------------------------------------------------
#                       fibonacci function
#--------------------------------------------------------------------------                      
fibonacci:
        addi sp, sp, -16		# make stack room for two
        sd ra, 8(sp)			# store return address
        sd s0, 0(sp)			# store s0
        addi s0, a0, 0			# s0 <-- n(a0)

#---------------------------------------------------------------------------
#       you can write your code here: START
#---------------------------------------------------------------------------  
#        addi a0, zero, 100
#        jal x0, END

        addi t1, zero, 1
        bgt s0, t1, ELSE
        addi a0, s0, 0
        #addi sp, sp, 16
        #jalr zero, 0(ra)
        jal zero, END

ELSE:
        addi s0, s0, -1                 # n<-n-1

        addi sp, sp, -8
        sd s0, 0(sp)
        addi a0, s0, 0
        jal ra, fibonacci               # call fibo(n-1)
        ld s0, 0(sp)
        addi sp, sp, 8

        addi s5, a0, 0
        addi s0, s0, -1

        addi sp, sp, -8
        sd s5, 0(sp)
        addi a0, s0, 0
        jal ra, fibonacci
        ld s5, 0(sp)
        addi sp, sp, 8

        add a0, a0, s5                  # s5 <- f(n-1), a0 <- f(n-2)

END:
#---------------------------------------------------------------------------                     
#       you can write your code here: END
#---------------------------------------------------------------------------
        ld s0, 0(sp)			# restore s0 from stack
        ld ra, 8(sp)			# restore return address from stack
        addi sp, sp, 16			# restore stack pointer
        jalr zero, 0(ra)		# return to calling routine
