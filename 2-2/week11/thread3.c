#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define NUM_THREADS 4

int value;

void* thread(void* arg) {
    long id = (long)arg;
    value++;
    printf("thread#%ld: - value:%d\n", id, value);
    pthread_exit(NULL);
}

int main() {
    pthread_t tid[NUM_THREADS];
    long t;
    for (t = 0; t < NUM_THREADS; t++) {
        if (pthread_create(&tid[t], NULL, thread, (void*)t)) {
            printf("ERROR: pthread creation failed.\n");
            exit(1);
        }
    }
    for (t = 0; t < NUM_THREADS; t++) {
        pthread_join(tid[t], NULL);
    }
    return 0;
}