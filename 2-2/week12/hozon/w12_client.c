#include <arpa/inet.h>
#include <netdb.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/select.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <unistd.h>

#define MAXLINE 80
#define MAXCLNT 16

char name[10];

int main(int argc, char *argv[]) {
    int n, sock;
    struct hostent *h;
    struct sockaddr_in saddr;
    char buf[MAXLINE];
    char *host = argv[1];
    int port = atoi(argv[2]);

    printf("Insert your name : ");
    scanf("%s", name);
    printf("name == \'%s\'\n", name);

    if ((sock = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
        printf("socket() failed.\n");
        exit(1);
    }
    if ((h = gethostbyname(host)) == NULL) {
        printf("invalid hostname %s\n", host);
        exit(2);
    }
    memset((char *)&saddr, 0, sizeof(saddr));
    saddr.sin_family = AF_INET;
    memcpy((char *)&saddr.sin_addr.s_addr, (char *)h->h_addr, h->h_length);
    saddr.sin_port = htons(port);

    if (connect(sock, (struct sockaddr *)&saddr, sizeof(saddr)) < 0) {
        printf("connect() failed.\n");
        exit(3);
    }
    n = write(sock, name, strlen(name));

    fd_set originalset, readset;
    FD_ZERO(&originalset); /* initialize socket set */
    FD_SET(sock, &originalset);
    int fdmax = sock, fdnum;
    printf("fdmax: %d, sock: %d\n", fdmax, sock);
    while (1) {
        printf("HERE\n");
        readset = originalset;
        printf("HERE2\n");
        if ((fdnum = select(fdmax + 1, &readset, NULL, NULL, NULL)) < 0) {
            printf("select() failed.\n");
            exit(4);
        }
        printf("HERE3\n");
        if (fdnum == 0) {
            printf("Enter read\n");
            if ((n = read(STDIN_FILENO, buf, MAXLINE)) > 0) {
                if ((0 == strcmp("quit", buf)) || (0 == strcmp("quit\n", buf))) {
                    printf("got quit\n");
                    close(sock);
                    exit(0);
                }
                write(sock, buf, n);
                n = read(sock, buf, MAXLINE);
                write(1, buf, n);
            }
        } else {
            printf("HERE4\n");
            if (FD_ISSET(sock, &readset)) {
                printf("Enter FD_ISSET\n");
                if ((n = read(sock, buf, MAXLINE)) > 0) {
                    printf("n==%d\n", n);
                    buf[n++] = 0;
                    printf("buf == \'%s\'\n", buf);
                } else {
                    printf("ERROR\n");
                    exit(0);
                }
            }
        }
    }
    close(sock);

    return 0;
}