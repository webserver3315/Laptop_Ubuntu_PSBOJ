#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#define N 10

void int_handler(int sig) {
    printf("Process %d received signal %d\n", getpid(), sig);
    exit(22);
}

int main() {
    pid_t pid[N];
    int i, child_status;
    signal(SIGINT, int_handler);  // 추가

    for (i = 0; i < N; i++) {
        if ((pid[i] = fork()) == 0) {
            while (1)
                ;
        }
    }

    for (i = 0; i < N; i++) {
        printf("Killing process %d\n", pid[i]);
        kill(pid[i], SIGINT);
    }
    for (i = 0; i < N; i++) {
        pid_t wpid = wait(&child_status);
        if (0 != WIFEXITED(child_status)) {  //자식pid 의 조회값이 0이 아니므로 정상종료
            printf("Child %d terminated with exit status %d\n", wpid, WEXITSTATUS(child_status));
        } else {  // 조회값이 0이면 비정상종료로 추정가능
            printf("Child %d terminated abnormally\n", wpid);
        }
    }

    return 0;
}