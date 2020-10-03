# [ SWE2001 System Program spring 2020 ]
# [ HW2 - x86 assembly ]

CC = gcc
TAR = tar
TARGET = all

all : example_c example_s

example_c:
	$(CC) example.c -o example_c

example_s :
	$(CC) -no-pie example.s -o example_s

clean :
	rm -f example_c example_s
