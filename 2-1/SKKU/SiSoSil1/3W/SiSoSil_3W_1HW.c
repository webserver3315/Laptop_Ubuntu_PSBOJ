#include <stdio.h>

int printbinary(int n) {
	if (n == 0)
		return 0;
	printbinary(n / 2);
	if (n % 2)
		printf("1");
	else
		printf("0");
	return 0;
}

int main() {
	int n;
	while (scanf("%d",&n)) {
		printbinary(n);
		printf("\n");
	}

	return 0;
}