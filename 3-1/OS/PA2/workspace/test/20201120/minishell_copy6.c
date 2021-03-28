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

#ifndef READ
#define READ 0
#endif

#ifndef WRITE
#define WRITE 1
#endif

/*
my_execv 로 example 코드 따라하다 그냥 망해서 버린 코드. 돌리지 말 것.
*/

void eval(char *cmdline);
int parseline(char *buf, char **argv, char target);
int builtin_command(char **argv, int argc);
void make_tokens(char *cmd, char *arg[], char *arg2[], char *target);

char original_path[MAXLINE];

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

int my_execv(const char *file, char **argv) {
    printf("file = \'%s\'\n", file);
    print_argv(argv);
    char path[MAXLINE] = {0};
    if (is_implemented(argv, 0)) {  //직접 구현했다면
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
 * eval - Evaluate a pipelines
 */
void eval(char *raw_cmd) {
    char *argv[MAXARGS]; /* Argument list execve() */
    char buf[MAXLINE];   /* Holds modified command line */
    int bg;              /* Should the job run in bg or fg? */
    pid_t pid;           /* Process id */

    int argLocation[20] = {0};
    int count, m, pipes, status;
    count = m = pipes = 0;
    char *tmp = NULL;
    int l_pipe[2], r_pipe[2];
    char *in_path, *out_path;
    int inputRedirectFlag, outputRedirectFlag;

    tmp = strtok(raw_cmd, " \t\n");
    argv[m++] = tmp;
    while (tmp != NULL) {
        tmp = strtok(NULL, " \t\n");
        argv[m++] = tmp;
    }
    printf("m==%d\n", m);
    print_argv(argv);

    // exit, cd는 먼저 체크
    builtin_command(argv, m);

    /* manage redirection */
    while (argv[count] != 0) {
        if (strcmp(argv[count], "|") == 0) {
            argv[count] = 0;
            argLocation[pipes + 1] = count + 1;
            ++pipes;
        } else if (strcmp(argv[count], "<") == 0) {
            in_path = strdup(argv[count + 1]);
            argv[count] = 0;
            inputRedirectFlag = 1;
        } else if (strcmp(argv[count], ">") == 0) {
            out_path = strdup(argv[count + 1]);
            argv[count] = 0;
            outputRedirectFlag = 1;
        } else {
            argLocation[count] = count;
        }
        ++count;
    } /* end of redirection management */

    /* execute commands [<= in for-loop; n pipes require n+1 processes] */
    for (int index = 0; index <= pipes; ++index) {
        if (pipes > 0 && index != pipes) { /* if user has entered multiple commands with '|' */
            pipe(r_pipe);                  /* no pipe(l_pipe); r_pipe becomes next child's l_pipe */
        }

        /* switch-statement for command execution */
        switch (pid = fork()) {
            case -1:
                perror("fork failed"); /* fork() error */
                break;

            case 0: /* child process manages redirection and executes */
                if ((index == 0) && (inputRedirectFlag == 1)) {
                    int inputFileDescriptor = open(in_path, O_RDONLY, 0400);
                    if (inputFileDescriptor == -1) {
                        perror("input file failed to open\n");
                        return;
                    }
                    close(READ);
                    dup(inputFileDescriptor);
                    close(inputFileDescriptor);
                } /* end of input redirection management */
                if ((index == pipes) && (outputRedirectFlag == 1)) {
                    //printf("DEBUG: here we should be about to create our output file\n");
                    int outputFileDescriptor = creat(out_path, 0700);
                    if (outputFileDescriptor < 0) {
                        perror("output file failed to open\n");
                        return;
                    }
                    close(WRITE);
                    dup(outputFileDescriptor);
                    close(outputFileDescriptor);
                } /* end of output redirection management */
                /* manage pipes if (a) first child process, (b) in-between child process, or (c) final child process */
                if (pipes > 0) {
                    if (index == 0) { /* first child process */
                        close(WRITE);
                        dup(r_pipe[WRITE]);
                        close(r_pipe[WRITE]);
                        close(r_pipe[READ]);
                    } else if (index < pipes) { /* in-between child process */
                        close(READ);
                        dup(l_pipe[READ]);
                        close(l_pipe[READ]);
                        close(l_pipe[WRITE]);
                        close(WRITE);
                        dup(r_pipe[WRITE]);
                        close(r_pipe[READ]);
                        close(r_pipe[WRITE]);
                    } else { /* final child process */
                        close(READ);
                        dup(l_pipe[READ]);
                        close(l_pipe[READ]);
                        close(l_pipe[WRITE]);
                    }
                }
                /* execute command */
                my_execv(argv[argLocation[index]], &argv[argLocation[index]]);

                /* if execvp() fails */
                perror("execution of command failed\n");
                break;

            default: /* parent process manages the pipes for child process(es) */
                if (index > 0) {
                    close(l_pipe[READ]);
                    close(l_pipe[WRITE]);
                }
                l_pipe[READ] = r_pipe[READ];
                l_pipe[WRITE] = r_pipe[WRITE];
                /* parent waits for child process to complete */
                wait(&status);
                break;
        } /* end of switch-statement for command execution */
    }     /* end of loop for all pipes */
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