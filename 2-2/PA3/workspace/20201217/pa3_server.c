#include <arpa/inet.h>
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#define MAXUSER 1024
#define MAXSEAT 256
#define MAXLINE 128
#define ORDERKAZU 5

int user[MAXUSER];             // -1: 오프라인, 0,1,2,3..: 접속중인 클라이언트 번호
int client_occupant[MAXUSER];  // -1: 빈컴퓨터, 0,1,2,3..: 이 클라이언트를 사용중인 User ID
int client_fd[MAXUSER];        // 현재 클라이언트가 몇 번째 fd를 사용중인지, -1: None

int password[MAXUSER];           // password[idx] = idx 번째 user 의 비밀번호
int seat[MAXSEAT];               // 0: 공석, 1: 예약
pthread_mutex_t mutex[MAXSEAT];  // i번째 자리를 누가 편집중인지의 여부를 나타낸다.
int client_num;

typedef struct _query {
    int user;
    int action;
    int seat;
} query;

int login(int usernum, int passwd) {
}
int reserve(int usernum, int seatnum) {
}
int check_reservation(int seatnum) {
}
int cancel_reservation(int seatnum) {
}
int logout(int usernum) {
}

int find_lowest_fd() {
    for (int i = 1; i < MAXUSER; i++) {
        if (client_fd[i] == -1)
            return i;
    }
    return -1;
}

void initialize() {
    for (int i = 0; i < MAXUSER; i++) {
        user[i] = -1;
        client_occupant[i] = -1;
        client_fd[i] = -1;
        password[i] = -1;
    }
}

/*
Thread 가 아니라 CV 활용해서 멀티스레드 일단 구현
*/
int main(int argc, char *argv[]) {
    int n, serv_sock, clnt_sock, caddrlen;
    struct sockaddr_in saddr, caddr;
    initialize();

    if ((serv_sock = socket(PF_INET, SOCK_STREAM, 0)) < 0) {
        printf("socket() failed\n");
        exit(1);
    }
    memset((char *)&saddr, 0, sizeof(saddr));
    saddr.sin_family = AF_INET;
    saddr.sin_addr.s_addr = htons(INADDR_ANY);
    saddr.sin_port = htons(atoi(argv[1]));

    if (bind(serv_sock, (struct sockaddr *)&saddr, sizeof(saddr)) < 0) {
        printf("bind() failed\n");
        exit(1);
    }
    if (listen(serv_sock, 1024) < 0) {
        printf("listen() failed\n");
        exit(1);
    }

    fd_set originalset, readset;
    FD_ZERO(&originalset);
    FD_SET(serv_sock, &originalset);
    int fdmax = serv_sock;
    int fdnum;
    client_fd[0] = serv_sock;

    /* You should generate thread when new client accept occurs
     and process query of client until get termination query */
    while (1) {
        readset = originalset;
        if ((fdnum = select(fdmax + 1, &readset, NULL, NULL, NULL)) < 0) {
            printf("select() failed.\n");
            exit(1);
        }
        if (fdnum == 0) {
            printf("Time out\n");
        }
        printf("\n");
        for (int idx = 0; idx <= fdmax; idx++) {
            int fd = client_fd[idx];
            if (fd == -1) {
                printf("client_fd[%d] = %d SKIP: fd == -1\n", idx, fd);
                continue;
            }
            if (!FD_ISSET(fd, &readset)) {
                printf("client_fd[%d] = %d SKIP: NO FD_ISSET\n", idx, fd);
                continue;
            }
            if (fd == serv_sock) {  // 서버 소켓이면
                printf("client_fd[%d] = %d ENTER: SERV_SOCK\n", idx, fd);
                caddrlen = sizeof(caddr);
                if ((clnt_sock = accept(serv_sock, (struct sockaddr *)&caddr, (socklen_t *)&caddrlen)) < 0) {
                    printf("accept() failed\n");
                    continue;
                }
                FD_SET(clnt_sock, &originalset);
                int next = find_lowest_fd();
                client_fd[next] = clnt_sock;
                client_num++;
                if (fdmax < clnt_sock) {
                    fdmax = clnt_sock;
                }
            } else {  //클라이언트 소켓이면
                query q;
                printf("client_fd[%d] = %d ENTER: CLIENT_SOCK\n", idx, fd);
                if ((n = read(fd, &q, sizeof(q))) > 0) {
                    printf("RECEIVED q == %d %d %d\n", q.user, q.action, q.seat);
                    if (q.user == 0 && q.action == 0 && q.seat == 0) {  // 클라이언트에 exit 허가 보내고 삭제
                        FD_CLR(fd, &originalset);
                        client_occupant[idx] = -1;
                        client_fd[idx] = -1;
                        client_num--;
                        close(fd);
                    }
                }
            }
        }
    }

    return 0;
}
