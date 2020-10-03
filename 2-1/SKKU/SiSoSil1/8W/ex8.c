#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main() {

    int x, y, temp;

    printf("input 2 numbers : ");
    scanf("%d %d", &x, &y);

    if (x <= 0 || y <=0) {
        printf("Wrong Input\n");
        return 0;
    }

    if (x > y) {
        temp = x;
        x = y;
        y = temp;
    }

    int* div_1 = (int *)malloc(sizeof(int) * x);
    int* div_2 = (int *)malloc(sizeof(int) * y);
    int x_count = 0, y_count = 0;
    int i, j;

    for (i = 1; i <= x; i++) {//수정, 0으로 안나누도록
        if (x % i == 0) {
            div_1[x_count] = i;
            x_count++;
        }
    }
    printf("\n");

    for (j = 1; j <= y; j++) {//0으로 안나누도록 수정
        if (y % j == 0) {
            div_2[y_count] = j;
            y_count++;
        }
    }


    int* x_div = (int *)malloc(sizeof(int) * x_count);
    memcpy(x_div, div_1, sizeof(int) * x_count);//할당된 크기보다 많이 복사하면 안된다.

    int* y_div = (int *)malloc(sizeof(int) * y_count);
    memcpy(y_div, div_2, sizeof(int) * y_count);//마찬가지로 수정

    free(div_1);
    free(div_2);

    printf("divisor of %d : ", x);
    for (i = 0; i < x_count; i++) {
        printf("%d ", x_div[i]);
    }
    printf("\n");

    printf("divisor of %d : ", y);
    for(j = 0; j < y_count; j++) {
        printf("%d ", y_div[j]);
    }
    printf("\n");

    printf("common divisor : ");
    for (j = 0; j < x_count; j++) {
       for (i = 0; i < y_count; i++) {
            if (x_div[j] == y_div[i])
                printf("%d ", y_div[i]);
        }
    }
    printf("\n");


    free(x_div);
    free(y_div);

    return 0;

}

