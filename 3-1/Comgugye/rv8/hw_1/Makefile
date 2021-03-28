all: result function.o

result: main.c function.o
	riscv64-unknown-elf-gcc -o result function.o main.c

function.o: main.c
	riscv64-unknown-elf-as -o function.o hw1-1-function.S

clean:
	rm *.o result
