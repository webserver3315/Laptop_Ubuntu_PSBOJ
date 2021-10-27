/*
 * Lab #5 : ZNS+ Simulator
 *  - Embedded Systems Design, ICE3028 (Fall, 2021)
 *
 * Oct. 21, 2021.
 *
 * TA: Youngjae Lee, Jeeyoon Jung
 * Prof: Dongkun Shin
 * Embedded Software Laboratory
 * Sungkyunkwan University
 * http://nyx.skku.ac.kr
 */
#include "zns.h"

#include <stdio.h>
#define FOR(i,n) for(int i=0;i<(n);++i)

/************ constants ************/
int NBANK, NBLK, NPAGE;
int DEG_ZONE, MAX_OPEN_ZONE;
int NUM_FCG; // MAX_ZONE/NUM_FCG = 유저존 per FCG (==12)
/********** do not touch ***********/

int* Z2FBG; //int Z2FBG[MAX_ZONE]
int* Z2LogFBG; //int Z2FBG[MAX_ZONE]
struct zone_desc* ZD;//struct zone_desc ZD[MAX_ZONE] => 오로지 UserZone만: Flash 전체 24개
int** buffer; //int buffer[MAX_OPEN_ZONE][8]

//Zone마다 Zone Descriptor 가짐
//? izc로 open된 zone과 tl로 open된 zone은 state가 따로있나? ㅇㅇ. TL_OPEN이 됨.

//각 Open된 Zone마다 1개 Page 크기의 Buffer를 RAM에 보유
// 하나의 FCG 내에서 FBG의 수는 블록의 수와 동일.

static inline int zone_to_fbg(int zone){ return zone%NUM_FCG; }
static inline int zone_to_real_zone(int zone){ return zone/NUM_FCG; }

void print_constant(){
	printf("=================PRINT CONSTANT==================\n");
	printf("NBANK = %d\n",NBANK);
	printf("NBLK = %d\n",NBLK);
	printf("NPAGE = %d\n",NPAGE);
	printf("NSECT = %d\n",NSECT);
	printf("SECT_SIZE = %d\n",SECT_SIZE);
	
	printf("DEG_ZONE = %d\n",DEG_ZONE);
	printf("MAX_OPEN_ZONE = %d\n",MAX_OPEN_ZONE);
	printf("MAX_ZONE = %d\n",MAX_ZONE);
	printf("ZONE_SIZE = %d\n",ZONE_SIZE);
	printf("MAX_LBA = %d\n",MAX_LBA);
}

void zns_init(int nbank, int nblk, int npage, int dzone, int max_open_zone)
{
	// constants
	NBANK = nbank; 	// 4
	NBLK = nblk;	// 16
	NPAGE = npage;	// 8
	DEG_ZONE = dzone;	// 2
	MAX_OPEN_ZONE = max_open_zone; // 4
	NUM_FCG = NBANK / DEG_ZONE; // 2

	
	ZD = (struct zone_desc*)malloc(sizeof(struct zone_desc)*MAX_ZONE);

	// nand
	nand_init(nbank, nblk, npage);
	print_constant();
}

int zns_write(int start_lba, int nsect, u32 *data)
{
}

void zns_read(int start_lba, int nsect, u32 *data)
{
}

int zns_reset(int lba)
{
}

void zns_get_desc(int lba, int nzone, struct zone_desc *descs)
{
}

int zns_izc(int src_zone, int dest_zone, int copy_len, int *copy_list){

}

int zns_tl_open(int zone, u8 *valid_arr)
{
}
