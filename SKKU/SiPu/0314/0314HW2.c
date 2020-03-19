#include <stdio.h>
#include <time.h>

int a=40000;
int b=50000;
float c=1e20;

int main(){
    
    printf("40000*40000= %d\n",a*a);
    printf("50000*50000= %d\n",b*b);
    printf("(1e20+(-1e20))+3.14 = %f\n",(c-c)+3.14);
    printf("1e20+((-1e20)+3.14) = %f\n",c+(-c+3.14));

    return 0;
}