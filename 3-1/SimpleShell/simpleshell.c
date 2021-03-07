#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#include <assert.h>

#define MAXARGS 128
#define MAXLINE 256


int getcmd(char* cmdline, int str_siz); /* 입력받은 문자의 수를 리턴. 만일 하나도 못받았다면 0 리턴. 그냥 엔터는 1 리턴. */
int parsecmd(char* cmdline, char** argv); /* 스페이스/공백/개행 모두 parse 한 뒤 2차원으로 parse */
int builtin_command(char** argv); /* /bin/ls -la 라면 1, 그 이외는 전부 0 */

void print_argv(char** argv){
    for (int i = 0; argv[i] != 0;i++){
        printf("p_argv[%d] == \'%s\'\n", i, argv[i]);
    }
}

int getcmd(char* cmdline, int str_siz){
    int argc = 0;
    if (fgets(cmdline, MAXLINE, stdin) != NULL)
        argc = 1;
    return argc;
}


int parsecmd(char* cmdline, char** argv){
    int argc = 0;
    argv[argc] = strtok(cmdline, " \t\n");
    // printf("argv[%d] == \'%s\'\n", argc, argv[argc]);
    argc++;
    while (argv[argc - 1] != NULL)
    {
        argv[argc] = strtok(NULL, " \t\n");
        // printf("argv[%d] == \'%s\'\n", argc, argv[argc]);
        if(argv[argc]==NULL)
            break;
        else
            argc++;
    }
    argv[argc++] = 0;
}

int builtin_command(char** argv){
    char *order = argv[0];
    if(strcmp(order, "/bin/ls")==0){
        // printf("It is /bin/ls !!!\n");
        return 0;
    }
    else{
        // printf("NOT /bin/ls \n");
        return 1;
    }
}

int main(void){
    char cmdline[MAXLINE];
    char *argv[MAXARGS];
    pid_t pid;
    int status;

    // while(getcmd(cmdline, sizeof(cmdline))>=0){
    while(1){
        cmdline[0] = 0;
        int len = getcmd(cmdline, sizeof(cmdline));
        if (len < 0){
            printf("ERROR: len<0\n");
            return 1;
        }
        parsecmd(cmdline, argv);
        // print_argv(argv);
        if (!builtin_command(argv)) // cd, pwd, mkdir, exit, ., exec, echo, kill 등등이 아니라면
        {
            switch(pid = fork()){
                case -1:
                    perror("fork failed");
                    break;
                case 0: // CHILD
                    if(execv(argv[0],argv)<0){
                    printf("%s: command not found\n", argv[0]);
                    exit(1);
                    }
                    break;
                default: // PARENT
                    waitpid(pid, &status, 0);
                    break;
            }
        }
    }
}