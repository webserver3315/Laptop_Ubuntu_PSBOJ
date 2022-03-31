#include <stdio.h>

int main(){

    for(int i=0;i<26;i++){
        printf("\"%c\", ",'0'+i);
    }
    printf("\n");
    for(int i=0;i<26;i++){
        printf("\"%c\", ",'A'+i);
    }
}