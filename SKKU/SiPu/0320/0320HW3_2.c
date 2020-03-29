#include <string.h>
#include <stdio.h>

int strlonger(char* s, char* t){
    return strlen(s)>strlen(t);
}

int main(){
    char str1[10]="string";
    char str2[10]="notstring";
    if(strlonger(str1,str2))
        printf("left is longer\n");
    else
        printf("right is longer or same\n");

    return 0;
}