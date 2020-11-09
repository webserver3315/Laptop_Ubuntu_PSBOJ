#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#define N 10

pid_t pid[N];
int ccount = 0;

void handler(int sig) {
    // pid_t id = wait(NULL);
    pid_t id;
    while ((id = waitpid(-1, NULL, WNOHANG)) > 0) {
        ccount--;
        printf("Received signal %d from pid %d\n", sig, id);
    }
}

int main() {
    int i;
    ccount = N;
    signal(SIGCHLD, handler);
    for (i = 0; i < N; i++) {
        if ((pid[i] = fork()) == 0) {
            exit(0);
        }
    }
    while (ccount > 0) {
        sleep(5);
    }
    return 0;
}