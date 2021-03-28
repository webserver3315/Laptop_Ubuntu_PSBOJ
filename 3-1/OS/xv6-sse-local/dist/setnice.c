#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"

int main(int argc, char* argv[]){
	int pid, nice;
	if(argc!=3)
		return -1;
	pid=atoi(argv[1]);
	nice=atoi(argv[2]);

	int ret = setnice(pid,nice);
	return ret;
}
