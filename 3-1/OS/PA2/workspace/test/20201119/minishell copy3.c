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
int parseline(char *buf, char **argv, char target);
int builtin_command(char **argv, int argc);

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

/*
 * $ begin eval
 * eval - Evaluate a command line
 */
void eval(char *cmdline) {
    char *argv[MAXARGS]; /* Argument list execve() */
    char buf[MAXLINE];   /* Holds modified command line */
    int bg;              /* Should the job run in bg or fg? */
    pid_t pid;           /* Process id */

    for (int i = 0; i < MAXARGS; i++) {
        argv[i] = NULL;
    }

    strcpy(buf, cmdline);
    bg = parseline(buf, argv, ' ');
    if (argv[0] == NULL)
        return;

    int idx;
    for (idx = 0; argv[idx] != NULL; idx++) {
        printf("argv[%d] = \'%s\'\n", idx, argv[idx]);
    }

    if (!builtin_command(argv, idx)) {
        /* Child runs user job */
        if ((pid = fork()) == 0) {
            if (execv(argv[0], argv) < 0) {
                fprintf(stderr, "%s: Command not found.\n", argv[0]);
                exit(0);
            }
        } else {
            if (!bg) {
                int status;
                if (waitpid(pid, &status, 0) < 0)
                    printf("waitfg: waitpid error");
            } else
                printf("%d %s", pid, cmdline);
        }
    }
    return;
}

/* If first arg is a builtin command, run it and return true */
int builtin_command(char **argv, int argc) {
    printf("argv[0] = \'%s\'\n", argv[0]);
    if (strcmp(argv[0], "exit") == 0) {
        int ret;
        printf("argc == %d\n", argc);
        if (argc == 1)
            ret = 0;
        else
            ret = atoi(argv[1]);
        fprintf(stderr, "exit(%d)", ret);
        exit(ret);
    } else if (strcmp(argv[0], "cd") == 0) {
        if (argc != 2) {
            fprintf(stderr, "cd: not enough parameter\n");
            exit(1);
        }
        char path[MAXLINE];
        path[0] = 0;
        getcwd(path, MAXLINE);
        printf("before: %s\n", path);
        strcat(path, "/\0");
        strcat(path, argv[1]);
        strcat(path, "\0");
        // printf("cd to \'%s\'\n", path);
        int status = chdir(path);
        if (status != 0) {
            perror("chdir error: ");
            exit(1);
        }
        getcwd(path, MAXLINE);
        printf("result: %s\n", path);
        return 0;
    }
    return 0;
}

int parseline(char *buf, char **argv, char target) {
    char *delim; /* Points to first space delimiter */
    int argc;    /* Number of args */
    int bg;      /* Background job? */

    buf[strlen(buf) - 1] = ' '; /* Replace trailing '\n' with target */

    /* Ignore leading spaces */
    while (*buf && (*buf == ' '))
        buf++;

    argc = 0;
    while ((delim = strchr(buf, target))) {
        argv[argc++] = buf;
        *delim = '\0';
        buf = delim + 1;
        while (*buf && (*buf == ' '))
            buf++;
    }
    argv[argc] = NULL;
    printf("argc = %d\n", argc);

    /* Ignore blank line */
    if (argc == 0)
        return 1;

    /* Should the job run in the background? */
    if ((bg = (*argv[argc - 1] == '&')) != 0)
        argv[--argc] = NULL;

    return bg;
}
/* $end parseline */

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