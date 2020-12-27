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
#define FALSE 0
#define TRUE 1

int client_fd[MAXCLNT];  //client_fd[1]=4, client_fd[2]=5, ...
int client_exist[MAXCLNT];
char *client_name[MAXCLNT];
int client_num;

void send_all(int except, char *msg) {
    char full_message[128] = {0};
    strcat(full_message, client_name[except]);
    strcat(full_message, ":");
    strcat(full_message, msg);
    strcat(full_message, "\0");
    printf("Send message: \'%s\'\n", full_message);
    for (int i = 4; i < 15; i++) {
        if (!client_exist[i] || i == except) {
            continue;
        }
        printf("Sending to %d\n", i);
        write(i, full_message, strlen(full_message));
    }
}

int main(int argc, char *argv[]) {
    int n, serv_sock, clnt_sock, caddrlen;
    struct hostent *h;
    struct sockaddr_in saddr, caddr;
    char buf[MAXLINE];
    int port = atoi(argv[1]);
    for (int i = 0; i < MAXCLNT; i++) {
        client_name[i] = malloc(sizeof(char) * MAXCLNT);
        client_name[i][0] = 0;
    }

    if ((serv_sock = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
        printf("socket() failed.\n");
        exit(1);
    }

    memset((char *)&saddr, 0, sizeof(saddr));
    saddr.sin_family = AF_INET;
    saddr.sin_addr.s_addr = htonl(INADDR_ANY);
    saddr.sin_port = htons(port);

    if (bind(serv_sock, (struct sockaddr *)&saddr, sizeof(saddr)) < 0) {
        printf("bind() failed.\n");
        exit(2);
    }

    if (listen(serv_sock, 5) < 0) {
        printf("listen() failed.\n");
        exit(3);
    }

    fd_set originalset, readset;
    FD_ZERO(&originalset); /* initialize socket set */
    FD_SET(serv_sock, &originalset);
    int fdmax = serv_sock, fdnum;

    while (1) {
        readset = originalset;
        if ((fdnum = select(fdmax + 1, &readset, NULL, NULL, NULL)) < 0) {
            printf("select() failed.\n");
            exit(4);
        }
        if (fdnum == 0) {
            printf("Time out.\n");
            continue;
        }

        // printf("***Here***\n");
        for (int i = 0; i < fdmax + 1; i++) {
            if (!FD_ISSET(i, &readset)) {
                continue;
            }
            if (i == serv_sock) {
                caddrlen = sizeof(caddr);
                if ((clnt_sock = accept(serv_sock, (struct sockaddr *)&caddr, (socklen_t *)&caddrlen)) < 0) {
                    printf("accept() failed.\n");
                    continue;
                }
                FD_SET(clnt_sock, &originalset);
                client_exist[clnt_sock] = TRUE;
                client_num++;
                n = read(clnt_sock, client_name[clnt_sock], MAXLINE);
                client_name[clnt_sock][n++] = 0;
                printf("%d USER \'%s\' added, %d/10\n", clnt_sock, client_name[clnt_sock], client_num);
                if (fdmax < clnt_sock) {
                    fdmax = clnt_sock;
                }
            } else {
                if ((n = read(i, buf, MAXLINE)) > 0) {
                    printf("got %d bytes from %dth file descriptor \'%s\'.\n", n, i, client_name[i]);
                    // printf("%s: \'%s\'\n", client_name[i], buf);
                    if ((0 == strcmp("quit", buf)) || (0 == strcmp("quit\n", buf))) {
                        printf("quit\n");
                        FD_CLR(i, &originalset);
                        printf("%d USER \'%s\' leaved, %d/10\n", i, client_name[i], client_num);
                        client_exist[i] = FALSE;
                        client_num--;
                        client_name[i][0] = 0;
                        close(i);
                    }
                    write(i, buf, n);
                    send_all(i, buf);
                    continue;
                } else {
                    FD_CLR(i, &originalset);
                    printf("%d USER \'%s\' leaved, %d/10\n", i, client_name[i], client_num);
                    client_exist[i] = FALSE;
                    client_num--;
                    client_name[i][0] = 0;
                    close(i);
                }
            }
        }
    }

    for (int i = 0; i < MAXCLNT; i++) {
        free(client_name[i]);
    }
    return 0;
}
