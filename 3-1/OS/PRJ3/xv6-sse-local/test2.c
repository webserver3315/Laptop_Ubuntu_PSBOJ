#include "types.h"
#include "user.h"
#include "param.h"
#include "fcntl.h"

int main(int argc, char** argv) {
	printf(1, "mmap test \n");
    printf(1, "========== mmap_anonymous_prepaging test START ==========\n");
    printf(1, "========== START ==========\n");
	int i;
	int size = 4096;
	// int fd = open("README", O_RDWR);
	char* text2 = mmap(-1, 0,  size, MAP_PROT_WRITE|MAP_PROT_READ|MAP_POPULATE);  //ANONYMOUS example

	text2[0] = 's';
	text2[4095] = 'Y';

	text2[4094] = 'd';
	text2[4093] = 'c';
	text2[4092] = 'b';
	text2[4091] = 'a';
	for (i = 0; i < size; i++){
        printf(1, "%c", text2[i]);
        // printf(1, "\n%d\n", i);
    }
    printf(1, "========== END ==========\n");

	munmap(text2, size);
    printf(1,"\n before exit\n");
	exit();
}
