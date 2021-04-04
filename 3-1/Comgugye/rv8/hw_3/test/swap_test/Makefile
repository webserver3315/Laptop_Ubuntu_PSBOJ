all: result quicksort.o

result: main_test.c quicksort.o
	riscv64-unknown-elf-gcc -o result quicksort.o main_test.c

quicksort.o: hw1-3-function-1.S
	riscv64-unknown-elf-as -o quicksort.o hw1-3-function-1.S

clean:
	rm *.o result

# all: result quicksort.o binarysearch.o

# result: main_test.c quicksort.o binarysearch.o
# 	riscv64-unknown-elf-gcc -o result quicksort.o binarysearch.o main_test.c

# quicksort.o: hw1-3-function-1.S
# 	riscv64-unknown-elf-as -o quicksort.o hw1-3-function-1.S

# binarysearch.o: hw1-3-function-2.S
# 	riscv64-unknown-elf-as -o binarysearch.o hw1-3-function-2.S

# clean:
# 	rm *.o result