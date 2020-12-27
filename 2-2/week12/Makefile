all: w12_server w12_client

w12_server: w12_server.o
	gcc -Wall -o w12_server w12_server.o -lpthread

w12_server.o: w12_server.c
	gcc -c -o w12_server.o w12_server.c
	
w12_client: w12_client.o
	gcc -Wall -o w12_client w12_client.o -lpthread

w12_client.o: w12_client.c
	gcc -c -o w12_client.o w12_client.c

clean:
	rm *.o w12_server w12_client

