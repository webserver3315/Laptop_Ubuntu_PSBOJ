#define MAXARGS 128
#define MAXLINE 256
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#define CMD "rm"

void print_error(char* cmd) {
    switch (errno) {
        case EACCES:
            perror(cmd);
            break;
        case EISDIR:
            perror(cmd);
            break;
        case ENOENT:
            perror(cmd);
            break;
        case ENOTDIR:
            perror(cmd);
            break;
        case EPERM:
            perror(cmd);
            break;
        default:
            fprintf(stderr, "Error occured: %d\n", errno);
            break;
    }
}

int main(int argc, char* argv[]) {
    // printf("argc: %d\n", argc);
    if (argc < 2) {
        fprintf(stderr, "Not enough Parameter\n");
        exit(0);
    }
    for (int i = 1; i < argc; i++) {
        if (unlink(argv[i]) == -1) {
            print_error(CMD);
            exit(0);
        }
    }
    return 0;
}