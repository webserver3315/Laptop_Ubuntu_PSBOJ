/*
SWE2001 System Program (Spring 2020)
Prof:	Jinkyu Jeong (jinkyu@skku.edu)

TA: 	Sunghwan Kim(sunghwan.kim@csi.skku.edu)
	Jiwon Woo(jiwon.woo@csi.skku.edu)
Semiconductor Building #400509
Author: Jiwon Woo
Description: Find shortest path of maze
***Copyright (c) 2020 SungKyunKwan Univ. CSI***
*/

#include "maze.h"

#define	INPUT	"pa2-3.in"
#define INF 	400
#define	BUFSIZE	400


int main(void)
{
	char buffer[BUFSIZE];
	int fd;
	int i;
	int cnt = 0;
	int wdth = 0, dpth = 0;
	int len = 0;

	for(i = 0; i < BUFSIZE; i++){
		buffer[i] = 0;
	}

	/* open */
	if((fd = open(INPUT, O_RDONLY)) == -1)
		perror(INPUT);
	/* read */
	read(fd, buffer, sizeof(buffer));
	/* close */
	close(fd);

	/* start build maze */
	for(i = 0; i < BUFSIZE; i++){
		if(!buffer[i]){ 
			break;	/* nothing left to read */
		} else if(buffer[i] != '\n'){ 
			maze[cnt++] = buffer[i] - '0';
		} else {
			dpth++;	/* new line */
		}
	}
	/* set width */
	wdth = cnt / dpth;
	len  = findPath(1, 0, 0, wdth, dpth);
	printResult(len, wdth, dpth);

	/* return */
	return 0;
}

void printResult(int l, int w, int d)
{
	int i, j = 0;
	if(l == INF)
		printf("No exit in the maze\n");
	else
		printf("Shortest path length is %d\n", l);
	printf("The maze looks like\n");
	printf("w = %d, d = %d\n", w, d);
	for(i = 0; i < d; i++){
		for(j = 0; j < w; j++){
			printf("%d", (int)maze[j + i * w]);
		}
		printf("\n");
	}
}


