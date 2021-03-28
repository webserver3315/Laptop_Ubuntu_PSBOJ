#define MAXARGS 128
#define MAXLINE 256
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
void eval(char *cmdline);
int parseline(char *buf, char **argv, char target);
int builtin_command(char **argv, int argc);
void make_tokens(char *cmd, char *arg[], char *arg2[], char *target);

char original_path[MAXLINE];

/*
example_shell.c 보고 대대적으로 eval 함수 리팩토링 하기 이전의 코드.
안정적으로 작동을 보장하지 못함.
차라리 이전의 copy_4 버전을 쓸 것.
*/

void print_argv(char **argv) {
    int argc = 0;
    for (; argv[argc] != NULL; argc++) {
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

/*
argv 가 builtin 이냐 끌어오냐에 따라 path 다르게 설정해주고 execv(argv[0],argv) 만 하면 되도록 만들어준다.
*/
void make_executable(char **argv, int argc) {  // 자식에서만 돌기 때문에, 반드시 exit 으로 종결시킬 것
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
}

/* 자식프로세스에서 돌아감을 전제하므로 exit 으로 마칠 것 */
void eval_cmdline(char *cmdline) { /* 단 하나의 파이프라인 실행 */
    char *argv[MAXARGS];           /* Argument list execve() */
    char buf[MAXLINE];             /* Holds modified command line */
    int bg;                        /* Should the job run in bg or fg? */
    pid_t pid;                     /* Process id */

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
            make_executable(argv, argc);
            if (execv(argv[0], argv)) {  //위의 if-else 문에서 path 최종설정해서 argv[0]에 반영했고, 실행하기
                fprintf(stderr, "mini: command not found\n");
                perror("execv2 ERROR: ");
                exit(1);
            }
        } else {
            if (!bg) {  //Ctrl+Z 아닐 경우, 자식 회수를 기다린다
                int status;
                if (waitpid(pid, &status, 0) < 0)
                    fprintf(stderr, "Error occured: %d\n", errno);
            } else {
                printf("Continue: %d %s", pid, cmdline);
            }
            // exit(0);
        }
    }
    return;
}

/*
 * $ begin eval
 * eval - Evaluate a pipelines
 */
void eval(char *raw_cmd) {
    char *argv[MAXARGS]; /* Argument list execve() */
    char buf[MAXLINE];   /* Holds modified command line */
    int bg;              /* Should the job run in bg or fg? */
    pid_t pid;           /* Process id */

    int i = 0;
    int p_cnt = 1; /* 파이프라인 개수 */
    while (raw_cmd[i] != 0) {
        if (raw_cmd[i] == '|') {
            p_cnt++;
        }
        i++;
    }

    printf("pipeline count: %d\n", p_cnt);
    char *cmdline = strtok(raw_cmd, "|"); /* raw_cmd 에서 | 따라 파싱된 cmd */
    for (int i = 0; i < p_cnt; i++) {
        printf("FOR: cmdline\n");
        printf("FOR: cmdline = \'%s\'\n", cmdline);
        char *arg[MAXLINE], *arg2[MAXLINE];
        char path[MAXLINE], path2[MAXLINE];
        int child_status;
        int fd[2];
        int fdr;

        if (fork() == 0) {
            if (i != 0) {  //prev 있을 때
            }
            if (i != p_cnt - 1) {  //next 있을 때
            }
            if (strchr(cmdline, '<') != NULL) {
                make_tokens(cmdline, arg, arg2, "<");
                if (fork() == 0) {
                    fdr = open(arg2[0], O_RDONLY);
                    dup2(STDIN_FILENO, STDIN_FILENO + 1000);
                    dup2(fdr, STDIN_FILENO);
                    eval_cmdline(arg);
                }
            }
            if (strstr(cmdline, ">>") != NULL) {
                make_tokens(cmdline, arg, arg2, ">>");
                printf("cmdline\n");
            } else if (strchr(cmdline, '>') != NULL) {
                make_tokens(cmdline, arg, arg2, ">");
            }

            printf("%d th cmdline: \'%s\'\n", i, cmdline);
            eval_cmdline(cmdline);
            printf("%d th eval_cmdline ENDED\n", i);
        }

        cmdline = strtok(NULL, "|");
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

void sig_handler(int signo) {
    return;
}

void make_tokens(char *cmd, char *arg[], char *arg2[], char *target) {
    char *left, *right, *ptr;
    int num = 0;

    left = strtok(cmd, target);  // malloc 으로 메모리 할당 안하고 넣는건데 이거 ㄱㅊ?
    strcat(left, "\0");
    right = strtok(NULL, target);
    strcat(right, "\0");

    ptr = strtok(left, " ");
    while (ptr != NULL) {
        arg[num++] = ptr;
        // printf("arg[%d]=%s\n", num - 1, arg[num - 1]);
        ptr = strtok(NULL, " ");
    }
    arg[num] = NULL;

    num = 0;
    ptr = strtok(right, " ");
    while (ptr != NULL) {
        arg2[num++] = ptr;
        // printf("arg2[%d]=%s\n", num - 1, arg2[num - 1]);
        ptr = strtok(NULL, " ");
    }
    arg2[num] = NULL;

    return;
}

int main() {
    char cmdline[MAXLINE]; /* Command line */
    char *ret;

    getcwd(original_path, MAXLINE);
    printf("original path = %s\n", original_path);
    // signal(SIGINT, (void *)sig_handler);
    // signal(SIGSTOP, (void *)sig_handler);

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