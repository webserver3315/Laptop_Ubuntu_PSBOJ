#include <unistd.h>

int main (void)
{
	int i = 2, j = 3;

	if(i<j)	write(1, "bye_world\n", 10);
	else	write(1, "hello_world\n", 12);

	return 0;
}

