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
#define CMD "tail"

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
        print_error(CMD);
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

    // printf("here\n");
    int n;
    char tmp;
    int total_line_cnt = 0;
    while ((n = read(fdr, &tmp, 1) > 0)) {
        // printf("%c", tmp);
        if (tmp == '\n') {
            total_line_cnt++;
        }
    }
    // printf("total_line = %d\n", total_line_cnt);

    int pos = lseek(fdr, 0, SEEK_SET);
    if (pos != 0) {
        return -1;
    }

    int line_cnt = 0;
    while ((n = read(fdr, &tmp, 1) > 0)) {
        if (line_cnt + K > total_line_cnt) {
            printf("%c", tmp);
        }
        if (tmp == '\n') {
            line_cnt++;
        }
    }

    return 0;
}