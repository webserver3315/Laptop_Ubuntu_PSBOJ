#include <stdio.h>
#include <time.h>

typedef struct {
    int a[2];
    double b;
}str;

double printdouble(int n){
    str tmp;
    tmp.b=3.14;
    tmp.a[n]=1234567;
    return tmp.b;
}

int main(){
    
    for(int i=0;i<7;i++){
        printf("fun(%d) = %f\n",i,printdouble(i));
    }

    return 0;
}