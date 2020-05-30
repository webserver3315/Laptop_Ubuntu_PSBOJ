
OBJ = src/one.o src/two.o src/three.o

all: main

main: $(OBJ) src/main.o src/one.o src/two.o src/three.o
	gcc src/main.o src/one.o src/two.o src/three.o -o main

obj/%.o: src/%.c
	gcc -c $< -o $@

clean:
	rm -f main src/one.o src/two.o src/three.o
