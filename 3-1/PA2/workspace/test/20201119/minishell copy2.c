#define MAXARGS 128
#define MAXLINE 256
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
void eval(char *cmdline);
int parseline(char *buf, char **argv);
int builtin_command(char **argv);

void cp2cpp(char *cmd_1d, char **cmd_2d, char *target) {
    int cpp_num = 0;
    cmd_2d[cpp_num] = strtok(cmd_1d, target);
    strcat(cmd_2d[cpp_num++], "\0");
    while ((cmd_2d[cpp_num] = strtok(NULL, target)) != NULL) {
        strcat(cmd_2d[cpp_num++], "\0");
    }
    cmd_2d[cpp_num] = NULL;
}

int cp2cppp(char *cmd_1d, char ***cmd_3d, char *target) {
    char *cmd_2d[256];
    cp2cpp(cmd_1d, cmd_2d, target);
    int i;
    for (i = 0; cmd_2d[i] != NULL; i++) {
        cp2cpp(cmd_2d[i], cmd_3d[i], " \t\n");
    }
    return i;
}

void free_cmd(char **cmd_2d, char ***cmd_3d) {
    for (int r = 0; r < 256; r++) {
        for (int c = 0; c < 256; c++) {
            free(cmd_3d[r][c]);
        }
        free(cmd_3d[r]);
        free(cmd_2d[r]);
    }
}

void eval(char *cmdline) {
    char *argv[MAXARGS]; /* Argument list execve() */
    char buf[MAXLINE];   /* Holds modified command line */
    int bg;              /* Should the job run in bg or fg? */
    pid_t pid;           /* Process id */

    printf("cmd: \'%s\'\n", cmdline);
    strcpy(buf, cmdline);
    bg = parseline(buf, argv);
    if (argv[0] == NULL)
        return;

    char **cmd_2d;
    char ***cmd_3d;
    cmd_2d = malloc(sizeof(char *) * 256);
    cmd_3d = malloc(sizeof(char **) * 256);
    for (int r = 0; r < 256; r++) {
        cmd_2d[r] = malloc(sizeof(char) * 256);
        cmd_3d[r] = malloc(sizeof(char *) * 256);
        for (int c = 0; c < 256; c++) {
            cmd_3d[r][c] = malloc(sizeof(char) * 256);
        }
    }
    int pipeline_num = cp2cppp(cmdline, cmd_3d, "|");
    printf("pipeline_num = %d\n", pipeline_num);

    for (int idx = 0; idx < pipeline_num; idx++) {
        for (int iidx = 0; cmd_3d[idx][iidx] != NULL; iidx++) {
            printf("cmd_3d[%d][%d]: \'%s\'\n", idx, iidx, cmd_3d[idx][iidx]);
        }
    }

    int builtin_num;
    if (0 == (builtin_num = builtin_command(argv))) {
        if (pipeline_num == 1) {  //파이프라인 없으면
            printf("NO PIPELINE\n");
            if (fork() == 0) {
                printf("Execute %s\n", cmd_3d[0][0]);
                if (-1 == execv(cmd_3d[0][0], cmd_3d[0])) {
                    perror("EXECV ERROR: ");
                }
                exit(0);
            } else {
                wait(NULL);
            }
            return;
        }
        /* Child runs user job */
        if ((pid = fork()) == 0) {
            if (execv(argv[0], argv) < 0) {
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
    } else if (builtin_num == 1) {  //exit
        free_cmd(cmd_2d, cmd_3d);
        exit(0);
    } else if (builtin_num == 2) {  //cd

        return;
    } else {
        printf("BUILTIN_ERROR\n");
        exit(1);
    }
    return;
}

/* If first arg is a builtin command, run it and return true */
int builtin_command(char **argv) {
    /* Insert your code */
    if (strcmp(argv[0], "exit") == 0) {
        return 1;
    } else if (strcmp(argv[0], "cd") == 0) {
                return 2;
    } else {
        return 0;
    }
}

int parseline(char *buf, char **argv) {
    char *delim; /* Points to first space delimiter */
    int argc;    /* Number of args */
    int bg;      /* Background job? */

    buf[strlen(buf) - 1] = ' ';

    while (*buf && (*buf == ' '))
        buf++;

    argc = 0;
    while ((delim = strchr(buf, ' '))) {
        argv[argc++] = buf;
        *delim = '\0';
        buf = delim + 1;

        while (*buf && (*buf == ' '))
            buf++;
    }
    argv[argc] = NULL;

    if (argc == 0)
        return 1;

    if ((bg = (*argv[argc - 1] == '&')) != 0)
        argv[--argc] = NULL;

    return bg;
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
