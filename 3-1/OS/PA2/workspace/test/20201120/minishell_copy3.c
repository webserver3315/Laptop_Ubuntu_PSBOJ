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

char original_path[MAXLINE];

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
    } else if (argv[0][0] == '.' && argv[0][1] == '/') {
        return 1;
    } else {
        return 0;
    }
}

void execute(argv, argc) {
    /*
    작성하기 직전에 copy3로써 저장함
    */
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

    int argc = 0;
    while (argv[argc] != NULL) {
        printf("argv[%d] = \'%s\'\n", argc, argv[argc]);
        argc++;
        printf("argc==%d\n", argc);
    }
    if (!builtin_command(argv, argc)) {
        /* Child runs user job */
        if ((pid = fork()) == 0) {
            char path[MAXLINE];
            path[0] = 0;
            if (is_implemented(argv, argc)) {  //직접 구현했다면
                if (argv[0][0] == '.' && argv[0][1] == '/') {
                    getcwd(path, MAXLINE);
                    argv[0] += 2;
                } else {
                    strcat(path, original_path);
                }
                strcat(path, "/\0");
                strcat(path, argv[0]);
                argv[0] = path;
            } else {  // bin/bash 에서 끌어쓰면
                printf("Import from /bin/bash\n");
                sprintf(path, "/bin/%s", argv[0]);
                argv[0] = path;
            }
            if (execv(argv[0], argv)) {  //위의 if-else 문에서 path 최종설정해서 argv[0]에 반영했고, 실행하기
                fprintf(stderr, "mini: command not found\n");
                perror("execv2 ERROR: ");
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
    printf("argc == %d\n", argc);
    for (int i = 0; i < argc; i++) {
        printf("argv[%d] = \'%s\'\n", i, argv[i]);
    }

    if (strcmp(argv[0], "exit") == 0) {
        int ret;
        if (argc == 1)
            ret = 0;
        else
            ret = atoi(argv[1]);
        fprintf(stderr, "exit(%d)", ret);
        exit(ret);
    } else if (strcmp(argv[0], "cd") == 0) {
        if (argc != 2) {
            fprintf(stderr, "cd: not enough parameter\n");
            return 1;
        }
        char path[MAXLINE];
        path[0] = 0;
        getcwd(path, MAXLINE);
        strcat(path, "/\0");
        strcat(path, argv[1]);
        strcat(path, "\0");

        int status = chdir(path);
        if (status != 0) {
            fprintf(stderr, "%s: %s\n", argv[0], strerror(errno));
            return 1;
        }
        getcwd(path, MAXLINE);
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

    /* Ignore blank line */
    if (argc == 0)
        return 1;

    /* Should the job run in the background? */
    if ((bg = (*argv[argc - 1] == '&')) != 0)
        argv[--argc] = NULL;

    return bg;
}
/* $end parseline */

void sig_handler(int signo) {
    return;
}

int main() {
    char cmdline[MAXLINE]; /* Command line */
    char *ret;

    getcwd(original_path, MAXLINE);
    printf("original path = %s\n", original_path);
    signal(SIGINT, (void *)sig_handler);
    signal(SIGSTOP, (void *)sig_handler);

    while (1) {
        /* Read */
        printf("\n\nmini> ");
        ret = fgets(cmdline, MAXLINE, stdin);
        if (feof(stdin) || ret == NULL)
            exit(0);

        /* Evaluate */
        eval(cmdline);
    }
}