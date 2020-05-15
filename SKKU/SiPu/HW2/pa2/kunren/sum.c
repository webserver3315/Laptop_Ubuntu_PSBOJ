#include <stdio.h>
int sum(int a, int b){
    return a+b;
}

int main(){
    int a=1; int b=2;
    int c=sum(1,2);
    printf("%d\n",c);
    return c;
}