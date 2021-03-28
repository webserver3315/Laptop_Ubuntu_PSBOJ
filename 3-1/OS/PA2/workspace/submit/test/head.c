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
#define CMD "head"

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
        fprintf(stderr, "head: not enough parameter\n");
        exit(0);
    }

    int K = 10;
    char filename[MAXLINE];
    if (argc >= 3) {
        K = atoi(argv[2]);
        strcpy(filename, argv[3]);
        // printf("K==%d\n", K);
    } else {
        strcpy(filename, argv[1]);
    }
    int fdr = open(filename, O_RDONLY, 0644);
    if (fdr < 0) {
        perror(CMD);
        exit(0);
    }
    struct stat sb;
    if (fstat(fdr, &sb) != 0) {
        print_error(CMD);
        exit(0);
    }
    if (S_ISDIR(sb.st_mode)) {
        errno = EISDIR;
        print_error(CMD);
        exit(0);
    }

    int n;
    char tmp;
    int line_cnt = 0;
    while ((n = read(fdr, &tmp, 1) > 0)) {
        printf("%c", tmp);
        if (tmp == '\n') {
            line_cnt++;
            if (line_cnt == K)
                return 0;
        }
    }
    // printf("n = %d\n", n);

    return 0;
}