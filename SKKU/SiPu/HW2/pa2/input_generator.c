#include <unistd.h>
#include <stdio.h>
#include <fcntl.h>

int main (void) 
{
	int i,j,k,fd;
	int a,b;
	printf("Select input file to generate <1/2>?: ");
	scanf("%d", &i);
	if (i==1) {
		printf("Type two integers: ");
		scanf("%d %d", &j, &k);
		if ((fd = open("./pa2-1/pa2-1.in", O_CREAT | O_TRUNC | O_RDWR))<0) {
			printf("fail to open file ./pa2-1/pa2-1.in\n");
			return 1;
		}
		write(fd, &j, sizeof(int));
		write(fd, &k, sizeof(int));
		lseek(fd, 0, SEEK_SET);
		read(fd, &a, sizeof(int));
		read(fd, &b, sizeof(int));
		printf("* [%d/%d] are successfully written to [./pa2-1/pa2-1.in]\n",
			a,b);
		close(fd);
	} else if (i==2) {
		printf ("Type one integer: ");
		scanf("%d", &j);
		if((fd = open("./pa2-2/pa2-2.in", O_CREAT | O_TRUNC | O_RDWR))<0) {
			printf("fail to open file ./pa2-2/pa2-2.in\n");
			return 1;
		}
		write(fd, &j, sizeof(int));
		lseek(fd, 0, SEEK_SET);
		read(fd, &a, sizeof(int));
		printf("* [%d] is successfully written to [./pa2-2/pa2-2.in]\n",
			a);
		close(fd);	
	} else {
		printf("Try again\n");
		return 0;
	}
	return 0;
}

