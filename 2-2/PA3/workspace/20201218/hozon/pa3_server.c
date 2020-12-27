#include <arpa/inet.h>
#include <errno.h>
#include <fcntl.h>
#include <pthread.h>
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

int fd2client[MAXUSER];    // -1: 빈tid, 1,2,3...: 이 tid를 사용중인 User
int client2fd[MAXUSER];    // -1: 빈tid, 1,2,3...: 이 tid를 사용중인 User
int client2user[MAXUSER];  // -1: 오프라인, 0,1,2,3..: 접속중인 tid 번호
int user2client[MAXUSER];  // -1: 오프라인, 0,1,2,3..: 접속중인 tid 번호
pthread_t tid[MAXUSER];

int password[MAXUSER];           // password[idx] = idx 번째 user 의 비밀번호
int seat[MAXSEAT];               // 0: 공석, 1: 예약
pthread_mutex_t mutex[MAXSEAT];  // i번째 자리를 누가 편집중인지의 여부를 나타낸다.
int client_num;

typedef struct _query {
    int user;
    int action;
    int seat;
} query;

typedef struct _argument {
    int thread_num;
    int client_socket;
} argument;

/*
CV based 를 Thread Based 로 바꿔야 함.

fd랑 cli 분리해서 유지하는 안.
cli+4=fd 로 취급가능하다는 생각이 들어서 일단 임시저장 후 발상 착수함.
*/

int login(int usernum, int passwd) {
    printf("LOGIN: usernum: %d, passwd: %d\n", usernum, passwd);
}
int reserve(int usernum, int seatnum) {
    printf("RESERAVE: usernum: %d, seatnum: %d\n", usernum, seatnum);
}
int check_reservation(int seatnum) {
    printf("RESERAVE: seatnum: %d\n", seatnum);
}
int cancel_reservation(int seatnum) {
    printf("RESERAVE: seatnum: %d\n", seatnum);
}
int logout(int usernum) {
    printf("RESERAVE: usernum: %d\n", usernum);
}

int find_available_thread() {
    for (int i = 0; i < MAXUSER; i++) {
        if (tid_using[i] == -1)
            return i;
    }
    return -1;
}

void initialize() {
    for (int i = 0; i < MAXUSER; i++) {
        user[i] = -1;
        tid_using[i] = -1;
        password[i] = -1;
    }
    for (int i = 0; i < MAXSEAT; i++) {
        pthread_mutex_init(&mutex[i], NULL);
    }
}

void *thread_func(void *arg) {
    int n;
    query q;
    argument arg2 = *((argument *)arg);
    int thread_num = arg2.thread_num;
    int client_sock2 = arg2.client_socket;
    // int client_sock2 = *((int *)arg);
    pthread_detach(pthread_self());
    free(arg);
    printf("THEAD_NUM: %d, CLIENT_SOCK2: %d\n", thread_num, client_sock2);
    while (1) {
        if ((n = read(client_sock2, &q, sizeof(query)) < 0)) {
            printf("read ERROR\n");
            continue;
        }
        int mode = q.action;
        switch (mode) {
            case 0:
                if (q.user == 0 && q.action == 0 && q.seat == 0) {  // CLIENT EXIT
                }
                break;
            case 1:
                int usernum = q.user;
                int passwd = q.seat;
                int result = login(usernum, passwd);
                break;
            case 2:
                int usernum = q.user;
                int seatnum = q.seat;
                int result = reserve(usernum, seatnum);
                break;
            case 3:
                int seatnum = q.seat;
                int result = check_reservation(seatnum);
                break;
            case 4:
                int seatnum = q.seat;
                int result = cancel_reservation(seatnum);
                break;
            case 5:
                int usernum = q.user;
                int result = logout(usernum);
                break;
            default:
                printf("switch ERROR\n");
                break;
        }
    }
    close(client_sock2);
    return;
}

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

    /* You should generate thread when new client accept occurs
     and process query of client until get termination query */
    int *client_sock2;
    while (1) {
        printf("\n");
        client_sock2 = (int *)malloc(sizeof(int));
        if ((*client_sock2 = accept(serv_sock, (struct sockaddr *)&caddr, (socklen_t *)&caddrlen)) < 0) {
            printf("accept() failed\n");
            free(client_sock2);
            continue;
        }
        int next = find_available_thread();
        argument arg;
        arg.client_socket = client_sock2;
        arg.thread_num = next;
        pthread_create(&tid[next], NULL, thread_func, &arg);
    }

    return 0;
}
