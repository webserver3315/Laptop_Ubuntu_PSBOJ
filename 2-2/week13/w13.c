#include <math.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define INTERVAL 10000

int thread_num;
int point_per_thread;
int point_in_circle = 0;
int total_point = 0;
int r = 1;
pthread_mutex_t m = PTHREAD_MUTEX_INITIALIZER;

double dist(double a, double b) {
    double ret;
    // ret = sqrt(a * a + b * b);
    ret = (a * a + b * b);
    return ret;
}

void* monte(void* tid) {
    for (int i = 0; i < point_per_thread; i++) {
        pthread_mutex_lock(&m);
        double x, y, d;
        x = (double)(rand() % (INTERVAL + 1)) / INTERVAL;
        y = (double)(rand() % (INTERVAL + 1)) / INTERVAL;
        d = dist(x, y);
        if (d <= 1) {
            point_in_circle++;
        }
        total_point++;
        pthread_mutex_unlock(&m);
    }
}

int main(int argc, char* argv[]) {
    // printf("argc = %d\n", argc);
    if (argc != 3) {
        printf("Not enough Parameter\n");
        exit(1);
    }
    srand((unsigned)time(NULL));

    thread_num = atoi(argv[1]);
    point_per_thread = atoi(argv[2]);
    // printf("%d %d\n", thread_num, point_per_thread);

    pthread_t* arr_thread = malloc(sizeof(pthread_t) * thread_num);

    for (int i = 0; i < thread_num; i++) {
        pthread_create(&arr_thread[i], NULL, &monte, NULL);
        // printf("%dth thread started\n", i);
    }
    for (int i = 0; i < thread_num; i++) {
        pthread_join(arr_thread[i], NULL);
    }

    // double pi = (double)(4 * point_in_circle) / (thread_num * point_per_thread);
    // printf("point_in_circle = %d, thread_num * point_per_thread = %d\n", point_in_circle, thread_num * point_per_thread);
    double pi = (double)(4 * point_in_circle) / total_point;
    // printf("pi is %lf\n", pi);
    printf("%lf\n", pi);

    free(arr_thread);

    return 0;
}