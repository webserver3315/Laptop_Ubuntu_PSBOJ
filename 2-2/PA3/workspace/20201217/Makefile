all: pa3_client pa3_server

pa3_server: pa3_server.o
	gcc -o pa3_server pa3_server.o

pa3_server.o: pa3_server.c
	gcc -c -o pa3_server.o pa3_server.c

pa3_client: pa3_client.o
	gcc -o pa3_client pa3_client.o

pa3_client.o: pa3_client.c
	gcc -c -o pa3_client.o pa3_client.c

clean:
	rm *.o pa3_client pa3_server

