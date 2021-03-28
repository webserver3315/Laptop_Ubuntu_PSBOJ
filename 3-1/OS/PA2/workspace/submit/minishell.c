#define MAXARGS 128
#define MAXLINE 256
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
void eval(char *cmdline);
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

int is_implemented(char **argv) {
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

void my_execv(char *file, char **argv) {
    char path[MAXLINE];
    path[0] = 0;
    if (is_implemented(argv)) {                        // 직접구현했다면
        if (argv[0][0] == '.' && argv[0][1] == '/') {  // 현재폴더라면
            getcwd(path, MAXLINE);
            argv[0] += 2;
        } else {
            strcat(path, original_path);
        }
        strcat(path, "/\0");
        strcat(path, argv[0]);
        argv[0] = path;
    } else {  // 미구현이라 bin/bash 에서 끌어쓴다면
        sprintf(path, "/bin/%s", argv[0]);
        argv[0] = path;
    }
    if (execv(argv[0], argv) == -1) {
        fprintf(stderr, "%s\n", strerror(errno));
        return;
    }

    return;
}

/* eval - Evaluate a pipelines */
void eval(char *raw_cmd) {
    char *argv[MAXARGS];     /* Argument list execve() */
    int pipe_index[MAXARGS]; /* 파이프 주소 */
    pid_t pid;               /* Process id */

    int p_cnt = 0; /* 파이프라인 개수 */
    char *input_path, *output_path;
    int input_redirection, output_redirection, status, background;
    int l_pipe[2], r_pipe[2];
    input_redirection = output_redirection = background = 0;

    int argc = 0;
    argv[argc++] = strtok(raw_cmd, " \t\n");
    while (argv[argc - 1] != NULL) {
        argv[argc] = strtok(NULL, " \t\n");
        if (argv[argc] == NULL)
            break;
        else
            argc++;
    }
    argv[argc] = NULL;
    // printf("argc: %d\n", argc);
    /* 첫 인자가 exit, cd 인자 여부 확인 */
    if (builtin_command(argv, argc)) {
        return;
    }

    /*
    < 와 > 또는 >> 가 있다면 redirection flag 설정하고, redirection 이름 저장하고 NULL박기
    | 가 있다면, 역시 NULL 박고 바로 다음 주소를 다음 pipe 시작주소로 기록하기
    */
    for (int i = 0; argv[i] != NULL; i++) {
        if (strcmp(argv[i], "|") == 0) {
            argv[i] = NULL;
            pipe_index[p_cnt + 1] = i + 1;
            p_cnt++;
        } else if (strcmp(argv[i], "<") == 0) {
            argv[i] = NULL;
            input_path = argv[i + 1];
            input_redirection = 1;
        } else if (strcmp(argv[i], ">") == 0) {
            argv[i] = NULL;
            output_path = argv[i + 1];
            output_redirection = 1;
        } else if (strcmp(argv[i], ">>") == 0) {
            argv[i] = NULL;
            output_path = argv[i + 1];
            output_redirection = 2;
        } else if (strcmp(argv[i], "&") == 0) {
            argv[i] = NULL;
            background = 1;
        } else {
            pipe_index[i] = i;
        }
    }

    /* pipe_index[index:0~p_cnt]가 각각의 파이프 시작점을 가리키고 자연스럽게 파이프끝은 NULL로 종결된다. */
    for (int i = 0; i <= p_cnt; i++) {
        if (p_cnt > 0 && i != p_cnt) {
            pipe(r_pipe);
        }
        switch (pid = fork()) {
            case -1:
                perror("fork failed");
                break;
            case 0:  //자식
                if ((i == 0) && input_redirection == 1) {
                    int input_fd = open(input_path, O_RDONLY);
                    if (input_fd < 0) {
                        fprintf(stderr, "mini: No such file or directory\n");
                        exit(0);
                    }
                    dup2(input_fd, STDIN_FILENO);
                    close(input_fd);
                }
                if ((i == p_cnt) && (output_redirection > 0)) {
                    if (output_redirection == 1) {
                        int output_fd = open(output_path, O_WRONLY | O_CREAT | O_TRUNC, 0666);
                        if (output_fd < 0) {
                            fprintf(stderr, "mini: No such file or directory\n");
                            exit(0);
                        }
                        dup2(output_fd, STDOUT_FILENO);
                        close(output_fd);
                    } else if (output_redirection == 2) {
                        int output_fd = open(output_path, O_WRONLY | O_CREAT | O_APPEND, 0666);
                        if (output_fd < 0) {
                            fprintf(stderr, "mini: No such file or directory\n");
                            exit(0);
                        }
                        dup2(output_fd, STDOUT_FILENO);
                        close(output_fd);
                    } else {
                        fprintf(stderr, "mini: No such file or directory\n");
                        exit(0);
                    }
                }
                if (p_cnt > 0) {  //파이프가 1개 이상
                    if (i != 0) {
                        dup2(l_pipe[STDIN_FILENO], STDIN_FILENO);
                        close(l_pipe[STDIN_FILENO]);
                        close(l_pipe[STDOUT_FILENO]);
                    }
                    if (i != p_cnt) {
                        dup2(r_pipe[STDOUT_FILENO], STDOUT_FILENO);
                        close(r_pipe[STDOUT_FILENO]);
                        close(r_pipe[STDIN_FILENO]);
                    }
                }
                my_execv(argv[pipe_index[i]], &argv[pipe_index[i]]);
                fprintf(stderr, "mini: command not found\n");
                exit(0);

            default:  //부모
                if (i > 0) {
                    close(l_pipe[STDIN_FILENO]);
                    close(l_pipe[STDOUT_FILENO]);
                }
                l_pipe[STDIN_FILENO] = r_pipe[STDIN_FILENO];
                l_pipe[STDOUT_FILENO] = r_pipe[STDOUT_FILENO];
                if (!background) {
                    if (waitpid(pid, &status, 0) < 0)
                        fprintf(stderr, "Error occured: %d\n", errno);
                } else {
                    while (waitpid(-1, &status, WNOHANG)) {
                        ;
                    }
                }
                break;
        }
    }
    for (int i = 0; i < MAXARGS; i++) {
        argv[i] = 0;
        pipe_index[i] = 0;
    }
    return;
}

/* If first arg is a builtin command, run it and return true */
int builtin_command(char **argv, int argc) {
    // printf("argc: %d\n", argc);
    // print_argv(argv);
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

void sig_handler(int signo) {
    return;
}

int main() {
    char cmdline[MAXLINE]; /* Command line */
    char *ret;

    getcwd(original_path, MAXLINE);
    // printf("original path = %s\n", original_path);
    signal(SIGINT, (void *)sig_handler);
    signal(SIGSTOP, (void *)sig_handler);

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