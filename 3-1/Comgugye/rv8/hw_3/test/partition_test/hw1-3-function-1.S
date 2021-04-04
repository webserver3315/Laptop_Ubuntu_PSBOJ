#-------------------------------------------------------------------------#
#
#SWE3005_42 Introduction of Computer Architecture(Spring 2021)
#
#Instructor :Prof.Tae Hee Han(than@skku.edu)
#
#Editor: Shim jae Eun(david4466@g.skku.com), Key Heon Lee (aemincrest@g.skku.edu)
#
#Description : Quicksort in RISC-V
#
#Copyright(C) 2021 SungKyunKwan University
#
#-------------------------------------------------------------------------#

.section .text
.globl partition

#-------------------------------------------------------------------------#
#                       function swap: START                              #
#-------------------------------------------------------------------------#
swap:   # Callee Saved Register 를 전혀 쓰지 않으므로, Caller가 알아서 저장했다는걸 전제한다.
    slli t1, a1, 3
    add t1, t1, a0
    ld t3, 0(t1)

    slli t2, a2, 3
    add t2, t2, a0
    ld t4, 0(t2)

    sd t3, 0(t2)
    sd t4, 0(t1)
    jalr zero, 0(ra)

#-------------------------------------------------------------------------#
#                       function swap: END                                #
#-------------------------------------------------------------------------#




#-------------------------------------------------------------------------#
#                       function partition: START                         #
#-------------------------------------------------------------------------#
partition: 
    # a0 <- arr, a1 <- low, a2 <- high
    # s1 <- pivot, s2 <- i, s3 <- j
    addi t1, zero, 0    # t1 <- 0
    slli t1, a2, 3      # t1 <- high << 3
    add t1, t1, a0      # t1 <- &arr[high]
    ld t2, 0(t1)        # t2 <- arr[high]
    addi s1, t2, 0      # pivot = arr[high]

    addi s2, a1, -1     # i = low-1
    addi s3, a1, 0      # j = low

_partition_forloop:
    addi t3, zero, 0    # t3 Initialize to 0
    slli t3, s3, 3      # t3 <- j<<3
    add t3, t3, a0      # t3 <- &arr[j]
    ld t4, 0(t3)        # t4 <- arr[j]
    
    blt s1, t4, _partition_else     # if pivot < arr[j], then don't call swap

    # Calling swap(arr, i, j)
    addi s2, s2, 1      # i+=1
    addi sp, sp, -64
    sd ra, 56(sp)
    sd a0, 48(sp)
    sd a1, 40(sp)
    sd a2, 32(sp)
    sd t1, 24(sp)
    sd t2, 16(sp)
    sd t3, 8(sp)
    sd t4, 0(sp)
    addi a1, s2, 0                  # 1st argument is i
    addi a2, s3, 0                  # 2nd argument is j (0th is arr)
    jal ra, swap
    ld t4, 0(sp)
    ld t3, 8(sp)
    ld t2, 16(sp)
    ld t1, 24(sp)
    ld a2, 32(sp)
    ld a1, 40(sp)
    ld a0, 48(sp)
    ld ra, 56(sp)
    addi sp, sp, 64

_partition_else:
    addi s3, s3, 1                  # j+=1  
    blt s3, a2, _partition_forloop  # j < high => loop again

    # Partition For Loop Exit: Last Swap Call
    addi sp, sp, -64
    sd ra, 56(sp)
    sd a0, 48(sp)
    sd a1, 40(sp)
    sd a2, 32(sp)
    sd t1, 24(sp)
    sd t2, 16(sp)
    sd t3, 8(sp)
    sd t4, 0(sp)
    addi a1, s2, 1                  # 1st argument is i+1 (2nd argument is high)

    jal ra, swap
    ld t4, 0(sp)
    ld t3, 8(sp)
    ld t2, 16(sp)
    ld t1, 24(sp)
    ld a2, 32(sp)
    ld a1, 40(sp)
    ld a0, 48(sp)
    ld ra, 56(sp)
    addi sp, sp, 64


    addi a0, s2, 1
    jalr zero, 0(ra)        # return (i+1)

    

#-------------------------------------------------------------------------#
#                       function partition: END                           #
#-------------------------------------------------------------------------#




#-------------------------------------------------------------------------#
#                       function quick_sort: START                        #
#-------------------------------------------------------------------------#
quick_sort:
    # a0 <- arr, a1 <- low, a2 <- high
    # t1 <- pi
    bge a1, a2, _quick_sort_else        # a1 >= a2, go else
    addi sp, sp, -40
    sd ra, 32(sp)
    sd a0, 24(sp)
    sd a1, 16(sp)
    sd a2, 8(sp)
    sd t1, 0(sp)
    jal ra, partition       # 0th, 1st, 2nd == arr, low, high
    ld t1, 0(sp)
    ld a2, 8(sp)
    ld a1, 16(sp)
    ld a0, 24(sp)
    ld ra, 32(sp)
    addi sp, sp, 40

    addi t1, a0, 0          # pi <- ret

    addi sp, sp, -40
    sd ra, 32(sp)
    sd a0, 24(sp)
    sd a1, 16(sp)
    sd a2, 8(sp)
    sd t1, 0(sp)            
    addi a2, t1, -1         # 2nd argument <- (pi-1)
    jal ra, quick_sort      # 0th, 1st, 2nd == arr, low, pi - 1
    ld t1, 0(sp)
    ld a2, 8(sp)
    ld a1, 16(sp)
    ld a0, 24(sp)
    ld ra, 32(sp)
    addi sp, sp, 40

    addi sp, sp, -40
    sd ra, 32(sp)
    sd a0, 24(sp)
    sd a1, 16(sp)
    sd a2, 8(sp)
    sd t1, 0(sp)            
    addi a1, t1, -1         # 1st argument <- (pi-1)
    jal ra, quick_sort      # 0th, 1st, 2nd == arr, pi-1, high
    ld t1, 0(sp)
    ld a2, 8(sp)
    ld a1, 16(sp)
    ld a0, 24(sp)
    ld ra, 32(sp)
    addi sp, sp, 40

_quick_sort_else:
    jalr zero, 0(ra)


#-------------------------------------------------------------------------#
#                       function quick_sort: END                          #
#-------------------------------------------------------------------------#