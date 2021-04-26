#include "types.h"
#include "user.h"
#include "param.h"
#include "fcntl.h"

int main(int argc, char** argv) {
	printf(1, "mmap test \n");
	int i;
	int size = 4096;
	int fd = open("README", O_RDWR);
	char* text = mmap(fd, 2048,   size, MAP_PROT_READ);			      //File example
	char* text2 = mmap(-1, 0,  size, MAP_PROT_WRITE|MAP_PROT_READ|MAP_POPULATE);  //ANONYMOUS example


	printf(1,"\n============FILE MAP START==========\n\n\n\n");
	for (i = 0; i < size; i++) 
		printf(1, "%c", text[i]);
	printf(1,"\n============FILE MAP END==========\n\n\n\n");

	text2[0] = 's';
	text2[4095] = 'Y';
	for (i = 0; i < size; i++) 
		printf(1, "%c", text2[i]);
	printf(1,"\n============anonymous mmap end==========\n");

	printf(1, "1st munmap\n");
	munmap(text, size);
	printf(1, "2nd munmap\n");
	munmap(text2, size);
	printf(1, "complete\n");
	exit();
}
