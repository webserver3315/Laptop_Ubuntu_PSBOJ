#include "types.h"
#include "user.h"
#include "param.h"
#include "fcntl.h"

int main(int argc, char** argv) {
    int t = 0;
    printf(1, "%d th OPERATION\n\n\n", t);
    printf(1, "========== mmap_anonymous_lazy test START ==========\n");
    printf(1, "========== START ==========\n");
	int i;
	int size = 4096;
	char* text = mmap(-1, 0, size, MAP_PROT_READ | MAP_PROT_WRITE);
    text[0] = 's';
    text[4095] = 'Y';
    text[4094] = 'k';
    for (i = 0; i < size; i++){
        printf(1, "%c", text[i]);
    }
	printf(1,"\n============ file mmap end ==========\n");
    printf(1, "========== END ==========\n");
    t++;
    exit();
    munmap(text, size);
    exit();
}
