#include "types.h"
#include "user.h"
#include "param.h"
#include "fcntl.h"

int main(int argc, char** argv) {
    printf(1, "========== mmap_anonymous_lazy test START ==========\n");
    printf(1, "========== START ==========\n");
	int i;
	int size = 4096;
   	// int fd = open("README", O_RDWR);
    char *addr_2 = mmap(-1, 0, 8192, MAP_PROT_READ);
    addr_2[0] = 'K';
    addr_2[4096] = 'M';
    for (i = 0; i < size*2; i++){
        printf(1, "%c", addr_2[i]);
    }
    munmap(addr_2, 4096);
    char e = addr_2[1];
    for (i = 0; i < size; i++){
        printf(1, "%c", addr_2[i]);
    }
    printf(1, "e: %c\n", e);
    exit();
}
