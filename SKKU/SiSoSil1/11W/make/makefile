
OBJ = obj/main.o obj/one.o obj/two.o

all: main

main: $(OBJ) lib/libthree.so
	gcc obj/main.o obj/one.o obj/two.o -L./lib -lthree -o main

obj/%.o: src/%.c
	gcc -c $< -o $@

lib/libthree.so: src/three.c
	gcc -shared src/three.c -o lib/libthree.so

clean:
	rm -f main lib/libthree.so obj/main.o obj/one.o obj/two.o
