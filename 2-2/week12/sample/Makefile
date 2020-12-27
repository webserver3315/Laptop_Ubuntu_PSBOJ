
all: echo_client echo_server mp_server mt_server mux_server

echo_client: echo_client.o
	gcc -o echo_client echo_client.o

echo_client.o: echo_client.c
	gcc -c -o echo_client.o echo_client.c

echo_server: echo_server.o
	gcc -o echo_server echo_server.o

echo_server.o: echo_server.c
	gcc -c -o echo_server.o echo_server.c

mp_server: mp_server.o
	gcc -o mp_server mp_server.o

mp_server.o: mp_server.c
	gcc -c -o mp_server.o mp_server.c

mt_server: mt_server.o
	gcc -o mt_server mt_server.o -lpthread

mt_server.o: mt_server.c
	gcc -c -o mt_server.o mt_server.c -lpthread

mux_server: mux_server.o
	gcc -o mux_server mux_server.o

mux_server.o: mux_server.c
	gcc -c -o mux_server.o mux_server.c


clean:
	rm *.o

