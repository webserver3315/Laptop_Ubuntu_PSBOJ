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

    left = strtok(cmd, target);
    strcat(left, "\0");
    right = strtok(NULL, target);
    strcat(right, "\0");

    ptr = strtok(left, " ");
    while (ptr != NULL) {
        arg[num++] = ptr;
        ptr = strtok(NULL, " ");
    }
    arg[num] = NULL;

    num = 0;
    ptr = strtok(right, " ");
    while (ptr != NULL) {
        arg2[num++] = ptr;
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
                if (pipe(fd) == -1)
                    exit(1);

                //FILL YOUR CODES

            } else
                wait(&child_status);

        }
        // > REDIRECTION
        else if (strchr(cmd, '>') != NULL) {
            make_tokens(cmd, arg, arg2, ">");
            sprintf(path, "/bin/%s", arg[0]);

            if (fork() == 0) {
                //FILL YOUR CODES

            } else
                wait(&child_status);

        }
        // < REDIRECTION
        else if (strchr(cmd, '<') != NULL) {
            make_tokens(cmd, arg, arg2, "<");
            sprintf(path, "/bin/%s", arg[0]);

            if (fork() == 0) {
                //FILL YOUR CODES

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
                exit(0);
            } else
                wait(&child_status);
        }
    }
    return 0;
}
