/*
SWE2001 System Program (Spring 2020)
Prof:	Jinkyu Jeong (jinkyu@skku.edu)

TA: 	Sunghwan Kim(sunghwan.kim@csi.skku.edu)
	Jiwon Woo(jiwon.woo@csi.skku.edu)
Semiconductor Building #400509
Author: Jiwon Woo
Description: Find GCD (Greate Common Divisor) and LCM (Least Common Multiple)
***Copyright (c) 2020 SungKyunKwan Univ. CSI***
*/

#include <unistd.h>
#include <fcntl.h>
#include <stdio.h>

#define INPUT "pa2-1.in"

int gcd (int n, int m)
{
	int i, j;

	if (n < m)	j = n;
	else		j = m;

	for (i=j; i>0; i--)
		if (n%i == 0 && m%i == 0)
			break;
	return i;
}

int lcm (int n, int m)
{
	int i, j;

	if (n > m)	j = n;
	else		j = m;

	for (i=j; i <= m*n; i+=j)
		if (i%n==0 && i%m==0)
			break;
	return i;
}

int main (void)
{
	int fd_in;
	int ret, n, m;	

	if((fd_in = open(INPUT, O_RDONLY)) == -1)
		perror(INPUT);

	ret = read(fd_in, (void*)&n, sizeof(int));
	ret = read(fd_in, (void*)&m, sizeof(int));
	
	printf("Greate Common Divisor\t[%d, %d] = %d\n", n, m, gcd(n,m));
	printf("Least Common Multiple\t[%d, %d] = %d\n", n, m, lcm(n,m));

	return 0;	
}
