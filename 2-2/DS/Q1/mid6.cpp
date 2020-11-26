#include <bits/stdc++.h>

void function6(int arr[], int len) {
    int i, j, temp, max;
    for (int i = len - 1; i > 0; i--) {
        int max = i;
        for (int j = 0; j < i; j++)
            if (arr[j] > arr[max])
                max = j;
        int temp = arr[max];
        arr[max] = arr[i];
        arr[i] = temp;
    }

    for (int i = 0; i < len; ++i)
        printf("%d, ", arr[i]);
}

int main() {
    int arr1[] = {12, 35, 7, 63, 56, 55, 9};
    int len = 7;
    function6(arr1, len);
    return 0;
}