#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"

int main(int argc, char* argv[]){
	int pid;
	if(argc!=2){
		printf(2, "getnice.c: Need more argc\n");
		return -1;
	}
	pid=atoi(argv[1]);
	int ret=getnice(pid);
	return ret;
}
