#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

/*
Mini Shell
*/

void print_arg(char** arg, int n) {
    for (int i = 0; i < n; i++) {
        printf("arg[%d] = \'%s\'\n", i, arg[i]);
    }
}

void execute(char** arg, int n) {
    // if (n == 1) {
    //     execv(arg[0], arg);
    //     return;
    // }
    char* cmd = malloc(512);
    sprintf(cmd, "/bin/%s", arg[0]);

    execv(cmd, arg);

    free(cmd);
}

int main(int argc, char* argv[]) {
    // char* buf = malloc(512);
    int child_status;
    char* cmd = NULL;
    for (;; free(cmd)) {
        size_t len = 0;
        getline(&cmd, &len, stdin);
        cmd[strlen(cmd) - 1] = '\0';

        // printf("%ld : %s\n", len, cmd);
        if (0 == strcmp(cmd, "quit")) {
            // printf("goto END\n");
            goto END;
        }
        if (0 == fork()) {
            int n = 0;
            char** arg = malloc(64);
            arg[n] = malloc(512);
            arg[n] = strtok(cmd, " ");
            while (arg[n] != NULL) {
                n++;
                arg[n] = malloc(512);
                cmd = strtok(NULL, " ");
                arg[n] = cmd;
            }
            // print_arg(arg, n);
            // printf("n==%d\n", n);
            execute(arg, n);

            for (int i = 0; i < n; i++)
                free(arg[n]);
            free(arg);
            // exit(0);
            goto END;
        } else {
            pid_t wpid = wait(&child_status);
            // if (WIFEXITED(child_status))
            // printf("Child %d terminated with exit status %d\n", wpid, WEXITSTATUS(child_status));
            // else {
            // printf("Child %d terminated abnormally\n", wpid);
            // }
        }
    }
END:
    // free(buf);
    free(cmd);
    return 0;
}