void swap(long long int array[], int a, int b) {
     int t = array[a];
     array[a] = array[b];
     array[b] = t;
 }

int partition (long long int arr[], int low, int high) {
    int pivot = arr[high]; // pivot
    int i = (low - 1); // Index of smaller element
     for (int j = low; j <= high- 1; j++) {
         if (arr[j] <= pivot) {
            i++; // increment index of smaller element
            swap(arr, i, j);
            }
      }
    swap(arr, i + 1, high);
    return (i + 1);
}


void quick_sort(long long int arr[], int low, int high) {
     if (low < high) {
        int pi = partition(arr, low, high);
        quick_sort(arr, low, pi - 1);
       quick_sort(arr, pi + 1, high);
     }
 }
 
 
int binary_search(long long int* point, int size, long long int target){
    // Sort 전제
    int start = 0;
    int end = 48;
    int mid = (start + end) / 2;
    while(start<=end){
        printf("mid = %d\n", mid);
        mid = (start + end) / 2;
        printf("start mid end == %d %d %d\n", start, mid, end);
        printf("point[mid] vs target == %d vs %d\n", point[mid], target);
        if(point[mid]==target){
            return mid;
        }
        else if(point[mid]<target){
            printf("right win\n");
            start = mid + 1;
        }
        else{
            printf("left win\n");
            end = mid - 1;
        }
    }
    return -1; // NOT FOUND
}
