#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

#define MAX_ARG 128
#define MAX_PATH_LEN 128

void make_tokens(char* cmd, char* arg[], char* arg2[], char* target) {
    char *left, *right, *ptr;
    int num = 0;

    left = strtok(cmd, target);  // malloc 으로 메모리 할당 안하고 넣는건데 이거 ㄱㅊ?
    strcat(left, "\0");
    right = strtok(NULL, target);
    strcat(right, "\0");

    ptr = strtok(left, " ");
    while (ptr != NULL) {
        arg[num++] = ptr;
        // printf("arg[%d]=%s\n", num - 1, arg[num - 1]);
        ptr = strtok(NULL, " ");
    }
    arg[num] = NULL;

    num = 0;
    ptr = strtok(right, " ");
    while (ptr != NULL) {
        arg2[num++] = ptr;
        // printf("arg2[%d]=%s\n", num - 1, arg2[num - 1]);
        ptr = strtok(NULL, " ");
    }
    arg2[num] = NULL;

    return;
}

int main() {
    size_t size;
    char *cmd, *ptr;
    char *arg[MAX_ARG], *arg2[MAX_ARG];
    char path[MAX_PATH_LEN], path2[MAX_PATH_LEN];
    int child_status;
    int fd[2];
    int fdr;

    while (1) {
        int num = 0;
        cmd = NULL;
        getline(&cmd, &size, stdin);
        cmd[strlen(cmd) - 1] = '\0';

        // TERMINATE PROGRAM
        if (strcmp(cmd, "quit") == 0) {
            break;
        }

        // PIPE
        if (strchr(cmd, '|') != NULL) {
            make_tokens(cmd, arg, arg2, "|");

            sprintf(path, "/bin/%s", arg[0]);
            sprintf(path2, "/bin/%s", arg2[0]);

            if (fork() == 0) {
                if (pipe(fd) < -1)
                    exit(1);
                //FILL YOUR CODES
                /*
                1. 입력받을 fd 연다. 출력박을 fd 연다.
                2. arg 출력이 arg2 의 입력으로 들어간다.
                3. arg2 의 출력을 stdout 으로 출력한다.
                    pipe(arg,arg2)
                4. 명령행 실행한다.
                */
                dup2(STDIN_FILENO, STDIN_FILENO + 10);
                dup2(STDOUT_FILENO, STDOUT_FILENO + 10);

                if (fork() == 0) {
                    close(fd[0]);
                    dup2(fd[1], STDOUT_FILENO);
                    execv(path, arg);
                    exit(0);
                } else {
                    close(fd[1]);
                    wait(&child_status);
                    dup2(fd[0], STDIN_FILENO);
                    execv(path2, arg2);
                    exit(0);
                }

                // printf("EXIT7\n");
                exit(0);
            } else {
                wait(&child_status);
            }

        }
        // > REDIRECTION prog < input.txt > output.txt
        else if (strchr(cmd, '>') != NULL) {
            make_tokens(cmd, arg, arg2, ">");
            sprintf(path, "/bin/%s", arg[0]);

            if (fork() == 0) {
                //FILL YOUR CODES
                /*
                1. 출력박을 fd 연다.
                2. pipe 로 stdout 착의 모든 출력을 fd 로 이어주도록 한다.
                3. 명령행 실행한다.
                */
                int fdw = open(arg2[0], O_RDWR | O_CREAT | O_TRUNC, 00777);
                dup2(STDOUT_FILENO, 5);  //5=tmp;
                dup2(fdw, STDOUT_FILENO);
                execv(path, arg);
                // printf("EXIT4\n");
                close(fdw);
                dup2(5, STDOUT_FILENO);

            } else
                wait(&child_status);

        }
        // < REDIRECTION prog < input.txt > output.txt
        else if (strchr(cmd, '<') != NULL) {
            make_tokens(cmd, arg, arg2, "<");
            sprintf(path, "/bin/%s", arg[0]);

            if (fork() == 0) {
                //FILL YOUR CODES
                /*
                1. 입력받을 fd 연다.
                2. pipe 로 stdin 발의 모든 입력을 fd 로 이어주도록 한다.
                3. 명령행 실행한다.
                */
                int fdr = open(arg2[0], O_RDONLY);
                dup2(STDIN_FILENO, 5);  //5=tmp;
                dup2(fdr, STDIN_FILENO);
                execv(path, arg);
                close(fdr);
                dup2(5, STDIN_FILENO);
                // printf("EXIT4\n");

                exit(0);
            } else
                wait(&child_status);

        }
        // ONLY SINGLE COMMAND
        else {
            ptr = strtok(cmd, " ");
            while (ptr != NULL) {
                arg[num++] = ptr;
                ptr = strtok(NULL, " ");
            }
            arg[num] = NULL;
            sprintf(path, "/bin/%s", arg[0]);
            if (fork() == 0) {
                execv(path, arg);
                // printf("EXIT4\n");
                exit(0);
            } else
                wait(&child_status);
        }
    }
    return 0;
}
