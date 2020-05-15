# [ SWE2001 System Program spring 2020 ]
# [ HW2 - x86 assembly ]

CC = gcc
TARGET = all

all : fibo_c fibo_s

fibo_c :
	$(CC) fibo.c -o fibo_c

fibo_s :
	$(CC) -no-pie fibo.s -o fibo_s

clean :
	rm -f fibo_c fibo_s
