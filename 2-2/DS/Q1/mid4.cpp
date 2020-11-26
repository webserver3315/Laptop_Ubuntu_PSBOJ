#include <bits/stdc++.h>

void printarr(int arr1[], int len) {
    for (int i = 0; i < len; i++) {
        printf("%d ", arr1[i]);
    }
    printf("\n");
}

void function4(int arr1[], int len) {
    // int arr2[len];
    int arr2[10];
    int i, j, ctr;

    for (int i = 0; i < 10; i++) {
        arr2[i] = -1;
    }
    printarr(arr2, len);

    for (i = 0; i < len; i++) {
        ctr = 1;
        for (j = i + 1; j < len; j++) {
            if (arr1[i] == arr1[j]) {
                ctr++;
                arr2[j] = 0;
            }
        }
        if (arr2[i] != 0) {
            arr2[i] = ctr;
        }
        printf("i = %d\n", i);
        printarr(arr2, len);
        printf("\n");
    }

    for (i = 0; i < len; i++) {
        if (arr2[i] != 0) {
            printf("%d, ", arr2[i]);
        } else {
            printf("0, ");
        }
    }
}

int main() {
    int arr1[] = {12, 35, 7, 63, 56, 12, 7, 55, 9, 7};
    int len = 10;
    function4(arr1, len);
    return 0;
}