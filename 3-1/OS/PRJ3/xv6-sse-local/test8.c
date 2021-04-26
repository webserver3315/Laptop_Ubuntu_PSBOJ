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
    char *addr_1 = mmap(fd, 0, 4096*3, MAP_PROT_READ | MAP_PROT_WRITE | MAP_POPULATE);
    char a = addr_1[0];
    char b = addr_1[4096-2];
    char c = addr_1[4096*2-3];
    char d = addr_1[4096*2+1];
    addr_1[0] = 'a';
    addr_1[1] = 'p';
    addr_1[2] = 'p';
    addr_1[3] = 'l';
    addr_1[4] = 'e';
    for (i = 0; i < size; i++){
        printf(1, "%c", addr_1[i]);
    }
    printf(1, "a: %c\n", a);
    printf(1, "b: %c\n", b);
    printf(1, "c: %c\n", c);
    printf(1, "d: %c\n", d);

    addr_1[0] = 'b';
    addr_1[1] = 'a';
    addr_1[2] = 'n';
    addr_1[3] = 'a';
    addr_1[4] = 'n';
    addr_1[5] = 'a';

    munmap(addr_1+4096, 4096);
    for (i = 0; i < size; i++){
        printf(1, "%c", addr_1[i]);
    }
    char aa = addr_1[0];
    char dd = addr_1[4096*3-3];
    printf(1, "aa: %c\n", aa);
    printf(1, "dd: %c\n", dd);
    char cc = addr_1[4096*2-3]; // must killed
    printf(1, "cc: %c\n", cc);

    exit();
}
