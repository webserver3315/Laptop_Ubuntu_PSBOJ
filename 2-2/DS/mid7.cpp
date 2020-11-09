#include <bits/stdc++.h>
void function1() {
    int len = 5;
    int arr1[] = {1, 2, 3, 4, 5};
    int arr2[] = {0, 0, 0, 0, 0};
    int i, j;

    for (i = 0; i < len; i++)
        arr2[i] = arr1[len - 1 - i] * arr1[len - 1 - i];

    for (i = 0; i < len; i++)
        printf("%d ", arr2[i]);

    return;
}

int main() {
    function1();
    return 0;
}