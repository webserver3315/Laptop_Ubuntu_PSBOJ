#include <arpa/inet.h>
#include <errno.h>
#include <fcntl.h>
#include <netdb.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/select.h>
#include <sys/socket.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#define MAXLINE 128

typedef struct _query {
    int user;
    int action;
    int seat;
} query;

/*
Thread 가 아니라 CV 활용해서 멀티스레드 일단 구현
*/
int parse_query(query *q, char *msg) {
    char *order[MAXLINE];
    int order_cnt = 0;
    order[order_cnt++] = strtok(msg, " \t\n");
    while (order[order_cnt - 1] != NULL) {
        order[order_cnt] = strtok(NULL, " \t\n");
        if (order[order_cnt] == NULL)
            break;
        else
            order_cnt++;
    }
    order[order_cnt] = NULL;
    for (int i = 0; i < order_cnt; i++) {
        printf("order[%d]==\'%s\'\n", i, order[i]);
    }
    if (order_cnt != 3) {
        // printf("Invalid query\n");
        return -1;
    }
    q->user = atoi(order[0]);
    q->action = atoi(order[1]);
    q->seat = atoi(order[2]);
    return 0;
}

int main(int argc, char *argv[]) {
    // int sock = socket(PF_INET, SOCK_STREAM, 0);
    int sock, n;
    char *host = argv[1];
    int port = atoi(argv[2]);
    struct hostent *h;
    struct sockaddr_in saddr;
    int a1, a2, a3, input_fd;
    char msg[MAXLINE];

    if (argc == 3) {
        printf("Terminal input mode\n");
    } else if (argc == 4) {
        printf("File input mode\n");
        char *input_path = argv[3];
        printf("input_path = \'%s\'\n", input_path);
        input_fd = open(input_path, O_RDONLY);
        dup2(input_fd, STDIN_FILENO);
        close(input_fd);
    } else {
        printf("Follow the input rule below\n");
        printf("==================================================================\n");
        printf("argv[1]: server address, argv[2]: port number\n");
        printf("or\n");
        printf("argv[1]: server address, argv[2]: port number, argv[3]: input file\n");
        printf("==================================================================\n");
        exit(1);
    }

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
        printf("Connection failed\n");
        exit(1);
    }
    fd_set originalset, readset;
    FD_ZERO(&originalset); /* initialize socket set */
    FD_SET(STDIN_FILENO, &originalset);
    FD_SET(sock, &originalset);
    int fdmax = sock, fdnum;

    while (1) {
        query q;
        readset = originalset;
        fdnum = select(fdmax + 1, &readset, NULL, NULL, NULL);
        if (fdnum < 0) {
            printf("select() failed.\n");
            exit(4);
        }
        if (fdnum == 0) {
            // printf("Time out.\n");
            continue;
        }
        for (int i = 0; i < MAXLINE; i++) {
            msg[i] = 0;
        }

        for (int i = 0; i < fdmax + 1; i++) {
            if (!FD_ISSET(i, &readset)) {
                printf("%d fd SKIP\n", i);
                continue;
            }
            if (i == sock) {  // 서버로부터의 응답
                n = read(sock, &q, sizeof(query));
                int mode = q.action;
                int success = q.user;
                switch (mode) {
                    case 0:
                        if (q.action == 0 && q.seat == 0 && q.user == 0) {  // 서버로부터의 자살명령
                            printf("RECEIVED 0 0 0 from server\n");
                            close(sock);
                            exit(0);
                        }
                        break;
                    case 1:  // 1. Log in
                        if (success)
                            printf("Login success\n");
                        else
                            printf("Login failed\n");
                        break;
                    case 2:  //2. Reserve
                        if (success)
                            printf("Seat %d is reserved\n", q.seat);
                        else
                            printf("Reservation failed\n");
                        break;
                    case 3:  //3. Check reservation
                        if (success)
                            // printf("Reservation: %s\n");
                            printf("Reservation check success\n");
                        else
                            printf("Reservation check failed\n");
                        break;
                    case 4:  //4. Cancel reservation
                        if (success)
                            printf("Seat %d is canceled\n", q.seat);
                        else
                            printf("Cancel failed\n");
                        break;
                    case 5:  // 5. Log out
                        if (success)
                            printf("Logout success\n");
                        else
                            printf("Logout failed\n");
                        break;
                    default:
                        printf("switch error\n");
                        exit(0);
                }
            } else if (i == STDIN_FILENO) {  // 표준입력 또는 리다이렉션 표준입력이면
                if (read(STDIN_FILENO, msg, MAXLINE) < 0) {
                    printf("read error\n");
                    close(sock);
                    exit(1);
                }
                printf("Received msg = %s\n", msg);
                if (parse_query(&q, msg) != 0) {
                    printf("parse_query error\n");
                    continue;
                }

                if (write(sock, &q, sizeof(query)) < 0) {
                    printf("write error\n");
                    continue;
                }
                printf("SENT q == %d %d %d\n", q.user, q.action, q.seat);
            }
        }
    }

    close(sock);

    return 0;
}
