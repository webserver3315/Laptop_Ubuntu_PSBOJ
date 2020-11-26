#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

struct thread_data {
    int tid;
    int result;
};

typedef struct args {
    struct thread_data temp;
    int argc;
    int *vct1;
    int *vct2;
} ARGUMENTS;

int M;
int N;

int calc(int tid, int argc, int *vct1, int *vct2) {
    int ret = 0;
    for (int i = 0; i < argc; i++) {
        ret += vct1[i] * vct2[i];
        // printf("tid(%d): ret(%d) = vct1[%d](%d) * vct2[%d](%d)\n", tid, ret, i, vct1[i], i, vct2[i]);
    }
    return ret;
}

void *thread_mvm(void *arg) {
    ARGUMENTS *args = (ARGUMENTS *)arg;
    int tid = args->temp.tid;
    int argc = args->argc;
    int *vct1 = args->vct1;
    int *vct2 = args->vct2;
    // printf("tid[%d]'s thread\n", tid);

    args->temp.result = calc(tid, argc, vct1, vct2);
    // printf("THREAD_result[%d] = %d\n", tid, args->temp.result);

    pthread_exit(NULL);
}

int main(int argc, char *argv[]) {
    if (argc != 3) {
        printf("Usage: %s <M> <Numn>\n", argv[0]);
        exit(1);
    }
    M = atoi(argv[1]);
    N = atoi(argv[2]);

    // M = 4;
    // N = 5;

    pthread_t tid[M];
    // struct thread_data t_data[M];
    ARGUMENTS tt_data[M];

    srand(time(NULL));

    int MN[M][N];
    int N1[N];

    for (int r = 0; r < M; r++) {
        for (int c = 0; c < N; c++) {
            // scanf("%d", &MN[r][c]);
            MN[r][c] = rand() % 10;
        }
    }
    for (int r = 0; r < N; r++) {
        // scanf("%d", &N1[r]);
        N1[r] = rand() % 10;
    }
    printf("*** MATRIX ***\n");
    for (int r = 0; r < M; r++) {
        for (int c = 0; c < N; c++) {
            printf("%d ", MN[r][c]);
        }
        printf("\n");
    }
    printf("*** VECTOR ***\n");
    for (int r = 0; r < N; r++) {
        printf("%d ", N1[r]);
        printf("\n");
    }

    long i;
    for (i = 0; i < M; i++) {
        // printf("i==%d\n", i);
        tt_data[i].temp.tid = i;
        tt_data[i].argc = N;
        tt_data[i].vct1 = MN[i];
        tt_data[i].vct2 = N1;
        for (int j = 0; j < N; j++) {
            // printf("%d * %d\n", MN[i][j], N1[j]);
        }
        if (pthread_create(&tid[i], NULL, thread_mvm, (void *)&(tt_data[i]))) {
            printf("ERROR: pthread creation failed.\n");
            exit(1);
        }
    }

    for (i = 0; i < M; i++) {
        pthread_join(tid[i], NULL);
    }

    printf("\n*** RESULT ***\n");
    for (int r = 0; r < M; r++) {
        printf("%d ", tt_data[r].temp.result);
        printf("\n");
    }

    return 0;
}
