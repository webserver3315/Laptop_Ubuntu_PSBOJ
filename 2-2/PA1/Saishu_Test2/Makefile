# Makefile

# myutil_stl.c
# pa1: main.o mystring.o myutil.o
# 	gcc -o pa1 main.o mystring.o myutil.o

# main.o: main.c mystring.h
# 	gcc -c -o main.o main.c

# mystring.o: mystring.h mystring.c
# 	gcc -c -o mystring.o mystring.c

# myutil_stl.o: myutil_stl.h myutil.c
# 	gcc -c -o myutil.o myutil.c

# clean:
# 	rm *.o pa1


pa1: main.o mystring.o myutil.o
	gcc -o pa1 main.o mystring.o myutil.o

main.o: main.c mystring.h
	gcc -c -o main.o main.c

mystring.o: mystring.h mystring.c
	gcc -c -o mystring.o mystring.c

myutil.o: myutil.h myutil.c
	gcc -c -o myutil.o myutil.c

clean:
	rm *.o pa1

