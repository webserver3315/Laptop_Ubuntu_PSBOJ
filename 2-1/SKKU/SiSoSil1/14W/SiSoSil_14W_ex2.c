#include <stdio.h>

void add_mean(double input, double* m) {
    static double sum;
    static double count;
    sum += input;
    count += 1;
    *m = sum / count;
}

void add_target_mean(double* m) {
    extern double target[];
    double sum = 0;
    for (int i = 0; i < 5; i++) {
        sum += target[i];
    }
    *m = sum / 5;
    // printf("m is %lf\n", *m);
}