all: simpleshell

simpleshell: simpleshell.o
	gcc -o simpleshell simpleshell.o

simpleshell.o: simpleshell.c
	gcc -c -o simpleshell.o simpleshell.c

clean:
	rm *.o simpleshell