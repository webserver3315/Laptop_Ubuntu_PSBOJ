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

/*
eval 함수를 | 로 strtok 해서 파이프라이닝에 적절히 대응하도록 바꿀 것이다.
아직 바꾸기 직전
*/

void print_argv(char **argv) {
    int argc = 0;
    while (argv[argc] != NULL) {
        printf("argv[%d] = \'%s\'\n", argc, argv[argc]);
    }
    printf("argc == %d\n", argc);
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

void execute(char **argv, int argc) {  // 자식에서만 돌기 때문에, 반드시 exit 으로 종결시킬 것
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
        // printf("Import from /bin/bash\n");
        sprintf(path, "/bin/%s", argv[0]);
        argv[0] = path;
    }
    if (execv(argv[0], argv)) {  //위의 if-else 문에서 path 최종설정해서 argv[0]에 반영했고, 실행하기
        fprintf(stderr, "mini: command not found\n");
        perror("execv2 ERROR: ");
        exit(1);
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
    // char *pipelines[MAXLINE]; /* 파이프라인으로 cmdline 파싱*/

        for (int i = 0; i < MAXARGS; i++) {
        argv[i] = NULL;
    }

    strcpy(buf, cmdline);
    bg = parseline(buf, argv, ' ');
    if (argv[0] == NULL)
        return;

    int argc = 0;
    while (argv[argc] != NULL) {
        // printf("argv[%d] = \'%s\'\n", argc, argv[argc]);
        argc++;
        // printf("argc==%d\n", argc);
    }
    if (!builtin_command(argv, argc)) {
        if ((pid = fork()) == 0) {
            execute(argv, argc);
        } else {
            if (!bg) {  //Ctrl+Z 아닐 경우, 자식 회수를 기다린다
                int status;
                if (waitpid(pid, &status, 0) < 0)
                    fprintf(stderr, "Error occured: %d\n", errno);
            } else {
                printf("Continue: %d %s", pid, cmdline);
            }
        }
    }
    return;
}

/* If first arg is a builtin command, run it and return true */
int builtin_command(char **argv, int argc) {
    print_argv(argv);
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