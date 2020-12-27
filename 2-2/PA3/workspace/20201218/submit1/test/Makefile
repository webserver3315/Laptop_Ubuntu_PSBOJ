all: pa3_client pa3_server

pa3_server: pa3_server.o
	gcc -o pa3_server pa3_server.o -lpthread

pa3_server.o: pa3_server.c
	gcc -c -o pa3_server.o pa3_server.c -lpthread

pa3_client: pa3_client.o
	gcc -o pa3_client pa3_client.o -lpthread

pa3_client.o: pa3_client.c
	gcc -c -o pa3_client.o pa3_client.c -lpthread

clean:
	rm *.o pa3_client pa3_server

