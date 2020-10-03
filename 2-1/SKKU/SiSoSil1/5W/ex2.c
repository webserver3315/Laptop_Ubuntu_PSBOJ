#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int isMine(int r, int c){//switch문쓸걸..
    if(r==0)
        if(c==1||c==2||c==5||c==8) return 1;
    if(r==1)
        if(c==5||c==8) return 1;
    if(r==2)
        if(c==4) return 1;
    if(r==3)
        if(c==2) return 1;
    if(r==4)
        if(c==1||c==3) return 1;
    if(r==5)
        if(c==3||c==4||c==8) return 1;
    if(r==6)
        if(c==2||c==7||c==8) return 1;
    if(r==7)
        if(c==5||c==6||c==8) return 1;
    if(r==8)
        if(c==3) return 1;
    return 0;
}

//0이면 땅, 1이면 지뢰
int main(){
    int** field;
    field=(int**)malloc(sizeof(int*)*9);
    for(int i=0;i<9;i++){
        field[i]=(int*)malloc(sizeof(int)*9);
        memset(field[i],0,sizeof(int)*9);
    }
    for(int r=0;r<9;r++){
        for(int c=0;c<9;c++){
            if(isMine(r,c)){
                printf("|*");
            }
            else{
                printf("|0");
            }
        }
        printf("|\n");
    }

    return 0;
}