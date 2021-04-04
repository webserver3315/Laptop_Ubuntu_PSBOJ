all: result quicksort.o

result: main.c quicksort.o
	riscv64-unknown-elf-gcc -o result quicksort.o main.c

quicksort.o: hw1-3-function-1.S
	riscv64-unknown-elf-as -o quicksort.o hw1-3-function-1.S

clean:
	rm *.o result