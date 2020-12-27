// #include <bits/stdc++.h>
#include <algorithm>
#include <iostream>
using namespace std;

// int arr[11] = {0, 35, 33, 42, 10, 14, 19, 27, 44, 26, 31};
int arr[11] = {0, 35, 33, 42, 10, 14, 19, 27, 44, 26, 31};

void sift_down(int* arr, int current, int last) {
    int left;
    int right;
    int max;

    while ((current * 2) + 1 <= last) {
        left = (current * 2) + 1;
        right = (current * 2) + 2;
        max = current;

        if (arr[left] > arr[max]) {
            max = left;
        }

        if (right <= last && arr[right] > arr[max]) {
            max = right;
        }

        if (max != current) {
            swap(arr[current], arr[max]);
            current = max;
        } else {
            return;
        }
    }
}

int main() {
    sift_down(arr, 1, 11);
    for (int i = 0; i <= 10; i++) {
        printf("%d ", arr[i]);
    }
    return 0;
}