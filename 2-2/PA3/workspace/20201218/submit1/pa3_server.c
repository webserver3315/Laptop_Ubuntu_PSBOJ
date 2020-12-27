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

#define MAXUSER 1050
#define MAXSEAT 256
#define MAXLINE 128
#define ORDERKAZU 5

int client2fd[MAXUSER];
int client2user[MAXUSER];  // -1: 오프라인, 0,1,2,3..: 접속중인 USER 번호
pthread_mutex_t c2u_mutex[MAXUSER];
int user2client[MAXUSER];  // -1: 오프라인, 0,1,2,3..: 접속중인 Client 번호
pthread_mutex_t u2c_mutex[MAXUSER];
pthread_t tid[MAXUSER];
int password[MAXUSER];  // password[idx] = idx 번째 user 의 비밀번호

int seat[MAXSEAT];                    // 0: 공석, 1: 예약
pthread_mutex_t seat_mutex[MAXSEAT];  // i번째 자리를 누가 편집중인지의 여부를 나타낸다.

typedef struct _query {
    int user;
    int action;
    int seat;
} query;

/*
CV based 를 Thread Based 로 바꿔야 함.
*/

int is_client_busy(int client_sock) {
    for (int i = 0; i < MAXUSER; i++) {
        if (user2client[i] == client_sock) {
            return 1;
        }
    }
    return 0;
}

/* 뮤텍스 순서: 반드시 c2u->u2c->seat */
// return 1: SUCCESS, return -1: FAIL
int login(int client_sock, int usernum, int passwd) {
    int ret;
    pthread_mutex_lock(&(c2u_mutex[client2fd[client_sock]]));
    pthread_mutex_lock(&(u2c_mutex[usernum]));
    // printf("LOGIN: usernum: %d, passwd: %d\n", usernum, passwd);
    if (client2user[client2fd[client_sock]] != -1) {  // 이 클라이언트가 누구든지 이용중이면 로그아웃이 먼저
        // printf("Already Another User is Logged in at THIS CLIENT. LOGOUT FIRST\n");
        ret = -1;
    } else if (user2client[usernum] != -1) {  // 이 유저가 어디든지 이미 로그인했다면
        // printf("Already THIS User is Logged in at ANOTHER CLIENT. LOGOUT AT ANOTHER CLIENT\n");
        ret = -1;
    } else if (password[usernum] == -1) {  // Registration
        // printf("USER %d First Login: Registeration Mode\n", usernum);
        password[usernum] = passwd;
        client2user[client2fd[client_sock]] = usernum;
        user2client[usernum] = client2fd[client_sock];
        ret = 1;
    } else if (password[usernum] != passwd) {
        // printf("Password INCORRECT\n");
        ret = -1;
    } else {
        // printf("USER %d at tid[%d] Login Success\n", usernum, client2fd[client_sock]);
        client2user[client2fd[client_sock]] = usernum;
        user2client[usernum] = client2fd[client_sock];
        ret = 1;
    }
    if (ret != -1) {
        printf("Login success\n");
    } else {
        printf("Login failed\n");
    }
    query q;
    q.user = ret;
    q.action = 1;
    q.seat = ret;
    write(client_sock, &q, sizeof(query));
    pthread_mutex_unlock(&(c2u_mutex[client2fd[client_sock]]));
    pthread_mutex_unlock(&(u2c_mutex[usernum]));
    return ret;
}

// return seatnum: SUCCESS, return -1: FAIL
int reserve(int client_sock, int usernum, int seatnum) {
    pthread_mutex_lock(&(c2u_mutex[client2fd[client_sock]]));
    pthread_mutex_lock(&(u2c_mutex[usernum]));
    pthread_mutex_lock(&(seat_mutex[seatnum]));
    // printf("RESERVE: usernum: %d, seatnum: %d\n", usernum, seatnum);
    int ret = -1;
    if (client2user[client2fd[client_sock]] != usernum) {  // 이 클라이언트에 유저가 접속하지 않은 상태라면
        // printf("CLIENT %d HAS NO USER. LOGIN FIRST\n", client2fd[client_sock]);
        ret = -1;
    } else if (user2client[usernum] != client2fd[client_sock]) {  // 이 유저가 이 클라이언트에 로그인 안되어있다면
        // printf("USER %d HAS NOT LOGGED IN. LOGIN FIRST\n", usernum);
        ret = -1;
    } else if (seatnum > 255 || seatnum < 0) {
        // printf("INVALID SEAT NUMBER %d: 0~255\n", seatnum);
        ret = -1;
    } else if (seat[seatnum] != -1) {  // 예약되어있다면
        // printf("SEAT %d Already RESERVED. TRY ANOTHER\n", seatnum);
        ret = -1;
    } else {
        // printf("CLIENT %d reserved USER %d to SEAT %d\n", client2fd[client_sock], usernum, seatnum);
        seat[seatnum] = usernum;
        ret = seatnum;
    }
    if (ret != -1) {
        printf("Seat %d is reserved\n", seatnum);
    } else {
        printf("Reservation failed\n");
    }
    query q;
    q.user = ret;
    q.action = 2;
    q.seat = ret;
    write(client_sock, &q, sizeof(query));

    pthread_mutex_unlock(&(c2u_mutex[client2fd[client_sock]]));
    pthread_mutex_unlock(&(u2c_mutex[usernum]));
    pthread_mutex_unlock(&(seat_mutex[seatnum]));
    return ret;
}

// return 1: SUCCESS, 정수열 전송되니까 버퍼 체크 1번 더 해야함., return 0: FAIL
int check_reservation(int client_sock, int usernum, int seatnum) {
    pthread_mutex_lock(&(c2u_mutex[client2fd[client_sock]]));
    pthread_mutex_lock(&(u2c_mutex[usernum]));
    pthread_mutex_lock(&(seat_mutex[seatnum]));
    // printf("CHECK_RESERVATION: seatnum: %d\n", seatnum);
    int ret;
    int cnt = 0;
    int buf[16][16];
    int send[MAXSEAT];
    if (client2user[client2fd[client_sock]] != usernum) {  // 이 클라이언트에 유저가 접속하지 않은 상태라면
        // printf("CLIENT %d HAS NO USER. LOGIN FIRST\n", client2fd[client_sock]);
        ret = -1;
    } else if (user2client[usernum] != client2fd[client_sock]) {  // 이 유저가 이 클라이언트에 로그인 안되어있다면
        // printf("USER %d HAS NOT LOGGED IN. LOGIN FIRST\n", usernum);
        ret = -1;
    } else if (seatnum > 255 || seatnum < 0) {
        // printf("INVALID SEAT NUMBER %d: 0~255\n", seatnum);
        ret = -1;
    } else {
        for (int r = 0; r < 16; r++) {
            for (int c = 0; c < 16; c++) {
                if (seat[16 * r + c] == usernum) {
                    buf[r][c] = 1;
                    send[cnt++] = 16 * r + c;
                } else {
                    buf[r][c] = 0;
                }
            }
        }
        send[cnt] = 0;
        if (cnt == 0) {  // 아무 자리도 예약안했다면
            // printf("USER %d HAS NOT RESERVED ANY SEAT\n", usernum);
            ret = -1;
        } else {  // write 로 buf 전송
            ret = 1;
        }
    }
    query q;
    q.user = ret;
    q.action = 3;
    q.seat = ret;
    write(client_sock, &q, sizeof(query));
    if (ret != -1) {
        write(client_sock, &cnt, sizeof(int));
        write(client_sock, send, sizeof(send));
        printf("Reservation: ");
        for (int i = 0; i < cnt; i++) {
            printf("%d ", send[i]);
        }
        printf("\n");
    } else {
        printf("Reservation check failed\n");
    }

    pthread_mutex_unlock(&(c2u_mutex[client2fd[client_sock]]));
    pthread_mutex_unlock(&(u2c_mutex[usernum]));
    pthread_mutex_unlock(&(seat_mutex[seatnum]));
    return ret;
}

// return seatnum: SUCCESS, return 0: FAIL
int cancel_reservation(int client_sock, int usernum, int seatnum) {
    pthread_mutex_lock(&(c2u_mutex[client2fd[client_sock]]));
    pthread_mutex_lock(&(u2c_mutex[usernum]));
    pthread_mutex_lock(&(seat_mutex[seatnum]));
    // printf("CANCEL_RESERVATION: seatnum: %d\n", seatnum);
    int ret;
    if (client2user[client2fd[client_sock]] != usernum) {  // 이 클라이언트에 유저가 접속하지 않은 상태라면
        // printf("CLIENT %d HAS NO USER. LOGIN FIRST\n", client2fd[client_sock]);
        ret = -1;
    } else if (user2client[usernum] != client2fd[client_sock]) {  // 이 유저가 이 클라이언트에 로그인 안되어있다면
        // printf("USER %d HAS NOT LOGGED IN. LOGIN FIRST\n", usernum);
        ret = -1;
    } else if (seatnum > 255 || seatnum < 0) {
        // printf("INVALID SEAT NUMBER %d: 0~255\n", seatnum);
        ret = -1;
    } else {
        if (seat[seatnum] != usernum) {
            // printf("The Seat %d is NOT RESERVED by USER %d\n", seatnum, usernum);
            ret = -1;
        } else {
            seat[seatnum] = -1;
            ret = seatnum;
            // printf("The Seat %d SUCCESSFULLY CANCELLED by USER %d\n", seatnum, usernum);
        }
    }
    if (ret != -1) {
        printf("Seat %d is canceled\n", seatnum);
    } else {
        printf("Cancel failed\n");
    }

    query q;
    q.user = ret;
    q.action = 4;
    q.seat = ret;
    write(client_sock, &q, sizeof(query));

    pthread_mutex_unlock(&(c2u_mutex[client2fd[client_sock]]));
    pthread_mutex_unlock(&(u2c_mutex[usernum]));
    pthread_mutex_unlock(&(seat_mutex[seatnum]));
    return ret;
}

// return 1: SUCCESS, return 0: FAIL
int logout(int client_sock, int usernum) {
    pthread_mutex_lock(&(c2u_mutex[client2fd[client_sock]]));
    pthread_mutex_lock(&(u2c_mutex[usernum]));
    int ret;
    // printf("LOGOUT: CLIENT %d USERNUM %d\n", client2fd[client_sock], usernum);
    if (client2user[client2fd[client_sock]] == -1) {  // 이 클라이언트가 이미 로그아웃이면
        // printf("Already This CLIENT has been LOGGED OUT\n");
        ret = -1;
    } else if (user2client[usernum] == -1) {  // 이 유저가 이미 로그아웃이면
        // printf("Already This USER has been LOGGED OUT\n");
        ret = -1;
    } else {
        client2user[client2fd[client_sock]] = -1;
        user2client[usernum] = -1;
        ret = 1;
    }

    if (ret != -1) {
        printf("Logout success\n");
    } else {
        printf("Logout failed\n");
    }

    query q;
    q.user = ret;
    q.action = 5;
    q.seat = ret;
    write(client_sock, &q, sizeof(query));

    pthread_mutex_unlock(&(c2u_mutex[client2fd[client_sock]]));
    pthread_mutex_unlock(&(u2c_mutex[usernum]));
    return ret;
}

void initialize() {
    for (int i = 0; i < MAXUSER; i++) {
        user2client[i] = -1;
        client2user[i] = -1;
        password[i] = -1;
        client2fd[i] = i - 3;
        pthread_mutex_init(&c2u_mutex[i], NULL);
        pthread_mutex_init(&u2c_mutex[i], NULL);
    }
    for (int i = 0; i < MAXSEAT; i++) {
        seat[i] = -1;
        pthread_mutex_init(&seat_mutex[i], NULL);
    }
}

void *thread_func(void *arg) {
    int n;
    query q;
    int client_sock2 = *((int *)arg);
    pthread_detach(pthread_self());
    free(arg);
    // printf("THREAD's CLIENT_SOCK2: %d\n", client_sock2);
    while (1) {
        if ((n = read(client_sock2, &q, sizeof(query)) < 0)) {
            printf("read ERROR\n");
            continue;
        }
        // printf("tid[%d] got q: %d %d %d\n", client_sock2 - 3, q.user, q.action, q.seat);
        int mode = q.action;
        int usernum = q.user;
        int seatnum = q.seat;
        int passwd = q.seat;
        int result;
        switch (mode) {
            case 0:
                if (q.user == 0 && q.action == 0 && q.seat == 0) {  // CLIENT EXIT
                    // printf("PLEASE DIE, tid[%d]\n", client_sock2 - 3);
                    write(client_sock2, &q, sizeof(query));
                    close(client_sock2);
                    return NULL;
                }
                break;
            case 1:
                result = login(client_sock2, usernum, passwd);
                break;
            case 2:
                result = reserve(client_sock2, usernum, seatnum);
                break;
            case 3:
                result = check_reservation(client_sock2, usernum, seatnum);
                break;
            case 4:
                result = cancel_reservation(client_sock2, usernum, seatnum);
                break;
            case 5:
                result = logout(client_sock2, usernum);
                break;
            default:
                printf("switch ERROR\n");
                break;
        }
    }
    close(client_sock2);
    return NULL;
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
    if (listen(serv_sock, MAXUSER) < 0) {
        printf("listen() failed\n");
        exit(1);
    }

    /* You should generate thread when new client accept occurs
     and process query of client until get termination query */
    int *client_sock2;
    while (1) {
        // printf("\n");
        client_sock2 = (int *)malloc(sizeof(int));
        if ((*client_sock2 = accept(serv_sock, (struct sockaddr *)&caddr, (socklen_t *)&caddrlen)) < 0) {
            printf("accept() failed\n");
            free(client_sock2);
            continue;
        }
        pthread_create(&tid[*client_sock2 - 3], NULL, thread_func, client_sock2);
    }

    return 0;
}
