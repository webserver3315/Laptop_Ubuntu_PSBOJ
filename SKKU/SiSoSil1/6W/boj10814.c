#include <stdio.h>
#include <string.h>
#define swap(type, a, b) do{type tmp = a; a=b; b=tmp;}while(0)

typedef struct mypair{
    char name[100];
    int sc;
}pair;

int n, m;
pair parr[100000];

int main(){
    scanf("%d", &m);
    for(int i=0;i<m;i++){
        scanf("%d %s", &parr[i].sc, &parr[i].name);
    }

    for(int i=m-1;i>0;i--){
        for(int j=0;j<i;j++){
            if(parr[j].sc>parr[j+1].sc){
                swap(pair, parr[j], parr[j+1]);
            }
            else if(parr[j].sc==parr[j+1].sc){
                // if(parr[j].name>parr[j+1].name){
                if(strcmp(parr[j].name, parr[j+1].name)>0){
                    swap(pair, parr[j], parr[j+1]);
                }
            }
        }
    }
    for(int i=0;i<m;i++){
        printf("%d %s\n", parr[i].sc, parr[i].name);
    }
    return 0;
}