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
    int n, serv_sock, clnt_sock, caddrlen;
    struct hostent* h;
    struct sockaddr_in saddr, caddr;
    char buf[MAXLINE];
    int port = atoi(argv[1]);

    if ((serv_sock = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
        printf("socker() failed.\n");
        exit(1);
    }
    memset((char*)&saddr, 0, sizeof(saddr));
    saddr.sin_family = AF_INET;
    saddr.sin_addr.s_addr = htonl(INADDR_ANY);
    saddr.sin_port = htons(port);

    if (bind(serv_sock, (struct sockaddr*)&saddr, sizeof(saddr)) < 0) {
        printf("bind() failed.\n");
        exit(2);
    }
    if (listen(serv_sock, 5) < 0) {
        printf("listen() failed.\n");
        exit(3);
    }
    while (1) {
        caddrlen = sizeof(caddr);
        // printf("\n\nNEW LOOP\n");
        if ((clnt_sock = accept(serv_sock, (struct sockaddr*)&caddr, (socklen_t*)&caddrlen)) < 0) {
            perror("accept() failed: ");
            continue;
        }

        char path[50];
        memset(path, 0, MAXLINE);
        n = read(clnt_sock, path, MAXLINE);
        // printf("path: \'%s\'\n", path);
        if (0 == strcmp("quit", path)) {
            printf("quit\n");
            exit(0);
        }
        strcat(path, "_copy\0");
        // printf("RECEIVING PATH: \'%s\'\n", path);

        int fdw = open(path, O_WRONLY | O_CREAT, 0644);
        if (fdw < 0) {
            perror("OPEN ERROR");
            exit(1);
        }
        // printf("WHILE ENTER\n");
        while ((n = read(clnt_sock, buf, MAXLINE)) > 0) {
            buf[n] = 0;
            printf("got %d bytes from client.\n", n);
            // printf("RECEIVING TRANSMISSION: \'%s\'\n", buf);
            write(fdw, buf, n);
        }
        if (n < 0) {
            perror("read error: ");
        }
        // printf("connection terminated.\n");
        close(clnt_sock);
        close(fdw);
    }
    close(serv_sock);
    return 0;
}