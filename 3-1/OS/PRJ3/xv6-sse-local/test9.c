#include "types.h"
#include "user.h"
#include "param.h"
#include "fcntl.h"

int main(int argc, char** argv) {
    printf(1, "========== mmap_fileback_prepaging test START ==========\n");
    printf(1, "========== START ==========\n");
	int i;
	int size = 4096;
	int fd = open("README", O_RDWR);
	char* text = mmap(fd, 0, size, MAP_PROT_READ | MAP_PROT_WRITE | MAP_POPULATE);			      //File example
    text[0] = 'a';

    for (i = 0; i < size; i++){
        printf(1, "%c", text[i]);
    }

    text[1] = 'b';
    text[2] = 'c';
    text[3] = 'd';
    // munmap(text, size);

    // fd = open("README", O_RDWR);
    // text = mmap(fd, size, size*2, MAP_PROT_READ | MAP_PROT_WRITE | MAP_POPULATE);
    // printf(1, "========== Does It Changed? ==========\n");
    // for (i = 0; i < size; i++){
    //     printf(1, "%c", text[i]);
    // }

	printf(1,"\n============ file mmap end ==========\n");
    printf(1, "========== END ==========\n");
    exit();
}
