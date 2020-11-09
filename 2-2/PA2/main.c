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

/* function prototypes */
void eval(char *cmdline);

int main() {
    char cmdline[MAXLINE]; /* Command line */
    char *ret;

    while (1) {
        /* Read */
        printf("mini> ");
        ret = fgets(cmdline, MAXLINE, stdin);  // cmdline에 개행도 같이 들어감에 유의
        if (feof(stdin) || ret == NULL)
            exit(0);

        /* Evaluate */
        eval(cmdline);
    }
}
/* $end shellmain */

/*
 * $ begin eval
 * eval - Evaluate a command line
 */
void eval(char *cmdline) {
    char *argv[MAXARGS]; /* Argument list execve() */
    char buf[MAXLINE];   /* Holds modified command line */
    int bg;              /* Should the job run in bg or fg? */
    pid_t pid;           /* Process id */

    strcpy(buf, cmdline);
    bg = parseline(buf, argv);

    /* Ignore empty lines */
    if (argv[0] == NULL)
        return;

    if (!builtin_command(argv)) {
        /* Child runs user job */
        if ((pid = fork()) == 0) {  // 쉘 명령어는 fork 에서 실행
            char path[MAXLINE], path2[MAXLINE];
            char *left, *right;
            int fd[2];

            left = strtok(cmdline, "|");
            left[strlen(left) - 1] = '\0';          /* Delete trailing char */
            while (*left && (*left == ' ')) left++; /* Ignore leading spaces */
            // sprintf(path, "/bin/%s", left);

            while (left != NULL) {
                right = left;
                left = strtok(NULL, "|");
                left[strlen(left) - 1] = '\0';          /* Delete trailing char */
                while (*left && (*left == ' ')) left++; /* Ignore leading spaces */
                printf("\'%s\' <-> \'%s\'\n", right, left);

                if (pipe(fd) < -1)
                    exit(1);

                dup2(STDIN_FILENO, STDIN_FILENO + 10);
                dup2(STDOUT_FILENO, STDOUT_FILENO + 10);

                if (fork() == 0) {
                    /*right 의 stdout 을 left 의 stdin 으로 넣기를 while(left!=NULL) 에 대해 반복하면 됨*/

                    close(fd[0]);
                    dup2(fd[1], STDOUT_FILENO);
                    execv(path, arg);
                    exit(0);

                } else {
                    wait(NULL);
                    close(fd[1]);
                    wait(&child_status);

                    dup2(fd[0], STDIN_FILENO);
                    execv(path2, arg2);
                    exit(0);
                }
            }

            if (execv(path, argv) < 0) {
                fprintf(stderr, "%s: Command not found.\n", argv[0]);
                exit(0);
            }
        }

        /* Parent waits for foreground job to terminate */
        if (!bg) {
            int status;
            if (waitpid(pid, &status, 0) < 0)
                printf("waitfg: waitpid error");
        } else
            printf("%d %s", pid, cmdline);
    }
    return;
}
