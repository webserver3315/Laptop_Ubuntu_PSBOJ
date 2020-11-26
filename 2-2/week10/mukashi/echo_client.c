#include <arpa/inet.h>
#include <netdb.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <unistd.h>
#define MAXLINE 80

int main(int argc, char* argv[]) {
    int n, sock;
    struct hostent* h;
    struct sockaddr_in saddr;
    char buf[MAXLINE];
    char* host = argv[1];
    int port = atoi(argv[2]);
    if ((sock = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
        printf("socket() faild.\n");
        exit(1);
    }
    if ((h = gethostbyname(host)) == NULL) {
        printf("invalid hostname %s\n", host);
        exit(2);
    }
    memset((char*)&saddr, 0, sizeof(saddr));
    saddr.sin_family = AF_INET;
    memcpy((char*)&saddr.sin_addr.s_addr, (char*)h->h_addr, h->h_length);
    saddr.sin_port = htons(port);

    if (connect(sock, (struct sockaddr*)&saddr, sizeof(saddr)) < 0) {
        printf("connect() failed\n");
        exit(3);
    }
    while ((n = read(0, buf, MAXLINE)) > 0) {
        write(sock, buf, n);
        n = read(sock, buf, MAXLINE);
        write(1, buf, n);
    }
    close(sock);
}