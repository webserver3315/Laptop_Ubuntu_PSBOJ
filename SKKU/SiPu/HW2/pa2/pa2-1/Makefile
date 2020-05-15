# [ SWE2001 System Program spring 2020 ]
# [ HW2 - x86 assembly ]

CC = gcc
TARGET = all

all : gl_c gl_s

gl_c :
	$(CC) gl.c -o gl_c

gl_s :
	$(CC) -no-pie gl.s -o gl_s

clean :
	rm -f gl_c gl_s
