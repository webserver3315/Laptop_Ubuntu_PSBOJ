#include <bits/stdc++.h>
void function5(int arr1[], int len)

{
    int i, j = 0, l, s;
    l = 0;
    for (i = 0; i < len; i++) {
        if (l < arr1[i]) {
            l = arr1[i];
            j = i;
        }
    }
    s = 0;
    for (i = 0; i < len; i++) {
        if (i != j) {
            if (s < arr1[i]) {
                s = arr1[i];
            }
        }
    }

    for (int i = 0; i < len; i++) {
        printf("%d ", arr1[i]);
    }
    printf("\n");
    printf("%d", s);
}

int main() {
    int arr1[] = {12, 35, 7, 63, 56, 55, 9};
    int len = 7;
    function5(arr1, len);
    return 0;
}