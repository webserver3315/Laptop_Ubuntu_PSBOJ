#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

int N;
int child_arg_cnt;
int parent_ack_cnt;
pid_t pid;

// sig_alarm 보냄
// SIGALRM 1초 후 parent_send_sig_handler 호출
/* 부모가 계속 루프도는 셈. ALRM 자기재귀하면서 자식에게 USR1 보낸다. */
void parent_send_sig_handler(int sig) {  // SIGALRM Parent -> Child
    if (parent_ack_cnt == N) {
        kill(pid, SIGINT);
        // printf("sender: send suicide order to the child\n");
        printf("All signals are sended\n");
        exit(0);
    }

    for (int i = parent_ack_cnt; i < N; i++) {
        kill(pid, SIGUSR1);
    }
    printf("sender: sending %d signal\n", N - parent_ack_cnt);
    // printf("parent_ack_cnt = %d, N = %d\n", parent_ack_cnt, N);
    alarm(1);
}

/* 자식이 부모한테 USR1을 받으면 부모한테 다시 USR1 전송 */
void child_send_ack_handler(int sig) {  // SIGUSR1 Child
    kill(pid, SIGUSR1);
    child_arg_cnt++;
    printf("receiver: receive %d signals and sending acks\n", child_arg_cnt);
    return;
}

//ARG 수신
/* 자식으로부터 USR1 을 받으면 이를 ACK 로 취급하여 부모측에서 ++한다. */
void parent_recv_ack_handler(int sig) {  // SIGUSR1 Child -> Parent
    parent_ack_cnt++;
    // printf("sender: receive %dth signal and sending acks\n", parent_ack_cnt);
    // kill(pid, SIGUSR1);
}

//ACK 자식프로세스 최종종료
/* 부모로부터 SIGINT 를 받으면 자식이 자살한다. */
void child_suicide_handler(int sig) {  // SIGINT Parent -> Child
    // printf("receiver: Exiting via SIGINT: %d/%d\n", child_arg_cnt, N);
    printf("receiver: received signal : %d\n", child_arg_cnt);
    exit(0);
}

int main(int argc, char* argv[]) {
    if (argc != 2) {
        fprintf(stderr, "The number of argument should be 2\n");
        exit(1);
    }

    N = atoi(argv[1]);
    printf("sending signal: %d\n", N);

    /* Install Signal Handler */
    if ((pid = fork()) == 0) { /*자식 - SIGALRM 받으면 반환, SIGINT 받으면 EXIT*/
        pid = getppid();
        child_arg_cnt = 0;
        signal(SIGUSR1, child_send_ack_handler);
        signal(SIGINT, child_suicide_handler);
        while (1)
            ;
    } else { /* 부모 */
        parent_ack_cnt = 0;
        signal(SIGUSR1, parent_recv_ack_handler);
        signal(SIGALRM, parent_send_sig_handler);
        alarm(1);
        while (1)
            ;
    }

    return 0;
}
