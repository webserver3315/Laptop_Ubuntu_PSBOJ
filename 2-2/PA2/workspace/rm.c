#define MAXARGS 128
#define MAXLINE 256
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

int main(int argc, char* argv[]) {
    printf("argc: %d\n", argc);
    if (argc < 2) {
        printf("Not enough Parameter\n");
        return -1;
    }
    for (int i = 1; i < argc; i++) {
        if (unlink(argv[i]) == -1) {
            fprintf(stderr, "%s remove FAILED, ERROR OCCURED: %s\n", argv[i], strerror(errno));
        } else {
            printf("%s file DELETED SUCCESSFULLY\n", argv[i]);
        }
    }
    return 0;
}