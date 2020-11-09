pa2: main.o myutil.o
	gcc -o pa2 main.o myutil.o

main.o: main.c myutil.h
	gcc -c -o main.o main.c

myutil.o: myutil.h myutil.c
	gcc -c -o myutil.o myutil.c

clean:
	rm *.o pa2

