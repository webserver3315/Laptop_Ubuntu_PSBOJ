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

#define INF 	400
#define TRUE	1
#define FALSE	0
#define min(a,b) (((a)<(b))?(a):(b))

int findPath(int l, int x, int y, int w, int d)
{
	int index = x + y * w;
	int up = x + (y - 1) * w;
	int down = x + (y + 1) * w;
	int left = (x - 1) + y * w;
	int right = (x + 1) + y * w;
	int total_length = INF;
	int temp = INF;
	int is_blocked = TRUE;
	
	// is it end point?
	if(index == w * d - 1){
		if(maze[index])
			return INF;
		else
			return l; 
	}

	maze[index] = 2;

	// go to next point - Corrected
	if((x < w - 1) && !maze[right]){
		temp = findPath(l + 1, x + 1, y, w, d);
		total_length = min(temp, total_length);
		is_blocked = FALSE;
	} 
	if((y < d - 1) && !maze[down]){
		temp = findPath(l + 1, x, y + 1, w, d);
		total_length = min(temp, total_length);
		is_blocked = FALSE;
	}
	if((x > 0) && !maze[left]){
		temp = findPath(l + 1, x - 1, y, w, d);
		total_length = min(temp, total_length);
		is_blocked = FALSE;
	}
	if((y > 0) && !maze[up]){
		temp = findPath(l + 1, x, y - 1, w, d);
		total_length = min(temp, total_length);
		is_blocked = FALSE;
	}

	maze[index] = 0;
	if(is_blocked)
		return INF;
	else
		return total_length;
}
