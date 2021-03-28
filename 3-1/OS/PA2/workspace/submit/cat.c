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
#define CMD "cat"

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
    // printf("argv[0]: %s\n", argv[0]);
    // printf("argv[1]: %s\n", argv[1]);
    if (argc < 2) {
        fprintf(stderr, "%s: %s\n", argv[0], strerror(errno));
        exit(0);
    }

    char path[MAXLINE];
    char filename[MAXLINE];
    getcwd(path, MAXLINE);
    strcat(path, "/");
    strcat(path, argv[1]);
    strcpy(filename, path);
    // printf("filename is \'%s\', argv is \'%s\' \n", filename, argv[1]);
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

    int n;
    // char buf[MAXLINE];
    char tmp;
    while ((n = read(fdr, &tmp, 1) > 0)) {
        // printf("n = %d\n", n);
        printf("%c", tmp);
    }
    // printf("n = %d\n", n);

    return 0;
}