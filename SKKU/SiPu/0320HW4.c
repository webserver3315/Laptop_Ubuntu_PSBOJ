#include <stdio.h>

int sum_array(int a[], unsigned len){
    int i;
    int result=0;
    for(i=0;i<=len-1;i++)
        result+=a[i];
    return result;
}

int main(){
    int a[10]={1,2,3,4,5,6,7,8,9,10};
    unsigned len=0;

    printf("sum_array return = %d\n",sum_array(a,len));

    return 0;
}