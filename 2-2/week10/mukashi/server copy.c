#include <arpa/inet.h>
#include <fcntl.h>  // O_WRONLY
#include <netdb.h>
#include <stdio.h>  // printf()
#include <stdlib.h>
#include <string.h>  // strlen()
#include <sys/socket.h>
#include <sys/types.h>
#include <unistd.h>  // write(), close()
#define MAXLINE 80

int main(int argc, char* argv[]) {
    int n, listenfd, connfd, caddrlen;
    struct hostent* h;
    struct sockaddr_in saddr, caddr;
    char buf[MAXLINE];
    int port = atoi(argv[1]);

    if ((listenfd = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
        printf("socker() failed.\n");
        exit(1);
    }
    memset((char*)&saddr, 0, sizeof(saddr));
    saddr.sin_family = AF_INET;
    saddr.sin_addr.s_addr = htonl(INADDR_ANY);
    saddr.sin_port = htons(port);

    if (bind(listenfd, (struct sockaddr*)&saddr, sizeof(saddr)) < 0) {
        printf("bind() failed.\n");
        exit(2);
    }
    if (listen(listenfd, 5) < 0) {
        printf("listen() failed.\n");
        exit(3);
    }
    if ((connfd = accept(listenfd, (struct sockaddr*)&caddr, (socklen_t*)&caddrlen)) < 0) {
        perror("accept() failed: ");
        // continue;
    }
    while (1) {
        caddrlen = sizeof(caddr);
        printf("\n\nNEW LOOP\n");

        char path[50];
        n = read(connfd, buf, MAXLINE);
        if (n < 0) {
            perror("read error: ");
            exit(1);
        }
        strcpy(path, buf);
        path[strlen(path) - 1] = '\0';
        strcat(path, "_copy\0");
        printf("RECEIVING PATH: \'%s\'\n", path);

        // printf("buf: \'%s\'\n", buf);
        // printf("path: \'%s\'\n", path);
        if (0 == strcmp("quit", path)) {
            printf("quit\n");
            exit(0);
        }

        int fdw = open(path, O_RDWR | O_CREAT, 0644);
        if (fdw < 0) {
            perror("OPEN ERROR");
            exit(1);
        }
        printf("WHILE ENTER\n");
        memset(buf, 0, MAXLINE);
        while ((n = read(connfd, buf, MAXLINE)) > 0) {
            printf("got %d bytes from client.\n", n);
            printf("RECEIVING TRANSMISSION: \'%s\'\n", buf);
            // write(connfd, buf, n);
            write(fdw, buf, n);
            memset(buf, 0, MAXLINE);
        }
        if (n < 0) {
            perror("read error: ");
        }
        if (n == 0) {
            printf("No Readable Text\n");
        }
        printf("connection terminated.\n");
        close(connfd);
        close(fdw);
    }
    close(listenfd);
    return 0;
}