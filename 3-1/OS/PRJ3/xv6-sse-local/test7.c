#include "types.h"
#include "user.h"
#include "param.h"
#include "fcntl.h"

int main(int argc, char** argv) {
    printf(1, "========== mmap_anonymous_lazy test START ==========\n");
    printf(1, "========== START ==========\n");
	int i;
	int size = 8192;
   	int fd = open("README", O_RDWR);
    char *addr_1 = mmap(fd, 0, size, MAP_PROT_READ | MAP_POPULATE);

    printf(1, "\n========== PRINT ==========\n");
    for (i = 0; i < size; i++){
        printf(1, "%c", addr_1[i]);
    }

    addr_1[0] = 'a';
    addr_1[1] = 'p';
    addr_1[2] = 'p';
    addr_1[3] = 'l';
    addr_1[4] = 'e';
    printf(1,"before munmap\n");
    munmap(addr_1, size);
    printf(1,"after munmap\n");

    // addr_1[0] = 'a';
    // addr_1[1] = 'p';
    // addr_1[2] = 'p';
    // addr_1[3] = 'l';
    // addr_1[4] = 'e';

    int fd2 = open("README", O_RDWR);
    char *addr_2 = mmap(fd2, 0, size, MAP_PROT_READ | MAP_POPULATE);

    addr_2[0] = 'b';
    addr_2[1] = 'a';
    addr_2[2] = 'n';
    addr_2[3] = 'a';
    addr_2[4] = 'n';
    addr_2[5] = 'a';

    printf(1, "\n========== PRINT2 ==========\n");
    for (i = 0; i < size; i++){
        printf(1, "%c", addr_2[i]);
    }
    munmap(addr_2, size);

	printf(1,"\n============ file mmap end ==========\n");
    printf(1, "========== END ==========\n");
    exit();
}
