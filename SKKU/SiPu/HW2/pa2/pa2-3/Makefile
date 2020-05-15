# [ SWE2001 System Program spring 2020 ]
# [ HW2 - x86 assembly ]

CC = gcc
TARGET = all

all : maze_c maze_s

maze_c :
	$(CC) maze.c main.c -o maze_c

maze_s :
	$(CC) -no-pie maze.s main.c -o maze_s

clean :
	rm -f maze_c maze_s
