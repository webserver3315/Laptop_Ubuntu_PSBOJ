#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

int send_sig_cnt;
int recv_sig_cnt;
int recv_ack_cnt;
pid_t pid;

//ACK 자식프로세스 최종종료
void proc_exit_handler(int sig) {  // SIGINT
    printf("receiver: Exiting via SIGINT: %d/%d\n", recv_sig_cnt, send_sig_cnt);
    exit(0);
}

//ARG 수신
void recv_ack_handler(int sig) {  // SIGUSR1 Parent
    /* SIGUSR1 Child, Parent */
    recv_sig_cnt++;
    printf("sender: receive %dth signal and sending acks\n", recv_sig_cnt);
    kill(pid, SIGUSR1);
}

//sig_alarm
//USR 핸들러 보냄
void send_sig_handler(int sig) {  // SIGALRM 1초 후 send_sig_handler 호출
    if (send_sig_cnt <= recv_sig_cnt) {
        kill(pid, SIGINT);
        printf("sender: send suicide order to the child\n");
        exit(0);
    }

    for (int i = recv_ack_cnt; i < send_sig_cnt; i++) {
        kill(pid, SIGUSR1);
    }
    printf("sender: sending %d signal\n", send_sig_cnt - recv_ack_cnt);
    printf("recv_ack_cnt = %d, send_sig_cnt = %d\n", recv_ack_cnt, send_sig_cnt);
    alarm(5);
}

void send_ack_handler(int sig) {  // SIGUSR1 Child
    kill(pid, SIGUSR1);
    recv_sig_cnt++;
    printf("sender: sending %d signal\n", recv_sig_cnt);
    return;
}

int main(int argc, char* argv[]) {
    if (argc != 2) {
        fprintf(stderr, "The number of argument should be 2\n");
        exit(1);
    }

    send_sig_cnt = atoi(argv[1]);
    printf("sending signal: %d\n", send_sig_cnt);

    /* Install Signal Handler */
    if ((pid = fork()) == 0) { /*자식 - SIGALRM 받으면 반환, SIGINT 받으면 EXIT*/
        pid = getppid();
        recv_sig_cnt = 0;
        signal(SIGUSR1, send_ack_handler);
        signal(SIGINT, proc_exit_handler);
        while (1)
            ;
    } else { /* 부모 */
        recv_ack_cnt = 0;
        signal(SIGALRM, recv_ack_handler);
        signal(SIGUSR1, send_sig_handler);
        alarm(1);
        while (1)
            ;
    }

    return 0;
}
