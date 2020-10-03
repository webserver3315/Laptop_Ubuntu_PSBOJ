/*
SWE2001 System Program (Spring 2020)
Prof:	Jinkyu Jeong (jinkyu@skku.edu)

TA: 	Sunghwan Kim(sunghwan.kim@csi.skku.edu)
	Jiwon Woo(jiwon.woo@csi.skku.edu)
Semiconductor Building #400509
Author: Jiwon Woo
Description: Find nth fibonacci number
***Copyright (c) 2020 SungKyunKwan Univ. CSI***
*/

#include <unistd.h>
#include <fcntl.h>
#include <stdio.h>
#include <string.h>

#define INPUT  "pa2-2.in"

int fibo (int n) 
{
	if (n==0)	return 1;
	else if (n==1)	return 1;

	return fibo(n-1) + fibo (n-2);
}

int main (void)
{
	int fd_in;
	int ret, val_i;
	
	/* open */
	if((fd_in = open(INPUT, O_RDONLY)) == -1)
		perror(INPUT);
	/* read */
	ret = read(fd_in, (void*)&val_i, sizeof(int));
	/* close */
	close(fd_in);

	ret = fibo(val_i);

	printf("fibo[%d] = %d\n", val_i, ret);	

	return 0;	
}
