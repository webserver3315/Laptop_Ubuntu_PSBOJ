#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

int main() {
    char test[50][50];

    for (int i = 0; i < 10; i++) {
        strcpy(test[i], "dekirukana?");
    }
    for (int i = 0; i < 10; i++) {
        printf("test[%d] = %s\n", i, test[i]);
        printf("strcmp %dth is %d\n", i, strcmp(test[i], "dekirukana?"));
    }

    return 0;
}