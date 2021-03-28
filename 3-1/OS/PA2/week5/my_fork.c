#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

#define N 10

void fork1() {
    int x = 1;
    pid_t pid = fork();
    if (pid == 0) {
        printf("Child has x=%d\n", ++x);
    } else {
        printf("Parent has x=%d\n", --x);
    }
    printf("Bye from process %d with x=%d\n", getpid(), x);
}

void fork2() {
    printf("L0\n");
    fork();
    printf("L1\n");
    fork();
    printf("Bye\n");
}

void cleanup() {
    printf("Cleaning up\n");
}

void fork3() {
    atexit(cleanup);
    fork();
    exit(0);
}

void fork4() {
    int child_status;
    if (fork() == 0) {
        printf("HC: hello from child\n");
    } else {
        printf("HP: hello from parent\n");
        wait(&child_status);
        printf("CT: child has terminated\n");
    }
    printf("bye\n");
    exit(0);
}

void fork5() {
    pid_t pid[N];
    int i, child_status;
    for (i = 0; i < N; i++) {
        if ((pid[i] = fork()) == 0)
            exit(100 + i);
    }
    for (i = 0; i < N; i++) {
        pid_t wpid = wait(&child_status);
        if (WIFEXITED(child_status))
            printf("Child %d terminated with exit status %d\n", wpid, WEXITSTATUS(child_status));
        else {
            printf("Child %d terminated abnormally\n", wpid);
        }
    }
}

void fork6() {
    pid_t pid[N];
    int i, child_status;
    for (i = 0; i < N; i++) {
        if ((pid[i] = fork()) == 0)
            exit(100 + i);
    }
    for (i = 0; i < N; i++) {
        pid_t wpid = waitpid(pid[i], &child_status, 0);
        if (WIFEXITED(child_status))
            printf("Child %d terminated with exit status %d\n", wpid, WEXITSTATUS(child_status));
        else {
            printf("Child %d terminated abnormally\n", wpid);
        }
    }
}

void fork7() {
    if (fork() == 0) {
        printf("Terminating Child, PID = %d\n", getpid());
        exit(0);
    } else {
        printf("Running Parent, PID = %d\n", getpid());
        while (1)
            ;
    }
}

void run1() {
    if (fork() == 0) {
        execl("/bin/ls", "-a", "-l", NULL);
    }
    wait(NULL);
    printf("completed\n");
    exit(0);
}

void run2() {
    char* args[] = {"ls", "/", NULL};
    if (fork() == 0) {
        execv("/bin/ls", args);
    }
    wait(NULL);
}

int main() {
    run1();
    return 0;
}