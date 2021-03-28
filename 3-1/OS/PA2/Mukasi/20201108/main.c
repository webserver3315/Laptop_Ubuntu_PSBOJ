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

    dup2(STDIN_FILENO, STDIN_FILENO + 10);    // STDIN 보존
    dup2(STDOUT_FILENO, STDOUT_FILENO + 10);  // STDOUT 보존
    /* Child runs user job */
    if ((pid = fork()) == 0) {  // 쉘 명령어는 fork 에서 실행
        char path[MAXLINE], path2[MAXLINE];
        char *left, *right;
        int fd[2];
        int fd_in = 0;

        parseline(left, path);
        parseline(right, path2);

        if ((left = strtok(cmdline, "|")) == NULL) {
            //그냥 실행
            exit(0);
        }
        left[strlen(left) - 1] = '\0';          /* Delete trailing char */
        while (*left && (*left == ' ')) left++; /* Ignore leading spaces */
        // sprintf(path, "/bin/%s", left);

        while (left != NULL) {
            left = strtok(NULL, "|");
            left[strlen(left) - 1] = '\0';          /* Delete trailing char */
            while (*left && (*left == ' ')) left++; /* Ignore leading spaces */
            printf("\'%s\'\n", left);

            if (pipe(fd) < -1)
                exit(1);

            if (fork() == 0) {
                /*right 의 stdout 을 left 의 stdin 으로 넣기를 while(left!=NULL) 에 대해 반복하면 됨*/
                close(fd[0]);

                exit(0);

            } else {
                wait(NULL);
                close(fd[1]);
                fd_in = fd[0];
                dup2(fd[0], STDIN_FILENO);
            }
        }

        if (execv(path, argv) < 0) {
            fprintf(stderr, "%s: Command not found.\n", argv[0]);
            exit(0);
        }
    } else {
        wait(NULL);
    }

    /* Parent waits for foreground job to terminate */
    if (!bg) {
        int status;
        if (waitpid(pid, &status, 0) < 0)
            printf("waitfg: waitpid error");
    } else
        printf("%d %s", pid, cmdline);
    return;
}
