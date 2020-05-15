# [ SWE2001 System Program spring 2020 ]
# [ HW2 - x86 assembly ]

CC = gcc
TAR = tar
TARGET = all
STUDENT_ID = 2019000000
.PHONY: subdir $(SUBDIRS)
SUBDIRS = ./example ./pa2-1 ./pa2-2 ./pa2-3

all : tar input_generator
	for DIRS in $(SUBDIRS); do\
		$(MAKE) -C $$DIRS;\
	done

tar : 
	$(TAR) -cvzf $(STUDENT_ID).tar.gz pa2-1/gl.s pa2-2/fibo.s pa2-3/maze.s

input_generator:
	$(CC) input_generator.c -o input_generator

clean :
	rm -f *.tar.gz
	rm -f input_generator
	for DIRS in $(SUBDIRS); do\
		$(MAKE) -C $$DIRS clean;\
	done
