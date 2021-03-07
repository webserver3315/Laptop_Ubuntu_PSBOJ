#include <errno.h>
#include <fcntl.h>  // O_WRONLY
#include <netdb.h>
#include <stdio.h>  // printf()
#include <stdlib.h>
#include <string.h>  // strlen()
#include <sys/socket.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>  // write(), close()

#define MAXARGS 128
#define MAXLINE 256
#define CMD "cp"

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
    if (argc < 3) {
        if (argc == 1) {
            fprintf(stderr, "cp: missing file operand\n");
        } else if (argc == 2) {
            fprintf(stderr, "cp: missing destination file operand after \'%s\'\n", argv[1]);
        }
        exit(0);
    }

    char filename[MAXLINE];
    strcpy(filename, argv[1]);
    int fdr = open(filename, O_RDONLY, 0644);
    if (fdr < 0) {
        print_error(CMD);
        exit(0);
    }
    char filename2[MAXLINE];
    strcpy(filename2, argv[2]);
    int fdw = open(filename2, O_WRONLY | O_CREAT, 0644);

    int n;
    char tmp;
    while ((n = read(fdr, &tmp, 1) > 0)) {
        // printf("%c", tmp);
        write(fdw, &tmp, 1);
    }
    // printf("n = %d\n", n);

    return 0;
}