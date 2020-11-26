#define MAXARGS 128
#define MAXLINE 256
#include <dirent.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

#define CMD "mv"

void print_error(char *cmd) {
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

int main(int argc, char *argv[]) {
    // printf("argc: %d\n", argc);
    if (argc < 3) {
        if (argc == 1) {
            fprintf(stderr, "mv: missing file operand\n");
        } else if (argc == 2) {
            fprintf(stderr, "mv: missing destination file operand after \'%s\'\n", argv[1]);
        }
        exit(0);
    }
    int ret;
    char *oldname, *newname;
    oldname = argv[1];
    newname = argv[2];
    // printf("\'%s\' \'%s\'\n", oldname, newname);

    if (newname[0] == '/') {  //절대경로라면
        strcat(newname, "/");
        strcat(newname, oldname);
        if (rename(oldname, newname) != 0) {
            print_error(CMD);
            exit(0);
        }
    } else {
        DIR *isD;
        isD = opendir(newname);
        if (isD == NULL) {  //일반 파일명이면
            if (rename(oldname, newname) != 0) {
                print_error(CMD);
                exit(0);
            }
        } else {  //상대경로 디렉토리명이면
            char current_dir[256];
            getcwd(current_dir, 256);
            strcat(current_dir, "/");
            strcat(current_dir, newname);
            strcat(current_dir, "/");
            strcat(current_dir, oldname);
            if (rename(oldname, current_dir) != 0) {
                print_error(CMD);
                exit(0);
            }
            closedir(isD);
        }
    }
    return 0;
}