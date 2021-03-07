#include <assert.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <unistd.h>

int main() {
    char c;
    int fd = open("temp.txt", O_RDONLY);
    if (fork() == 0) {
        read(fd, &c, 1);
        exit(0);
    } else {
        wait(NULL);
        read(fd, &c, 1);
        printf("c=%c\n", c);
    }
    return 0;
}