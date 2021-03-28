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
        mv s0, a0			# s0 <-- n

#---------------------------------------------------------------------------
#       you can write your code here: START
#---------------------------------------------------------------------------  
        beq s0, zero, ret             # if s0 == 0 goto ret
        addi t0, zero, 1
        beq s0, t0, ret               # elif s0 == 1 goto ret
        jal x0, recur                 # else goto recursive
recur:                                  
        addi s0, s0, -1                 # make s0-1
        addi a0, s0, 0
        jal ra, fibonacci               # fib(ra-1) 
        addi a1, a0, 0                  # store ret to a1
        addi s0, s0, -1
        addi a0, s0, 0
        jal ra, fibonacci               # fib(ra-1-1)
        addi 

END:
#---------------------------------------------------------------------------                     
#       you can write your code here: END
#---------------------------------------------------------------------------

        ld s0, 0(sp)			# restore s0 from stack
        ld ra, 8(sp)			# restore return address from stack
        addi sp, sp, 16			# restore stack pointer
        jalr x0, 0(ra)			# return to calling routine





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
        mv s0, a0			# s0 <-- n(a0)

#---------------------------------------------------------------------------
#       you can write your code here: START
#---------------------------------------------------------------------------  
        addi t1, zero, 1
        bgt a0, t1, L1                  # if greater than 1, goto L1
        addi a0, zero, 1                # ret=1
        addi sp, sp, 16                 # clear local variable
        jalr zero, 0(ra)                  # return ret
        

L1:
        addi a0, a0, -1
        add s0, a0, zero
        jalr ra, fibonacci
        addi s1, a0, -



END:
#---------------------------------------------------------------------------                     
#       you can write your code here: END
#---------------------------------------------------------------------------

        ld s0, 0(sp)			# restore s0 from stack
        ld ra, 8(sp)			# restore return address from stack
        addi sp, sp, 16			# restore stack pointer
        jalr x0, 0(ra)			# return to calling routine

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
        mv s0, a0			# s0 <-- n(a0)

#---------------------------------------------------------------------------
#       you can write your code here: START
#---------------------------------------------------------------------------  
        addi t1, zero, 1
        bgt a0, t1, ELSE
IF:
        addi sp, sp, 16
        jalr zero, 0(ra)

ELSE:
        addi sp, sp, -16                # make 2 stack room
        sd ra, 8(sp)
        sd s0, 0(sp)
        addi a0, s0, -1                 # n<-n-1
        jal ra, fibonacci               # call fibo(n-1)

        addi s5, a0, 0                  # s5 <- return value
        ld s0, 0(sp)
        ld ra, 8(sp)
        addi sp, sp, 16
        addi a0, s0, -2                 # a0 <- n-2
        jal ra, fibonacci               # call fibo(n-2)

        mul a0, a0, s5                  # ret = ret * s5
#---------------------------------------------------------------------------                     
#       you can write your code here: END
#---------------------------------------------------------------------------

        ld s0, 0(sp)			# restore s0 from stack
        ld ra, 8(sp)			# restore return address from stack
        addi sp, sp, 16			# restore stack pointer
        jalr zero, 0(ra)		# return to calling routine