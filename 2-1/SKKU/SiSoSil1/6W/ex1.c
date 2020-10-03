#include <stdio.h>

typedef struct mypair{
    int a;
    int b;
}pair;

int n;
pair parr[50];
int rank[50];

int main(){
    scanf("%d",&n);
    for(int i=0;i<n;i++){
        scanf("%d",&parr[i].a);
        parr[i].b=i;
    }

    for(int i=n-1;i>0;i--){
        for(int j=0;j<i;j++){
            if(parr[j].a>parr[j+1].a){
                pair tmp = parr[j];
                parr[j]=parr[j+1];
                parr[j+1]=tmp;
            }
        }
    }
    for(int i=0;i<n;i++){
        rank[parr[i].b]=i;
    }
    for(int i=0;i<n;i++){
        printf("%d ",rank[i]);
    }
    printf("\n");
    return 0;
}