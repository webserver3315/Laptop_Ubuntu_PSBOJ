#include "types.h"
#include "user.h"
#include "param.h"
#include "fcntl.h"

int main(int argc, char** argv) {
    printf(1, "========== mmap_anonymous_lazy test START ==========\n");
    printf(1, "========== START ==========\n");
	int i;
	int size = 4096;
   	int fd = open("README", O_RDWR);
    char *addr_1 = mmap(fd, 4096, 8192, MAP_PROT_READ | MAP_POPULATE);
    char a = addr_1[0];

    for (i = 0; i < size; i++){
        printf(1, "%c", addr_1[i]);
    }
    printf(1, "%c", a);

    munmap(addr_1, 4096);
    char b = addr_1[1]; // MUST PGFLT and killed
    printf(1, "%c", b);
	printf(1,"\n============ file mmap end ==========\n");
    printf(1, "========== END ==========\n");
    exit();
}
