//-----------------------------------------------------------
//
// SSE2033 : System Software Experiment 2 (Fall 2020)
//
// Skeleton Code for PA#2
//
// CSI, Sungkyunkwan University
//
//-----------------------------------------------------------

/* $ begin shellmain */

#include "myutil.h"

int make_token(char *from, char *to[], char *target) { /* target 스트링을 기준으로 from 을 to 로 파싱*/
    char *left, *ptr;
    int num = 0;

    left = strtok(from, target);
    if (left == NULL)
        return -1;
    strcat(left, "\0");

    ptr = strtok(left, " ");
    while (ptr != NULL) {
        to[num++] = ptr;
        ptr = strtok(NULL, " ");
    }
    to[num] = NULL;
    return num;
}

void eval(char *cmdline) {
    char *argv[MAXARGS]; /* Argument list execve() */
    char buf[MAXLINE];   /* Holds modified command line */
    int bg;              /* Should the job run in bg or fg? */
    pid_t pid;           /* Process id */
    int fd[2];
    int fd_in = 0;

    char *cmd[128][128];
    char *tmp_cmd[128];
    int pl_cnt = 0; /* Number of Pipelines */
    int word_cnt = 0;

    printf("cmdline = %s\n", cmdline);
    while ((word_cnt = make_token(cmdline, cmd[pl_cnt], "|")) != -1) {
        pl_cnt++;
    }

    printf("HERE\n");
    printf("pl_cnt %d, word_cnt %d\n", pl_cnt, word_cnt);
    for (int i = 0; i < pl_cnt; i++) {
        if (tmp_cmd[i][strlen(tmp_cmd[i]) - 1] == ' ')
            tmp_cmd[i][strlen(tmp_cmd[i]) - 1] = '\0';
        while (*tmp_cmd[i] && (*tmp_cmd[i] == ' ')) tmp_cmd[i]++; /* Ignore leading spaces */
        printf("tmp_cmd[%d] = \'%s\'\n", i, tmp_cmd[i]);
    }

    for (int i = 0; i < pl_cnt; i++) {
        cmd[i][word_cnt] = strtok(tmp_cmd[i], " \n");
        while (cmd[i][word_cnt++] != NULL) {
        }
    }

    // pipe(fd);
    // if ((pid = fork()) == -1) {
    //     exit(EXIT_FAILURE);
    // } else if (pid == 0) {
    //     dup2(fd_in, 0);  //change the input according to the old one
    //     if (*(cmd + 1) != NULL)
    //         dup2(fd[1], 1);
    //     close(fd[0]);
    //     execvp((*cmd)[0], *cmd);
    //     exit(EXIT_FAILURE);
    // } else {
    //     wait(NULL);
    //     close(fd[1]);
    //     fd_in = fd[0];  //save the input for the next command
    //     cmd++;
    // }

    // strcpy(buf, cmdline);
    // bg = parseline(buf, argv);
    // /* Ignore empty lines */
    // if (argv[0] == NULL)
    //     return;
    // if (!builtin_command(argv)) {
    //     /* Child runs user job */
    //     if ((pid = fork()) == 0) {
    //         if (execv(argv[0], argv) < 0) {
    //             fprintf(stderr, "%s: Command not found.\n", argv[0]);
    //             exit(0);
    //         }
    //     }
    //     /* Parent waits for foreground job to terminate */
    //     if (!bg) {
    //         int status;
    //         if (waitpid(pid, &status, 0) < 0)
    //             printf("waitfg: waitpid error");
    //     } else
    //         printf("%d %s", pid, cmdline);
    // }

    return;
}

int main() {
    char cmdline[MAXLINE]; /* Command line */
    char *ret;

    while (1) {
        /* Read */
        printf("mini> ");
        ret = fgets(cmdline, MAXLINE, stdin);
        if (feof(stdin) || ret == NULL)
            exit(0);
        /* Evaluate */
        eval(cmdline);
    }
}
/* $end shellmain */