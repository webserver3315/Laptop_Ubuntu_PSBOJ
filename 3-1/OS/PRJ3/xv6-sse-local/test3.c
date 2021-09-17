#include "types.h"
#include "user.h"
#include "param.h"
#include "fcntl.h"

int main(int argc, char** argv) {
    int t = 0;
    printf(1, "%d th OPERATION\n\n\n", t);
    printf(1, "========== mmap_fileback_lazy test START ==========\n");
    printf(1, "========== START ==========\n");
	int i;
	int size = 4096;
	int fd = open("README", O_RDWR);
	char* text = mmap(fd, 0, size, MAP_PROT_READ | MAP_PROT_WRITE);			      //File example
    // char* text = mmap(fd, 0, size, MAP_PROT_READ | MAP_PROT_WRITE | MAP_POPULATE);
    text[0] = 'V';
    text[1] = 'W';
    text[2] = 'X';
    text[3] = 'Y';
    text[4] = 'Z';
    for (i = 0; i < size; i++){
        printf(1, "%c", text[i]);
    }
	printf(1,"\n============ file mmap end ==========\n");
    munmap(text, size);
    printf(1, "========== END ==========\n");
    t++;
    exit();
}
