#include <pthread.h>
#include <stdio.h>

int num;
pthread_mutex_t m = PTHREAD_MUTEX_INITIALIZER;

void* inc(void* tid) {
    int iter = 10000;
    while (iter--) {
        pthread_mutex_lock(&m);
        num++;
        pthread_mutex_unlock(&m);
    }
}

void* dec(void* tid) {
    int iter = 10000;
    while (iter--) {
        pthread_mutex_lock(&m);
        num--;
        pthread_mutex_unlock(&m);
    }
}

int main() {
    int t;

    for (int t = 0; t < 10; t++) {
        num = 0;
        pthread_t thread_inc, thread_dec;
        pthread_create(&thread_inc, NULL, &inc, NULL);
        pthread_create(&thread_dec, NULL, &dec, NULL);

        pthread_join(thread_inc, NULL);
        pthread_join(thread_dec, NULL);
        printf("#%d, %d\n", t, num);
    }
    return 0;
}