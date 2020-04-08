#include <stdio.h>

int arr[10];

int main(){
    for(int i=0;i<10;i++){
        scanf("%d",&arr[i]);
    }

    for(int i=9;i>0;i--){
        for(int j=0;j<i;j++){
            if(arr[j]<arr[j+1]){
                int tmp=arr[j];
                arr[j]=arr[j+1];
                arr[j+1]=tmp;
            }
        }
    }
    for(int i=9;i>=0;i--)
        printf("%d ", arr[i]);
    printf("\n");
    for(int i=0;i<10;i++)
        printf("%d ",arr[i]);
    return 0;
}