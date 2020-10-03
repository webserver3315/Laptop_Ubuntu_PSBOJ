#include <stdio.h>

int n;

void makeline(int i){
    for(int idx=0;idx<2*n-1;idx++){
        if(idx==n-1 || idx==n-1-i || idx==n-1+i) printf("*");
        else printf(" ");
    }
    printf("\n");
    return;
}

int main(){
    int n;
    scanf("%d",&n);
    for(int i=0;i<n-1;i++){
        for(int idx=0;idx<2*n-1;idx++){
            if(idx==n-1 || idx==n-1-i || idx==n-1+i) printf("*");
            else printf(" ");
        }
        printf("\n");
    }

    for(int i=0;i<n*2-1;i++){
        printf("*");
    }
    printf("\n");
    for(int i=n-2;i>=0;i--){
        for(int idx=0;idx<2*n-1;idx++){
            if(idx==n-1 || idx==n-1-i || idx==n-1+i) printf("*");
            else printf(" ");
        }
        printf("\n");
    }

    return 0;
}