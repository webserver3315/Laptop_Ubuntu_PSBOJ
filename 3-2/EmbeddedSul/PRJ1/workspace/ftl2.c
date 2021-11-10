/*
 * Lab #4 : DFTL Simulator
 *  - Embedded Systems Design, ICE3028 (Fall, 2021)
 *
 * Oct. 07, 2021.
 *
 * TA: Youngjae Lee, Jeeyoon Jung
 * Prof: Dongkun Shin
 * Embedded Software Laboratory
 * Sungkyunkwan University
 * http://nyx.skku.ac.kr
 */

#include "ftl.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#define FOR(i,n) for(int i=0;i<(n);++i)
#define FREE 0
#define USER 1
#define MAP 2

void print_constant(){
	printf("N_BANKS = %d\n",N_BANKS);
	printf("BLKS_PER_BANK = %d\n",BLKS_PER_BANK);
	printf("PAGES_PER_BLK = %d\n",PAGES_PER_BLK);
	printf("SECTOR_SIZE = %d\n",SECTOR_SIZE);
	printf("SECTORS_PER_PAGE = %d\n",SECTORS_PER_PAGE);
	// printf("N_GC_BLOCKS = %d\n",N_GC_BLOCKS);
	printf("\n");
	printf("N_MAP_ENTRIES_PER_PAGE = %d\n",N_MAP_ENTRIES_PER_PAGE);
	printf("CMT_SIZE_PB = %d\n",CMT_SIZE_PB);
	printf("N_CACHED_MAP_PAGE_PB = %d\n",N_CACHED_MAP_PAGE_PB);
	printf("N_PPNS_PB = %d\n",N_PPNS_PB);
	printf("N_MAP_PAGES_PB = %d\n",N_MAP_PAGES_PB);
	printf("N_MAP_BLOCKS_PB = %d\n",N_MAP_BLOCKS_PB);
	printf("N_USER_BLOCKS_PB = %d\n",N_USER_BLOCKS_PB);
	printf("N_OP_BLOCKS_PB = %d\n",N_OP_BLOCKS_PB);
	printf("N_USER_OP_BLOCKS_PB = %d\n",N_USER_OP_BLOCKS_PB);
	printf("N_MAP_OP_BLOCKS_PB = %d\n",N_MAP_OP_BLOCKS_PB);
	printf("N_PHY_DATA_BLK = %d\n",N_PHY_DATA_BLK);
	printf("N_PHY_MAP_BLK = %d\n",N_PHY_MAP_BLK);
	printf("\n");
	printf("N_LPNS_PB = %d\n",N_LPNS_PB);
	printf("N_PPNS = %d\n",N_PPNS);
	printf("N_BLOCKS = %d\n",N_BLOCKS);
	printf("N_MAP_BLOCKS = %d\n",N_MAP_BLOCKS);
	printf("N_USER_BLOCKS = %d\n",N_USER_BLOCKS);
	printf("N_OP_BLOCKS = %d\n",N_OP_BLOCKS);
	printf("N_LPNS = %d\n",N_LPNS);
	printf("N_LBAS = %d\n",N_LBAS);


	printf("\n\n\n");
}



/* DFTL simulator
 * you must make CMT, Map_page2h_PPN to use L2P cache
 * you must increase stats.cache_hit value when L2P is in CMT
 * when you can not find L2P in CMT, you must flush cache 
 * and load target L2P in NAND through Map_page2h_PPN and increase stats.cache_miss value
 */

int CMT_Mappage[N_BANKS][N_CACHED_MAP_PAGE_PB]; // -1 == EMPTY
int CMT[N_BANKS][N_CACHED_MAP_PAGE_PB][N_MAP_ENTRIES_PER_PAGE];
int CMT_Dirty[N_BANKS][N_CACHED_MAP_PAGE_PB];
int CMT_Age[N_BANKS][N_CACHED_MAP_PAGE_PB]; // CMT 접근될 때마다 안된놈들 전부 1씩 증가. 접근된놈은 0으로 초기화

int is_CMT_Full(int bank){
	FOR(slot,N_CACHED_MAP_PAGE_PB){
		if(CMT_Mappage[bank][slot]==-1) return 0;
	}
	return 1;
}

int Current_User_Blk[N_BANKS];
int Current_Map_Blk[N_BANKS];
int GC_Trigger_User_halved_lpn[N_BANKS];
int GC_Trigger_Map_halved_lpn[N_BANKS];

int Map_page2h_PPN[N_BANKS][N_MAP_PAGES_PB]; // M_VPN2M_PPN
int Block_Mode[N_BANKS][BLKS_PER_BANK]; // 0, 1, 2
int User_Blk_Cnt, Map_Blk_Cnt; // == Total_XXX - 1 이 되면 GC 발동

int Buffer[BUFFER_SIZE][SECTORS_PER_PAGE];

//모든 L2P 접근은 CMT를 통해서
int LRU_getVictim(int bank){
	int biggest_age = 0;
	int victim_slot = -1;
	for(int slot = N_CACHED_MAP_PAGE_PB-1; slot>=0; slot--){
		if(biggest_age<=CMT_Age[bank][slot]) {
			biggest_age = CMT_Age[bank][slot];
			victim = slot;
		}
	}
	return victim_slot;
}
void evict_from_CMT(int bank, int slot){
	if(CMT_Dirty[bank][slot]==0){ // nand에 덮어쓸 필요 없음
		CMT_Mappage[bank][slot]=-1; CMT_Cnt[bank][slot]--; return;
	}
	map_write(bank, CMT_Mappage[bank][slot], slot);
	CMT_Mappage[bank][slot]=-1; CMT_Cnt[bank][slot]--;
}

static void map_write(u32 bank, u32 map_page, u32 cache_slot)
{//WRITE TO NAND
	/* you use this function when you must flush
	 * cache from CMT to NAND MAP area
	 * flush cache with LRU policy and fix Map_page2h_PPN!!
	 */
	//dirty 여부 확인필요없음. 애초에 dirty면 이걸 호출할 필요가 없음.
	// Each map_page includes PPN LIST for 8 continuous LPN
	if(CMT_Dirty[bank][cache_slot]==0) return;
	assert(CMT_Mappage[bank][cache_slot] == map_page); 
	int M_ppn = Map_page2h_PPN[bank][map_page];
	int tmp_data[8]; int tmp_spare;
	nand_read(bank,M_ppn/PAGES_PER_BLK, M_ppn%PAGES_PER_BLK,tmp_data, &tmp_spare); 
	// assert(tmp_spare == map_page);
	// 이 도중에 GC 벌어지기도 하나?
	
}
static void map_read(u32 bank, u32 map_page, u32 cache_slot)
{// WRITE TO CMT
	/* you use this function when you must load 
	 * L2P from NAND MAP area to CMT
	 * find L2P MAP with Map_page2h_PPN and fill CMT!!
	 * increase stats.map_write for every nand_write call
	 */
	// bank의 map_page에 해당하는 ppn을 Map_page2h_PPN로 읽고, int 8개를 cache_slot 위치의 CMT에 쓰기
	// map_page = D_lpn
	int M_ppn = Map_page2h_PPN[bank][map_page];
	int tmp_data[8]; int tmp_spare;
	nand_read(bank, map_page/BLKS_PER_BANK, map_page%BLKS_PER_BANK, tmp_data, &tmp_spare);
	// 무지성으로 덮어써버림. Eviction 신경 아예 안씀.
	FOR(i,N_MAP_ENTRIES_PER_PAGE) CMT[bank][cache_slot][i] = tmp_data[i];
}

static void map_garbage_collection(u32 bank)
{
	/*stats.map_gc_cnt++ every map_garbage_collection call*/
	/*stats.map_gc_write++ every nand_write call*/

}
static void garbage_collection(u32 bank)
{
	/* stats.gc_cnt++ every garbage_collection call*/
	/* stats.gc_write++ every nand_write call*/
}
void ftl_open()
{
	print_constant();
	FOR(bank, N_BANKS){
		FOR(i, N_CACHED_MAP_PAGE_PB){
			CMT_Mappage[bank][i]=-1;
			FOR(j, N_MAP_ENTRIES_PER_PAGE) CMT[bank][i][j]=-1;
			CMT_Dirty[bank][i]=0;
			CMT_Age[bank][i]=0;
			CMT_Cnt[bank][i]=0;
		}
		Current_User_Blk[bank]=0;
		Current_Map_Blk[bank]=N_USER_BLOCKS_PB+N_USER_OP_BLOCKS_PB; // 33, 34, 35, 36, 37
		GC_Trigger_User_halved_lpn[bank] = PAGES_PER_BLK*N_USER_BLOCKS_PB;//쓰는 즉시 write 거부되고 gc 발동
		GC_Trigger_User_halved_lpn[bank] = PAGES_PER_BLK*(N_USER_BLOCKS_PB+N_USER_OP_BLOCKS_PB+N_MAP_BLOCKS_PB);
		FOR(i, N_MAP_PAGES_PB) Map_page2h_PPN[bank][i] = -1;
		FOR(blk, BLKS_PER_BANK) Block_Mode[bank][blk] = FREE;
		FOR(buf, BUFFER_SIZE) { FOR(sct, SECTORS_PER_PAGE) Buffer[buf][sct]=-1; }
	}
}

int halved_lpn2halved_ppn(int bank, int halved_lpn){ // bank = lpn%N_BANKS, halved_lpn = lpn/N_BANKS
	int wanted_map_page = halved_lpn/N_MAP_ENTRIES_PER_PAGE; int is_cache_hit=0; int slot=0;
	for(;slot<N_MAP_ENTRIES_PER_PAGE; slot++) {	if(CMT_Mappage[bank][slot]==wanted_map_page){ is_cache_hit=1; break; } }
	if(is_cache_hit){ return CMT[bank][slot][halved_lpn%N_MAP_ENTRIES_PER_PAGE]; }
	if(CMT_Cnt[bank]<N_MAP_ENTRIES_PER_PAGE){ // 빈공간 있을 때
		int tmp_data[8]; int tmp_spare;
		nand_read(bank,halved_lpn/BLKS_PER_BANK,halved_lpn%BLKS_PER_BANK,tmp_data,&tmp_spare);
		CMT[bank][CMT_Cnt[bank]]


		int lhs_lpn = (lpn/N_BANKS)/N_MAP_ENTRIES_PER_PAGE*N_MAP_ENTRIES_PER_PAGE;
		CMT_Cnt[bank]++;
	}
}

void ftl_read(u32 lba, u32 nsect, u32 *read_buffer)
{	
	int lpn = lba/SECTORS_PER_PAGE; int halved_lpn = lpn/N_BANKS;
	int halved_ppn = halved_lpn2halved_ppn(halved_lpn);
}	

void ftl_write(u32 lba, u32 nsect, u32 *write_buffer)
{
	/* stats.nand_write++ every nand_write call*/

	stats.host_write += nsect;
}
