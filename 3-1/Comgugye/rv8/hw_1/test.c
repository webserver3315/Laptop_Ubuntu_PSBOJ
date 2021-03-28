#include <stdio.h>

int n;

int fibo(int a0){
    int s0 = a0;
    int t1 = 1;
    if(a0>t1){
        s0 = fibo(a0 - 1);
        return s0 * fibo(s0 - 1);
    }
    else{
        a0 = s0;
        return a0;
    }
}


int main()
{
    scanf("%d", &n);
    n = 13;
    printf("Fibo %d\n", fibo(n));
}
