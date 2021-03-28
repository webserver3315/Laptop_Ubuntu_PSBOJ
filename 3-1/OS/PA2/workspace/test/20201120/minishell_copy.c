#define MAXARGS 128
#define MAXLINE 256
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
/*
직접구현 executable 확인(cat b)
/bin/ 에서 끌어쓰는 executable 확인(man printf)
파이프랑 리다이렉션 구현하면 됨
추가적으로, 명령어 뚫리는거 없는지 점검하면 됨
*/

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

int is_implemented(char **argv, int argc) {
    if (strcmp(argv[0], "head") == 0) {
        return 1;
    } else if (strcmp(argv[0], "tail") == 0) {
        return 1;
    } else if (strcmp(argv[0], "cat") == 0) {
        return 1;
    } else if (strcmp(argv[0], "cp") == 0) {
        return 1;
    } else if (strcmp(argv[0], "mv") == 0) {
        return 1;
    } else if (strcmp(argv[0], "rm") == 0) {
        return 1;
    } else if (strcmp(argv[0], "pwd") == 0) {
        return 1;
    } else {
        return 0;
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
            // printf("2 - argv[0]: %s\n", argv[0]);
            // printf("2 - argv[1]: %s\n", argv[1]);
            char path[MAXLINE];
            path[0] = 0;
            if (is_implemented(argv, idx)) {  //직접 구현했다면
                getcwd(path, MAXLINE);
                strcat(path, "/\0");
                strcat(path, argv[0]);
                printf("Execute %s\n", path);
                argv[0] = path;
                // printf("3 - argv[0]: %s\n", argv[0]);
                // printf("3 - argv[1]: %s\n", argv[1]);
                if (execv(argv[0], argv)) {
                    fprintf(stderr, "%s: Command not found.\n", argv[0]);
                    perror("execv1 ERROR: ");
                    exit(0);
                }
            } else {  // bin/bash 에서 끌어쓰면
                sprintf(path, "/bin/%s", argv[0]);
                argv[0] = path;
                // printf("4 - argv[0]: %s\n", argv[0]);
                // printf("4 - argv[1]: %s\n", argv[1]);
                if (execv(argv[0], argv) < 0) {
                    fprintf(stderr, "%s: Command not found.\n", argv[0]);
                    perror("execv2 ERROR: ");
                    exit(0);
                }
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
    // printf("argv[0] = \'%s\'\n", argv[0]);
    if (strcmp(argv[0], "exit") == 0) {
        int ret;
        // printf("argc == %d\n", argc);
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
        // printf("before: %s\n", path);
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
        // printf("result: %s\n", path);
        return 1;
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