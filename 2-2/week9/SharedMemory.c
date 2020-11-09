#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/msg.h>
#include <sys/shm.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

int main(void) {
    key_t k = ftok(".", 'b');
    int shm_id = shmget(k, sizeof(int), IPC_CREAT | 0x1FF);
    if (shm_id < 0) {
        perror("shmget fail");
        exit(0);
    }

    int* shmaddr = shmat(shm_id, NULL, 0);
    *shmaddr = 1;
    printf("value before fork: %d\n", *shmaddr);
    if (fork() == 0) {
        (*shmaddr) += 1;
        printf("value in the child: %d\n", *shmaddr);
        exit(0);
    } else {
        wait(NULL);
        printf("value in the fork: %d\n", *shmaddr);
    }

    return 0;
}