/* 
**    WARNING : DO NOT EDIT THIS FILE!
**    ALL CHANGES ON THIS FILE WILL BE DISCARDED!
*/

#define GRADING

#include <stdio.h>

#define BUF_LEN 1024
int fact(int input);

int fact_stop(int input)
{
    return 1;
}

int main(int argc, char* argv[])
{
    char buf[BUF_LEN];
    int fact_input;

    // input from args
    if (argc > 1)
    {
	sscanf(argv[1], "%d", &fact_input);
	printf("%d\n", fact(fact_input));
    }

    // input from stdin
    else
    {
	printf("Input: ");
	fgets(buf, BUF_LEN, stdin);
	sscanf(buf, "%d", &fact_input);
	printf("fact(%d) = %d\n", fact_input, fact(fact_input));
    }
    
    
    return 0;
}
