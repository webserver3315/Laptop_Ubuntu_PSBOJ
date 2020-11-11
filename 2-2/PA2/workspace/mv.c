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
    if (argc < 3) {
        printf("Not enough Parameter\n");
        return -1;
    }
    int ret;
    char *oldname, *newname;
    oldname = argv[1];
    newname = argv[2];
    printf("\'%s\' \'%s\'\n", oldname, newname);

    ret = rename(oldname, newname);

    if (ret == 0) {
        printf("File renamed successfully");
    } else {
        printf("Error: unable to rename the file");
    }
    return 0;
}