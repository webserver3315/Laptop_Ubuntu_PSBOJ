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

/*
input8까지 전부 통과 확인.
ftl.h 의 ftl_stats 에 CMT_hit, CMT_miss 추가해야 돌아감.

277번줄 말대로, gc 할때 원래는 Cache 에 있는지의 여부부터 체크해야하는데(이왕이면 최신화된 데이터를 내려야 하므로),
그런 자잘한건 일단 무시되어있다.
*/

#include "ftl.h"
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>

#define FOR(x,n) for(int x=0;x<(n);x++)
#define N_SLOT_PB N_CACHED_MAP_PAGE_PB
#define CMT_NSECT N_MAP_ENTRIES_PER_PAGE
#define INVALID 0
#define VALID 1
#define EMPTY 0
#define DATA 1
#define MAP 2
#define DIRTY 1
#define CLEAN 0

// #define N_MAPPAGES_PB N_MAP_BLOCKS_PB*PAGES_PER_BLK

int Next_Data_PPN[N_BANKS];
int GC_Trigger_Data_PPN[N_BANKS];
int Block_Status[N_BANKS][BLKS_PER_BANK];
int isValid[N_BANKS][BLKS_PER_BANK*PAGES_PER_BLK]; // ppn임에 유의. 꼽표치고 딴데쓰면 invalid됨. 즉, invalid는 읽거나 복사하지 말라는 뜻.

int is_VPN_first_time[N_BANKS][N_MAP_PAGES_PB];
int CMT_vpn[N_BANKS][N_SLOT_PB]; // -1 == FREE CMT SLOT
int CMT_dirty[N_BANKS][N_SLOT_PB];
int CMT_age[N_BANKS][N_SLOT_PB];
int CMT_Data[N_BANKS][N_SLOT_PB][N_MAP_ENTRIES_PER_PAGE];
int GTD[N_BANKS][N_MAP_PAGES_PB]; // lpn2ppn for Mapping Block
int Next_Map_PPN[N_BANKS];
int GC_Trigger_Map_PPN[N_BANKS];
/************************LAB 3***************************/
int buffer_L2S[N_BANKS][N_LPNS_PB];
int buffer_S2L[N_BANKS][N_BUFFERS];
int buffer_Data[N_BANKS][N_BUFFERS][SECTORS_PER_PAGE];
int buffer_Spare[N_BANKS][N_BUFFERS];

int buffer_dirty[N_BANKS][N_BUFFERS];
int buffer_age[N_BANKS][N_BUFFERS];

/********************************************************/

int get_LRU_slot(int bank);
int get_free_slot(int bank);
int greedy_data_blk(int bank);
int greedy_map_blk(int bank);
int get_free_blk_data(int bank);
int get_free_blk_map(int bank);
int is_vpn_cached(int bank, int vpn);
static void make_free_slot(int bank, int cache_slot);
static void original_make_free_slot(u32 bank, u32 vpn, u32 victim_slot);
static void use_free_slot(u32 bank, u32 vpn, u32 free_slot);
int lpn2ppn(int bank, int lpn);
void update_L2P(int bank, int lpn, int ppn);
static void map_garbage_collection(u32 bank);
static void garbage_collection(u32 bank);
void ftl_open();
void ftl_read(u32 lba, u32 nsect, u32 *read_buffer);
void write_through_lpn(int bank, int lpn, int* data);
void ftl_write(u32 lba, u32 nsect, u32 *write_buffer);

/************************LAB 3***************************/
int get_victim_data_slot(int bank){ // LRU
	return 0;
	// return (int)(rand()%N_BUFFERS);
}
int get_empty_data_slot(int bank){
	FOR(i, N_BUFFERS){
		if(buffer_S2L[bank][i] == -1) return i;
	}
	return -1;
}



extern struct Page {
	u32 data[8]; //32byte
	u32 spare; //4byte
};
extern struct Page* nand;
extern char* iswritten; 
extern int* blk_index;
extern int NBANKS, NBLKS, NPAGES;
void show_whole_nand(){
	printf("SHOW_WHOLE_NAND\n");
	for(int bb=0;bb<NBANKS;bb++) { printf("<Bank%d>\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t",bb); }
	printf("\n");
	for(int bb=0;bb<NBANKS;bb++) printf("Next_Data_PPN[%d] = %d\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t",bb,Next_Data_PPN[bb]);
	printf("\n");
	for(int bb=0;bb<NBANKS;bb++) printf("GC_Trigger_Data_PPN[%d] = %d\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t",bb,GC_Trigger_Data_PPN[bb]);
	printf("\n");
	for(int bb=0;bb<NBANKS;bb++) printf("get_free_blk_data[%d] = %d\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t",bb,get_free_blk_data(bb));
	printf("\n");
	for(int bb=0;bb<NBANKS;bb++) printf("Next_Map_PPN[%d] = %d\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t",bb,Next_Map_PPN[bb]);
	printf("\n");
	for(int bb=0;bb<NBANKS;bb++) printf("GC_Trigger_Map_PPN[%d] = %d\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t",bb,GC_Trigger_Map_PPN[bb]);
	printf("\n");
	for(int bb=0;bb<NBANKS;bb++) printf("get_free_blk_map[%d] = %d\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t",bb,get_free_blk_map(bb));
	printf("\n");

	// printf("\n");
	// for(int buf=0; buf<N_BUFFERS; buf++){
	// 	for(int bb=0;bb<N_BANKS;bb++){
	// 		printf("Buffer[%d][%d].data[0:7] == [ %d | ", bb, buf, buffer_S2L[bb][buf]);
	// 		for (int i = 0; i < 7; i++) {
	// 			if(buffer_Data[bb][buf][i] == -1) printf("--, ");
	// 			else printf("%d, ", buffer_Data[bb][buf][i]);
	// 		}
	// 		if(buffer_Data[bb][buf][7] == -1) printf("-- | D:%d | A:%d ] \t\t", CMT_dirty[bb][buf], CMT_age[bb][buf]);
	// 		else printf("%d | D:%d | A:%d ] \t\t", buffer_Data[bb][buf][7], CMT_dirty[bb][buf], CMT_age[bb][buf]);
	// 	}
	// 	printf("\n");
	// }
	printf("\n");
	for(int buf=0; buf<N_BUFFERS; buf++){
		for(int bb=0;bb<N_BANKS;bb++){
			printf("Buffer[%d][%d].data[0:7] == [ %d | ", bb, buf, buffer_S2L[bb][buf]);
			for (int i = 0; i < 7; i++) {
				if(buffer_Data[bb][buf][i] != -1) printf("%2x ", buffer_Data[bb][buf][i]);
				else printf("-- ");
			}
			if(buffer_Data[bb][buf][7] != -1) printf("%2x | D:%d | A:%d ] \t\t", buffer_Data[bb][buf][7], buffer_dirty[bb][buf], buffer_age[bb][buf]);
			else printf("-- | D:%d | A:%d ] \t\t", buffer_dirty[bb][buf], buffer_age[bb][buf]);
		}
		printf("\n");
	}

	// printf("\n");
	// for(int vpn=0; vpn<N_MAP_BLOCKS_PB*PAGES_PER_BLK; vpn++){
	// 	for(int bb=0;bb<N_BANKS;bb++){
	// 		printf("GTD[%d] == %d \t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t", vpn, GTD[bb][vpn]);
	// 	}
	// 	printf("\n");
	// }
	// for(int slot=0; slot<N_SLOT_PB;slot++){
	// 	for(int bb=0;bb<N_BANKS;bb++){
	// 		printf("CMT[%d][%d].data[0:7] == [ %d | ", bb, slot, CMT_vpn[bb][slot]);
	// 		for (int i = 0; i < 7; i++) {
	// 			if(CMT_Data[bb][slot][i] == -1) printf("--, ");
	// 			else printf("%d, ", CMT_Data[bb][slot][i]);
	// 		}
	// 		if(CMT_Data[bb][slot][7] == -1) printf("-- | D:%d | A:%d ] \t\t", CMT_dirty[bb][slot], CMT_age[bb][slot]);
	// 		else printf("%d | D:%d | A:%d ] \t\t", CMT_Data[bb][slot][7], CMT_dirty[bb][slot], CMT_age[bb][slot]);
	// 	}
	// 	printf("\n");
	// }
	printf("\n");
	for(int halved_ppn=0; halved_ppn<NBLKS*NPAGES;halved_ppn++){
		for(int bb=0;bb<N_BANKS;bb++){
			int ppn = bb*NBLKS*NPAGES + halved_ppn;
			if(Block_Status[bb][halved_ppn/PAGES_PER_BLK] == MAP){
				printf("ppn[%d][%d].data[0:7] == [ %d | ", bb, halved_ppn, nand[ppn].spare);
				for (int i = 0; i < 7; i++) {
					printf("%d, ", nand[ppn].data[i]);
				}
				printf("%d | ", nand[ppn].data[7]);
			}else{
				printf("ppn[%d][%d].data[0:7] == [ %d | ", bb, halved_ppn, nand[ppn].spare);
				for (int i = 0; i < 7; i++) {
					if(nand[ppn].data[i] == -1) printf("--, ");
					else printf("%x, ", nand[ppn].data[i]);
				}
				if(nand[ppn].data[7] == -1) printf("-- | ");
				else printf("%x | ", nand[ppn].data[7]);
			}
			if(Block_Status[bb][halved_ppn/PAGES_PER_BLK] == EMPTY) printf("E |");
			else if(Block_Status[bb][halved_ppn/PAGES_PER_BLK] == DATA) printf("D |");
			else if(Block_Status[bb][halved_ppn/PAGES_PER_BLK] == MAP) printf("M |");
			printf(" %d ] \t\t", isValid[bb][halved_ppn]);
		}
		printf("\n");
		if((halved_ppn+1)%PAGES_PER_BLK == 0) printf("\n");
	}
}


void stat_init(){
	stats.gc_cnt = 0;
	stats.map_gc_cnt = 0;
	stats.host_write = 0;
	stats.nand_write = 0;
	stats.gc_write = 0;
	stats.map_write = 0;
	stats.map_gc_write = 0;
	stats.cache_hit = 0;
	stats.cache_miss = 0;
	stats.CMT_hit = 0;
	stats.CMT_miss = 0;
}

void show_score(){
	printf("DFTL + Caching\n");
	printf("gc_cnt: %d\n", stats.gc_cnt);
	printf("map_gc_cnt: %d\n", stats.map_gc_cnt);
	printf("host_write: %d\n", stats.host_write);
	printf("nand_write: %d\n", stats.nand_write);
	printf("gc_write: %d\n", stats.gc_write);
	printf("map_write: %d\n", stats.map_write);
	printf("map_gc_write: %d\n", stats.map_gc_write);
	printf("cache_hit: %d\n", stats.cache_hit);
	printf("cache_miss: %d\n", stats.cache_miss);
	printf("CMT_hit: %d\n", stats.CMT_hit);
	printf("CMT_miss: %d\n", stats.CMT_miss);
	printf("/********* RESULT ***********/\n");
	printf("CMT_hit: %d\n", stats.CMT_hit);
	printf("WAF: %.2f\n", (double)(stats.nand_write + stats.gc_write + stats.map_gc_write + stats.map_gc_write) * 8 / stats.host_write);
	printf("Cache_Hit: %.2f\n", (double)(stats.cache_hit)/(stats.cache_hit + stats.cache_miss));
	printf("CMT_hit: %.2f\n", (double)(stats.CMT_hit)/(stats.CMT_hit + stats.CMT_miss));
}
/********************************************************/



inline int lpn2vpn(int lpn){
	return lpn/N_MAP_ENTRIES_PER_PAGE;
}

int greedy_data_blk(int bank){ // 무지성으로 greedy victim을 선정함
	int biggest_invalid = 0;
	int victim = -1;
	for(int pblk=BLKS_PER_BANK-1;pblk>=0;pblk--){
		if(Block_Status[bank][pblk]!=DATA) continue;
		int invalid_cnt=0;
		FOR(pg, PAGES_PER_BLK){
			if(isValid[bank][pblk*PAGES_PER_BLK+pg] == INVALID) invalid_cnt++;
		}
		if(biggest_invalid<=invalid_cnt) {
			biggest_invalid = invalid_cnt;
			victim = pblk;
		}
	}
	return victim;
}

int get_free_blk_data(int bank){ // 순방향으로 검사
	FOR(pblk, BLKS_PER_BANK){
		if(Block_Status[bank][pblk]==EMPTY) return pblk;
	}
	return -1;
}


static void garbage_collection(u32 bank)
{
	assert(Next_Data_PPN[bank]==GC_Trigger_Data_PPN[bank]);
	stats.gc_cnt++;
	int victim_pblk = greedy_data_blk(bank); int free_pblk = get_free_blk_data(bank); 
	assert(victim_pblk!=-1 && free_pblk != -1);
	int victim_first_ppn = victim_pblk * PAGES_PER_BLK; int free_first_ppn = free_pblk * PAGES_PER_BLK;
	int immigrants_cnt = 0;
	FOR(page_offset, PAGES_PER_BLK){
		int tmp_data[8]; int tmp_lpn;
		int victim_ppn = victim_first_ppn + page_offset;
		if(isValid[bank][victim_ppn] == INVALID) continue; // inValid 페이지는 복사하지 않는다.
		nand_read(bank, victim_pblk, page_offset, tmp_data, &tmp_lpn); // 아직 버퍼 미구현이므로 tmp_spare 볼 필요 없음. 
		nand_write(bank, free_pblk, immigrants_cnt, tmp_data, &tmp_lpn); stats.gc_write++;
		update_L2P(bank, tmp_lpn, free_first_ppn + immigrants_cnt); 
		immigrants_cnt++;
	}
	FOR(i, PAGES_PER_BLK) isValid[bank][victim_first_ppn + i] = VALID;
	Next_Data_PPN[bank] = free_first_ppn + immigrants_cnt;
	GC_Trigger_Data_PPN[bank] = free_first_ppn + PAGES_PER_BLK;
	nand_erase(bank, victim_pblk); 
	Block_Status[bank][victim_pblk] = EMPTY; 
	Block_Status[bank][free_pblk] = DATA;
}

void ftl_read(u32 lba, u32 nsect, u32 *read_buffer) // 0th lba, 8 nsect 라면 0~7이다.
{	
	assert(nsect > 0);
	int* current_read_buffer = read_buffer;
	int first_lba = lba;
	int first_lba_offset = first_lba % SECTORS_PER_PAGE;
	int first_page_first_lba = first_lba - first_lba_offset;
	int last_lba = lba + nsect - 1; // 이 lba까지 쓰는거임. 즉, write와 다름.
	int last_lba_offset = last_lba % SECTORS_PER_PAGE;
	int last_page_first_lba = last_lba - last_lba_offset;
	int send_kazu = 1 + (last_page_first_lba - first_page_first_lba) / SECTORS_PER_PAGE; // 보낼 페이지 횟수

	// lba0, nsect8 일 때 send_kazu must be 1
	int data[8]; int bank, lpn, spare; // 여기서 lpn은 halved_lpn 을 의미한다. 
	// If Cached, read from Cache
	int dst_slot;
	if(send_kazu == 1){
		int sector_kazu = nsect;
		bank = (first_page_first_lba / SECTORS_PER_PAGE) % N_BANKS;
		lpn = (first_page_first_lba / SECTORS_PER_PAGE) / N_BANKS;
		dst_slot = buffer_L2S[bank][lpn];
		if(dst_slot != -1){ // Cache Hit
			stats.cache_hit++;
			FOR(i, sector_kazu) current_read_buffer[i] = buffer_Data[bank][buffer_L2S[bank][lpn]][first_lba_offset + i];
		}else{// Cache Miss
			int ppn = lpn2ppn(bank, lpn);
			stats.cache_miss++;
			if(ppn == -1){ // EMPTY여부를 확인하는건데, 이거 문제있음. 처음 ppn을 캐싱하면 -1이 아니라 쓰레기값임
				FOR(i, sector_kazu) current_read_buffer[i] = 0xFFFFFFFFF;
			}else{
				nand_read(bank, ppn/PAGES_PER_BLK, ppn%PAGES_PER_BLK, data, &spare);
				FOR(i, sector_kazu) current_read_buffer[i] = data[first_lba_offset + i];
			}
		}
	}
	else{
		FOR(page_offset, send_kazu){
			lpn = (page_offset + (first_page_first_lba/SECTORS_PER_PAGE)) / N_BANKS;
			bank = (page_offset + (first_page_first_lba/SECTORS_PER_PAGE)) % N_BANKS;
			int sector_kazu = 0; 
			int ppn = lpn2ppn(bank, lpn);
			dst_slot = buffer_L2S[bank][lpn];
			if(page_offset == 0){ // 첫타
				sector_kazu = 8 - first_lba_offset;
				if(dst_slot != -1){
					stats.cache_hit++;
					FOR(i, sector_kazu) current_read_buffer[i] = buffer_Data[bank][buffer_L2S[bank][lpn]][first_lba_offset + i];
				}else{
					stats.cache_miss++;
					if(ppn == -1){ // Empty
						FOR(i, sector_kazu) current_read_buffer[i] = 0xFFFFFFFFF;
					}else{
						nand_read(bank, ppn/PAGES_PER_BLK, ppn%PAGES_PER_BLK, data, &spare);
						FOR(i, sector_kazu) current_read_buffer[i] = data[first_lba_offset + i];
					}
				}
			}else if(page_offset == send_kazu - 1){ // 막타
				sector_kazu = last_lba_offset + 1;
				if(dst_slot != -1){
					stats.cache_hit++;
					FOR(i, sector_kazu) current_read_buffer[i] = buffer_Data[bank][buffer_L2S[bank][lpn]][i];
				}else{
					stats.cache_miss++;
					if(ppn == -1){
						FOR(i, sector_kazu) current_read_buffer[i] = 0xFFFFFFFF;
					}else{
						nand_read(bank, ppn/PAGES_PER_BLK, ppn%PAGES_PER_BLK, data, &spare);
						FOR(i, sector_kazu) current_read_buffer[i] = data[i];
					}
				}
			}else{ // 중간타
				sector_kazu = 8;
				if(dst_slot != -1){
					stats.cache_hit++;
					FOR(i, sector_kazu) current_read_buffer[i] = buffer_Data[bank][buffer_L2S[bank][lpn]][i];
				}else{
					stats.cache_miss++;
					if(ppn == -1){
						FOR(i, sector_kazu) current_read_buffer[i] = 0xFFFFFFFF;
					}else{
						nand_read(bank, ppn/PAGES_PER_BLK, ppn%PAGES_PER_BLK, data, &spare);
						FOR(i, sector_kazu) current_read_buffer[i] = data[i];
					}
				}
			}
			current_read_buffer += sector_kazu;
		}
	}
}

void write_through_lpn(int bank, int lpn, int* data){ // 딱 페이지단위로만 쓰기
	int dst_slot = buffer_L2S[bank][lpn];
	if(dst_slot == -1){ // Cache Miss
		stats.cache_miss++;
		if(get_empty_data_slot(bank) == -1){ // BUFFER IS FULL: Evict 필요, 버퍼 공간 만들기
			/* EVICTION ACTIVATED */
			int victim_slot = get_victim_data_slot(bank);
			if(Next_Data_PPN[bank] == GC_Trigger_Data_PPN[bank]) garbage_collection(bank);
			int ppn = Next_Data_PPN[bank];
			int before_ppn = lpn2ppn(bank, buffer_S2L[bank][victim_slot]);
			if(before_ppn != -1) isValid[bank][before_ppn] = INVALID; // 덮어쓰기라면 기존 L2P invalid해줘야함. 근데 이거 OP블럭도 isValid 0때리는 문제발생할수있다는듯?
			update_L2P(bank, buffer_S2L[bank][victim_slot], Next_Data_PPN[bank]);
			nand_write(bank, ppn/PAGES_PER_BLK, ppn%PAGES_PER_BLK, buffer_Data[bank][victim_slot], &buffer_S2L[bank][victim_slot]); stats.nand_write++;
			Next_Data_PPN[bank]++;

			buffer_L2S[bank][buffer_S2L[bank][victim_slot]] = -1;
			buffer_S2L[bank][victim_slot] = -1;
		}// Buffer에 빈공간 확보완료
		dst_slot = get_empty_data_slot(bank);
	}else{
		stats.cache_hit++;
	}
	// Cache Hit
	assert(dst_slot != -1);
	FOR(i, SECTORS_PER_PAGE) 
		buffer_Data[bank][dst_slot][i] = data[i];
	buffer_Spare[bank][dst_slot] = lpn;
	buffer_L2S[bank][lpn] = dst_slot;
	buffer_S2L[bank][dst_slot] = lpn; // 슬롯에 캐싱완료
}

void ftl_write(u32 lba, u32 nsect, u32 *write_buffer) // 0th lba ~ 8 sect => 0~7th lba
{ // stats.cache_hit/miss 는 write_through_lpn 에서 업데이트.
	int* current_write_buffer = write_buffer;
	int first_lba=lba;
	int first_lba_offset = first_lba % SECTORS_PER_PAGE;
	int first_page_first_lba = first_lba - first_lba_offset;
	int last_lba = first_lba + nsect - 1; // 딱 여기까지도 쓰라는 말
	int last_lba_offset = (last_lba % SECTORS_PER_PAGE);
	int last_page_first_lba = last_lba-last_lba_offset;
	int send_kazu = 1 + ((last_page_first_lba - first_page_first_lba) / SECTORS_PER_PAGE);
	// lba0, nsect8 일 때 send_kazu must be 1

	int data[SECTORS_PER_PAGE]; int bank, lpn, ppn, spare;
	int sector_kazu = 0;
	if(send_kazu == 1){
		sector_kazu = nsect;
		lpn = (first_page_first_lba / SECTORS_PER_PAGE) / N_BANKS;
		bank = (first_page_first_lba / SECTORS_PER_PAGE) % N_BANKS;
		ppn = lpn2ppn(bank, lpn);
		if(buffer_L2S[bank][lpn] != -1){// Cache Hit
			FOR(i, SECTORS_PER_PAGE) data[i] = buffer_Data[bank][buffer_L2S[bank][lpn]][i];
		}
		else if(ppn == -1){ // Empty
			FOR(i, first_lba_offset) data[i] = 0xFFFFFFFF;
			for(int i=last_lba_offset+1;i<8;i++) data[i] = 0xFFFFFFFF;
		}else{
			nand_read(bank, ppn/PAGES_PER_BLK, ppn%PAGES_PER_BLK, data, &spare);	
		}
		FOR(i, sector_kazu) data[first_lba_offset + i] = current_write_buffer[i];
		write_through_lpn(bank, lpn, data); current_write_buffer += sector_kazu;
	}else{
		FOR(page_offset, send_kazu){
			lpn = (page_offset + (first_page_first_lba / SECTORS_PER_PAGE)) / N_BANKS;
			bank = (page_offset + (first_page_first_lba / SECTORS_PER_PAGE)) % N_BANKS;
			ppn = lpn2ppn(bank, lpn);
			if(page_offset == 0){ // 첫타
				sector_kazu = 8 - first_lba_offset;
				if(buffer_L2S[bank][lpn] != -1){ // Cache Hit
					FOR(i, SECTORS_PER_PAGE) data[i] = buffer_Data[bank][buffer_L2S[bank][lpn]][i];
				}
				else if(ppn == -1){ // Empty
					FOR(i, first_lba_offset) data[i] = 0xFFFFFFFF;
				}else{
					nand_read(bank, ppn/PAGES_PER_BLK, ppn%PAGES_PER_BLK, data, &spare);	
				}
				FOR(i, sector_kazu) data[first_lba_offset + i] = current_write_buffer[i];
			}else if(page_offset == send_kazu - 1){ // 막타
				sector_kazu = last_lba_offset + 1;
				if(buffer_L2S[bank][lpn] != -1){
					FOR(i, SECTORS_PER_PAGE) data[i] = buffer_Data[bank][buffer_L2S[bank][lpn]][i];
				}
				else if(ppn == -1){ // 처음
					for(int i=last_lba_offset+1;i<8;i++){ data[i]=0xffffffff; }
				}else{
					nand_read(bank, ppn/PAGES_PER_BLK, ppn%PAGES_PER_BLK, data, &spare);
				}
				FOR(i, sector_kazu) data[i] = current_write_buffer[i];
			}else{
				sector_kazu = 8;
				if(buffer_L2S[bank][lpn] != -1){
					FOR(i, SECTORS_PER_PAGE) data[i] = buffer_Data[bank][buffer_L2S[bank][lpn]][i];
				}
				if(ppn == -1){ // 처음
					for(int i=0;i<8;i++){ data[i]=0xffffffff; }
				}else{
					nand_read(bank, ppn/PAGES_PER_BLK, ppn%PAGES_PER_BLK, data, &spare);
				}
				FOR(i, sector_kazu) data[i] = current_write_buffer[i];
			}
			write_through_lpn(bank, lpn, data); current_write_buffer += sector_kazu;
		}
	}
	stats.host_write += nsect;
	return;
}
/*
CMT_Age 건드려줘야함
CMT도 새거고 GDT도 새거인, 처음 쓸때는 어떻게 메커니즘이 작동하는거지?
CMT Dirty 등등도 일괄적으로 걍 때려버리기.
배열차원검사

GTD는 오로지 cache evict가 될 때만 수정된다.
CMT_vpn의 2번째 차원을 vpn으로 넣지 말도록 유의. slot이나 offset이 들어가야한다.
*/

/*
L2P[bank][lpn]==-1 => 처음 접근하는 lpn 이라는 것을 나타낸다.
*/
void ftl_open(){
	nand_init(N_BANKS, BLKS_PER_BANK, PAGES_PER_BLK);
	stat_init();
	/*****************LAB 3*******************/
	FOR(bank, N_BANKS){
		FOR(lpn, N_LPNS_PB) buffer_L2S[bank][lpn] = -1;
		FOR(buf, N_BUFFERS) {
			buffer_S2L[bank][buf] = -1;
			buffer_Spare[bank][buf] = -1;
			FOR(i, SECTORS_PER_PAGE) buffer_Data[bank][buf][i] = -1;
		}
	}
	/*****************************************/

	FOR(bank, N_BANKS){
		FOR(vpn, N_MAP_PAGES_PB) is_VPN_first_time[bank][vpn] = 1;
		GC_Trigger_Map_PPN[bank] = PAGES_PER_BLK*(BLKS_PER_BANK - 1); 
		GC_Trigger_Data_PPN[bank] = PAGES_PER_BLK*(N_USER_BLOCKS_PB + N_USER_OP_BLOCKS_PB - 1);
		FOR(blk, BLKS_PER_BANK){
			if(blk < N_USER_BLOCKS_PB + N_USER_OP_BLOCKS_PB - 1) Block_Status[bank][blk] = DATA;
			else if(blk == N_USER_BLOCKS_PB + N_USER_OP_BLOCKS_PB - 1) Block_Status[bank][blk] = EMPTY;
			else if(blk == BLKS_PER_BANK - 1) Block_Status[bank][blk] = EMPTY;
			else Block_Status[bank][blk] = MAP;
		}
		FOR(ppn,BLKS_PER_BANK*PAGES_PER_BLK) isValid[bank][ppn]=VALID;
		Next_Data_PPN[bank] = 0;
		Next_Map_PPN[bank] = (N_USER_BLOCKS_PB + N_USER_OP_BLOCKS_PB) * PAGES_PER_BLK;
		FOR(slot, N_SLOT_PB){
			CMT_vpn[bank][slot] = -1;
			CMT_dirty[bank][slot] = CLEAN;
			CMT_age[bank][slot] = 0;
			FOR(i, N_MAP_ENTRIES_PER_PAGE) CMT_Data[bank][slot][i] = -1;
		}
		FOR(vpn, N_MAP_PAGES_PB) GTD[bank][vpn] = -1;
	}
}

// LRU Aging 은 아직 미구현
int get_LRU_slot(int bank){ // 무지성으로 해당 bank에서 Most LRU Slot을 반환함.
	// int biggest_age = -1;
	// int ret = -1;
	// FOR(slot, N_SLOT_PB){
	// 	if(biggest_age<CMT_age[bank][slot]) {
	// 		biggest_age = CMT_age[bank][slot]; 
	// 		ret = slot;
	// 	}
	// }
	// return ret;
	return 0;
	// return (int)(rand()%N_SLOT_PB);
}
int get_free_slot(int bank){
	FOR(slot, N_SLOT_PB) if(CMT_vpn[bank][slot] == -1) return slot;
	return -1;
}
int greedy_map_blk(int bank){ // 무지성으로 greedy victim을 선정함
	int biggest_invalid = -1;
	int victim = -1;
	FOR(pblk, BLKS_PER_BANK){
		if(Block_Status[bank][pblk]!=MAP) continue;
		int invalid_cnt=0;
		FOR(pg, PAGES_PER_BLK){
			if(isValid[bank][pblk*PAGES_PER_BLK+pg] == INVALID) invalid_cnt++;
		}
		if(biggest_invalid<invalid_cnt) {
			biggest_invalid = invalid_cnt;
			victim = pblk;
		}
	}
	return victim;
}
int get_free_blk_map(int bank){ // 역방향으로 검사, return -1 when failed
	for(int blk = BLKS_PER_BANK-1; blk >= 0; blk--){
		if(Block_Status[bank][blk]==EMPTY) return blk;
	}
	return -1;
}
int is_vpn_cached(int bank, int vpn){ // return -1 when miss
	FOR(offset, N_SLOT_PB){	
		if(CMT_vpn[bank][offset]==vpn) {
			stats.CMT_hit++;
			return offset; 
		}
	}
	stats.CMT_miss++;
	return -1;
}


int lpn2ppn(int bank, int lpn){ // L2P[bank][lpn], 캐싱 안되어있으면 캐싱까지 해줌.
	int vpn = lpn2vpn(lpn);
	int offset = is_vpn_cached(bank, vpn);
	if(offset == -1){// Cache Miss
		if(get_free_slot(bank) == -1){ make_free_slot(bank, get_LRU_slot(bank)); } // FLUSH TO NAND, 여유공간 만들기
		int free_slot = get_free_slot(bank); assert(free_slot != -1); // 빈 슬롯 찾기
		use_free_slot(bank, vpn, free_slot); // 빈 슬롯에 쓰기
		offset = is_vpn_cached(bank, vpn); assert(offset==free_slot); // 이젠 반드시 CMT에 있어야 함
	}// ELSE: Cache HIT
	return CMT_Data[bank][offset][lpn%CMT_NSECT];
}
void update_L2P(int bank, int lpn, int ppn){ // L2P[bank][lpn] = ppn;
	int vpn = lpn2vpn(lpn);
	int offset = is_vpn_cached(bank, vpn);
	if(offset == -1){ // Cache Miss
		if(get_free_slot(bank) == -1){ make_free_slot(bank, get_LRU_slot(bank)); } // FLUSH TO NAND, 여유공간 만들기
		int free_slot = get_free_slot(bank); assert(free_slot != -1); // 빈 슬롯 찾기
		use_free_slot(bank, vpn, free_slot); // 빈 슬롯에 쓰기
		offset = is_vpn_cached(bank, vpn); assert(offset==free_slot); // 이젠 반드시 CMT에 있어야 함
	}// ELSE: Cache Hit
	if(is_VPN_first_time[bank][vpn] == 1){
		is_VPN_first_time[bank][vpn] = 0;
		FOR(i,CMT_NSECT) CMT_Data[bank][offset][i] = -1;
	}
	CMT_Data[bank][offset][lpn%CMT_NSECT] = ppn; assert(ppn>=0); 
	CMT_dirty[bank][offset] = DIRTY;
	return;
}


static void make_free_slot(int bank, int victim_slot){ // CMT[bank][cache_slot] 을 free시킨다.
	original_make_free_slot(bank, CMT_vpn[bank][victim_slot], victim_slot);
}
static void original_make_free_slot(u32 bank, u32 vpn, u32 victim_slot)// Make_Free_Slot
{// bank, victim_slot 을 FLASH의 next_map_ppn에 FLUSH한다. map GC가 발생한다면 처리한다.
	assert(vpn == CMT_vpn[bank][victim_slot]);
	if(CMT_dirty[bank][victim_slot] == DIRTY){// Dirty하면 nand에 써줘야함
		assert(Next_Map_PPN[bank] <= PAGES_PER_BLK * BLKS_PER_BANK);
		assert(GC_Trigger_Map_PPN[bank] <= PAGES_PER_BLK * BLKS_PER_BANK);
		if(Next_Map_PPN[bank] == GC_Trigger_Map_PPN[bank]){ map_garbage_collection(bank); } // next map ppn, gc trigger map ppn 유효한 값으로 새로 할당받기
		// 이전에 매핑된 map page의 PPN이 있다면 invalid처리 해줘야함
		if(GTD[bank][CMT_vpn[bank][victim_slot]] >= 0) 
			isValid[bank][GTD[bank][CMT_vpn[bank][victim_slot]]] = INVALID;
		GTD[bank][CMT_vpn[bank][victim_slot]] = Next_Map_PPN[bank]; // 새 map page의 ppn으로 매핑
		assert(isValid[bank][Next_Map_PPN[bank]] == VALID);
		int result = nand_write(bank, Next_Map_PPN[bank]/PAGES_PER_BLK, Next_Map_PPN[bank]%PAGES_PER_BLK, CMT_Data[bank][victim_slot], &CMT_vpn[bank][victim_slot]); stats.map_write++;
		Next_Map_PPN[bank]++;
	}
	CMT_vpn[bank][victim_slot] = -1;
	CMT_age[bank][victim_slot] = 0; CMT_dirty[bank][victim_slot] = CLEAN;
}

static void use_free_slot(u32 bank, u32 vpn, u32 free_slot)
{// vpn에 해당하는 ppn을 GTD로 구하고, 그 ppn에 있는 데이터를 CMT의 free_slot에 무지성으로 적어줌.
	assert(CMT_vpn[bank][free_slot] == -1);
	int ppn = GTD[bank][vpn]; int tmp_data[8]; int tmp_spare; // ppn 이 -1 이 될 수 있다!!!!!!!!!!!!!!!
	if(ppn >= 0){
		int result = nand_read(bank, ppn/PAGES_PER_BLK, ppn%PAGES_PER_BLK, tmp_data, &tmp_spare);
		FOR(i, CMT_NSECT){
			CMT_Data[bank][free_slot][i] = tmp_data[i]; 
			assert(tmp_data[i] >= -1);
		}
	}
	else{
		if(is_VPN_first_time[bank][vpn] == 1){
			is_VPN_first_time[bank][vpn] = 0;
			FOR(i, CMT_NSECT){ CMT_Data[bank][free_slot][i] = -1; }
		}
	}
	CMT_vpn[bank][free_slot] = vpn; 
	// assert(tmp_spare == vpn);
	// if(tmp_spare != vpn) printf("ERROR: tmp_spare == %d, vpn == %d\n", tmp_spare, vpn);
	CMT_age[bank][free_slot] = 0; CMT_dirty[bank][free_slot] = DIRTY;
}
static void map_garbage_collection(u32 bank){ // NAND상에 빈 MAP용 Page를 만들어주는 함수
	// data gc 도중 map gc가 일어날 수 있음에 유의
	assert(Next_Map_PPN[bank] == GC_Trigger_Map_PPN[bank]);
	stats.map_gc_cnt++;
	int victim_blk, free_blk, offset;
	int tmp_data[8]; int vpn;
	int copy_cnt = 0;
	victim_blk = greedy_map_blk(bank); free_blk = get_free_blk_map(bank);
	FOR(pg, PAGES_PER_BLK){ // Victim의 Valid Page 노아의 방주 탈출
		if(isValid[bank][victim_blk*PAGES_PER_BLK + pg] == INVALID) continue;
		nand_read(bank, victim_blk, pg, tmp_data, &vpn);
		assert(vpn != -1); offset = is_vpn_cached(bank, vpn);
		if(offset != -1){ // copy from cache, not nand -> UNDIRTY라도 Valid인 이상 일단 이민시켜야하기때문에 write는 불가피함
			nand_write(bank, free_blk, copy_cnt, CMT_Data[bank][offset], &vpn); stats.map_gc_write++;
		}else{// NOT CACHED: copy from nand
			nand_write(bank, free_blk, copy_cnt, tmp_data, &vpn); stats.map_gc_write++;
		}
		GTD[bank][vpn] = free_blk*PAGES_PER_BLK + copy_cnt; // CMT는 건드릴 필요 없음.
		copy_cnt++;
	}
	Next_Map_PPN[bank] = free_blk*PAGES_PER_BLK + copy_cnt;  GC_Trigger_Map_PPN[bank] = (free_blk+1)*PAGES_PER_BLK;
	FOR(pg, PAGES_PER_BLK){ // victim 싹 원상복귀
		isValid[bank][victim_blk*PAGES_PER_BLK + pg] = VALID;
	}
	nand_erase(bank, victim_blk); 
	Block_Status[bank][victim_blk] = EMPTY;
	Block_Status[bank][free_blk] = MAP;
}
/* 
map_garbage_collection 사양
발동조건: 쓰면 안되는 ppn에 드디어 next_map_ppn이 접근했다.
대처법: 1. map block 중 victim을 선정한 뒤, 처음 포착된 free block에 victim의 valid한 page를 전부 copy-off해주고
2. next_map_ppn을 마지막으로 copy-off된 free-block의 page 바로다음으로 설정
3. gc_trigger_ppn을 free block 직후 block의 0번째 page로 설정
4. 신/구블럭 isValid, 신/구블럭 Block Status 수정
5. copy-off된 page들에 대하여 GTD의 ppn값을 정정해줌.
*/