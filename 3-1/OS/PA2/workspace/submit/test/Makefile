
all: pa2 head tail cat cp mv rm pwd

pa2: minishell.o
	gcc -o pa2 minishell.o

minishell.o: minishell.c
	gcc -c -o minishell.o minishell.c

head: head.o
	gcc -o head head.o

head.o: head.c
	gcc -c -o head.o head.c

tail: tail.o
	gcc -o tail tail.o

tail.o: tail.c
	gcc -c -o tail.o tail.c

cat: cat.o
	gcc -o cat cat.o

cat.o: cat.c
	gcc -c -o cat.o cat.c

cp: cp.o
	gcc -o cp cp.o

cp.o: cp.c
	gcc -c -o cp.o cp.c

mv: mv.o
	gcc -o mv mv.o

mv.o: mv.c
	gcc -c -o mv.o mv.c

rm: rm.o
	gcc -o rm rm.o

rm.o: rm.c
	gcc -c -o rm.o rm.c

pwd: pwd.o
	gcc -o pwd pwd.o

pwd.o: pwd.c
	gcc -c -o pwd.o pwd.c


clean:
	rm *.o pa2

