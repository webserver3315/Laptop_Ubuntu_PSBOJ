#include <iostream>

using namespace std;

// To heapify a subtree rooted with node i which is
// an index in arr[]. N is size of heap
void heapify(int arr[], int n, int i) {
    int smallest = i;   // Initialize smallest as root
    int l = 2 * i + 1;  // left = 2*i + 1
    int r = 2 * i + 2;  // right = 2*i + 2

    // If left child is larger than root
    if (l < n && arr[l] < arr[smallest])
        smallest = l;

    // If right child is larger than smallest so far
    if (r < n && arr[r] < arr[smallest])
        smallest = r;

    // If smallest is not root
    if (smallest != i) {
        swap(arr[i], arr[smallest]);

        // Recursively heapify the affected sub-tree
        heapify(arr, n, smallest);
    }
}

// Function to build a Max-Heap from the given array
void buildHeap(int arr[], int n) {
    // Index of last non-leaf node
    int startIdx = (n / 2) - 1;

    // Perform reverse level order traversal
    // from last non-leaf node and heapify
    // each node
    for (int i = startIdx; i >= 0; i--) {
        heapify(arr, n, i);
    }
}

// A utility function to print the array
// representation of Heap
void printHeap(int arr[], int n) {
    cout << "Array representation of Heap is:\n";

    for (int i = 0; i < n; ++i)
        cout << arr[i] << " ";
    cout << "\n";
}

// Driver Code
int main() {
    // Binary Tree Representation
    // of input array
    // 1
    //           /     \ 
    // 3         5
    //      /    \     /  \ 
    // 4      6   13  10
    //    / \    / \ 
    // 9   8  15 17
    int arr[] = {35, 33, 42, 10, 14, 19, 27, 44, 26, 31};

    int n = sizeof(arr) / sizeof(arr[0]);

    buildHeap(arr, n);

    printHeap(arr, n);
    // Final Heap:
    // 17
    //           /      \ 
    // 15         13
    //       /    \      /  \ 
    // 9      6    5   10
    //     / \    /  \ 
    // 4   8  3    1

    return 0;
}