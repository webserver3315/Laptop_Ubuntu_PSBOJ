#include <stdio.h>
int main(){
    unsigned char c;
    while((c=getchar())!=EOF)
        putchar(c);
    return 0;
}