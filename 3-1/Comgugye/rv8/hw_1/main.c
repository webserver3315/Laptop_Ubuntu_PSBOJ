#include<stdio.h>
#include<stdlib.h>

extern int fibonacci();
void display();

int main()
{
        int total, count;
        printf("Enter an integer: ");
        scanf("%d", &total);

        count = fibonacci(total);

        printf("Result: %d\n", count);

}