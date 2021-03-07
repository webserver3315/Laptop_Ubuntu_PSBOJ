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
        if ((pid = fork()) == 0) {
            char cmd[MAXLINE];
            sprintf(cmd, "/bin/%s", argv[0]);
            printf("cmd: %s, buf: %s, cmdline: %s\n", cmd, buf, cmdline);
            char *ptr;

            if ((ptr = strchr(cmdline, '|')) != NULL) {
                int fd[2];
                char *pipeline_cmd[MAXARGS], *pipeline2_cmd[MAXARGS];
                char path[MAXARGS], path2[MAXARGS];
                char *left, *right;
                printf("| PIPELINE HAKKEN\n");

                left = strtok(cmdline, "|");
                strcat(left, "\0");

                pop_left_pipeline(left, cmdline);
                printf("pop_left_pipeline: %s <-> %s\n", left, cmdline);
                printf("Bujini tadoru\n");

                cmdline = strtok(NULL, "|");
                printf("pop_left_pipeline: %s <-> %s\n", left, cmdline);

                if (fork() == 0) {
                    if (pipe(fd) < -1) exit(1);

                    dup2(STDIN_FILENO, STDIN_FILENO + 10);
                    dup2(STDOUT_FILENO, STDOUT_FILENO + 10);

                    make_tokens(cmd, pipeline_cmd, pipeline2_cmd, "|");
                    sprintf(path, "/bin/%s", pipeline_cmd[0]);
                    sprintf(path2, "/bin/%s", pipeline2_cmd[0]);

                    if (fork() == 0) {
                        close(fd[0]);
                        dup2(fd[1], STDOUT_FILENO);
                        execv(path, pipeline_cmd);
                        exit(0);
                    } else {
                        close(fd[1]);
                        wait(NULL);
                        dup2(fd[0], STDIN_FILENO);
                        execv(path2, pipeline2_cmd);
                        exit(0);
                    }
                    exit(0);
                } else {
                    wait(NULL);
                }
            } else {
                if ((ptr = strchr(cmdline, '<')) != NULL) {
                    printf("< REDIRECTION HAKKEN\n");
                }
                if ((ptr = strstr(cmdline, ">>")) != NULL) {
                    printf(">> REDIRECTION HAKKEN\n");
                } else if ((ptr = strchr(cmdline, '>')) != NULL) {
                    printf("> REDIRECTION HAKKEN\n");
                }
            }
            if (execv(cmd, argv) < 0) {
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
