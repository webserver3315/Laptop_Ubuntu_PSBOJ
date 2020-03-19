#include <stdio.h>

#define DELTA sizeof(int)

int main(){
    int i;
    for(i=10;i-DELTA>=0;i-=DELTA)
        printf("%d\n",i);
    return 0;
}