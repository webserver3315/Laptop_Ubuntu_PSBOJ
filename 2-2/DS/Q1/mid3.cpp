#include <bits/stdc++.h>

void function3(int arr1[], int len) {
    int arr2[len];
    int arr3[len];
    for (int i = 0; i < len; i++) {
        arr2[i] = -1;
        arr3[i] = -1;
    }
    int n, mm = 1, ctr = 0;
    int i, j;

    for (i = 0; i < len; i++) {
        arr2[i] = arr1[i];

        arr3[i] = 0;
    }

    for (i = 0; i < len; i++) {
        for (j = 0; j < len; j++) {
            if (arr1[i] == arr2[j]) {
                arr3[j] = mm;
                mm++;
            }
        }
        mm = 1;
    }

    for (i = 0; i < len; i++) {
        if (arr3[i] == 2)
            ctr++;
    }
    printf("ctr = %d", ctr);
}

int main() {
    int arr1[] = {12, 35, 7, 63, 56, 12, 34, 55, 9, 7};
    int len = 10;
    function3(arr1, len);
    return 0;
}