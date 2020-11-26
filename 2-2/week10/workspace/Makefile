all: w10_client w10_server

w10_server: w10_server.o
	gcc -o w10_server w10_server.o

w10_server.o: w10_server.c
	gcc -c -o w10_server.o w10_server.c

w10_client: w10_client.o
	gcc -o w10_client w10_client.o

w10_client.o: w10_client.c
	gcc -c -o w10_client.o w10_client.c

clean:
	rm *.o w10_client w10_server

