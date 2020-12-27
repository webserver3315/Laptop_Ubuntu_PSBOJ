#include <fcntl.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#define QSIZE 5
#define LOOP 30

typedef struct {
    int data[QSIZE];
    int back;
    int front;
    int count;
    pthread_mutex_t lock;
    pthread_cond_t notfull;
    pthread_cond_t notempty;
} queue_t;

void *produce(void *args);
void *consume(void *args);
void put_data(queue_t *q, int d);
int get_data(queue_t *q);

void push_q(queue_t *q, int d) {
    q->data[q->back] = d;
    q->back = (q->back + 1) % (QSIZE);
    q->count++;
    printf("put data %d to queue\n", d);
}
int pop_q(queue_t *q) {
    int ret = q->data[q->front];
    q->front = (q->front + 1) % (QSIZE);
    q->count--;
    printf("got data %d from queue\n", ret);
    return ret;
}

int is_full(queue_t *q) {
    if (q->count == QSIZE)
        return 1;
    return 0;
}

int is_empty(queue_t *q) {
    if (q->count == 0)
        return 1;
    return 0;
}

void put_data(queue_t *q, int d) {
    pthread_mutex_lock(&(q->lock));
    if (is_full(q)) {
        pthread_cond_wait(&(q->notfull), &(q->lock));
    }
    push_q(q, d);
    pthread_cond_signal(&(q->notempty));
    pthread_mutex_unlock(&(q->lock));
    //  sleep(0.1);
}
int get_data(queue_t *q) {
    pthread_mutex_lock(&(q->lock));
    if (is_empty(q)) {
        pthread_cond_wait(&(q->notempty), &(q->lock));
    }
    int ret = pop_q(q);
    pthread_cond_signal(&(q->notfull));
    pthread_mutex_unlock(&(q->lock));
    //  sleep(0.1);
    return ret;
}

queue_t *qinit() {
    queue_t *q;
    q = (queue_t *)malloc(sizeof(queue_t));
    q->back = q->count = 0;
    pthread_mutex_init(&q->lock, NULL);
    pthread_cond_init(&q->notfull, NULL);
    pthread_cond_init(&q->notempty, NULL);
    return q;
}

void qdelete(queue_t *q) {
    pthread_mutex_destroy(&q->lock);
    pthread_cond_destroy(&q->notfull);
    pthread_cond_destroy(&q->notempty);
    free(q);
}

void *consume(void *args) {
    int i, d;
    queue_t *q = (queue_t *)args;
    for (i = 0; i < LOOP; i++) {
        d = get_data(q);
    }
    pthread_exit(NULL);
}

void *produce(void *args) {
    int i, d;
    queue_t *q = (queue_t *)args;
    for (i = 0; i < LOOP; i++) {
        d = i;
        put_data(q, d);
    }
    pthread_exit(NULL);
}

int main() {
    queue_t *q;
    pthread_t producer, consumer;

    q = qinit();

    pthread_create(&producer, NULL, produce, (void *)q);
    pthread_create(&consumer, NULL, consume, (void *)q);

    pthread_join(producer, NULL);
    pthread_join(consumer, NULL);

    qdelete(q);
}
