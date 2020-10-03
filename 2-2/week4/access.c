#include <sys/types.h>
#include <dirent.h>
#include <stdio.h>
#include <stdlib.h>


int main(int argc, char **argv){
	DIR* directory;
	struct dirent* de;
	if(!(directory = opendir(argv[1]))){
		perror("Failed to open directory\n");
		exit(1);
	}
	while(0!=(de=readdir(directory)))
		printf("Found: %s\b", de->d_name);
	closedir(directory);
	exit(0);
}
