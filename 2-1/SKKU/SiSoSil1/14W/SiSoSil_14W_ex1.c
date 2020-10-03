#include <stdio.h>
#define SIZE 5

double target[] = {1.5, 2.1, 1.7, 0.8, 3.1};
double add_mean(double input, double* m);
double add_target_mean(double* m);

int main() {
    double target_mean, mean, input;
    int j;

    for (j = 0; j < 5; j++) {
        scanf("%lf", &input);
        add_mean(input, &mean);
        printf("mean=%lf\n", mean);
    }

    for (j = 0; j < 5; j++) {
        add_target_mean(&target_mean);
    }
    printf("target mean=%lf\n", target_mean);
    return 0;
}