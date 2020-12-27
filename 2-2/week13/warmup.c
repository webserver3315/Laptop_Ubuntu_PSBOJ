#include <pthread.h>
#include <stdio.h>

int num;

void* inc(void* tid) {
    int iter = 10000;
    while (iter--)
        num++;
}

void* dec(void* tid) {
    int iter = 10000;
    while (iter--) {
        num--;
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