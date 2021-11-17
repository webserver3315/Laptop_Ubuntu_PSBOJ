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
Data GC 할 때 Copy Off 문제가 있었고 고친듯함.
만일을 위해 print문은 전부 남겨둠.
my_input1 실행시 터지는건 무지성으로 설정해둔 data greedy 때문에 invalid 가 없는 blk 을 victim으로 골라서 자폭하는 것.

일단 첫번째 요구사항 충족시켰고, input1은 통과함.
아래 두 번째 요구사항과, 508 번줄의 에러검출문이 무용한게 맞는지 체크해봐야함.

그리고, LINE61에서 Data GC 할 때 Copy off 제대로 되는지 확인 필요함.
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

// int L2P [N_BANKS][N_LPNS_PB]; // lpn 이 쓰인다.


extern int line;
void print_constant(){
	printf("N_BANKS = %d\n", N_BANKS);
	printf("BLKS_PER_BANK = %d\n", BLKS_PER_BANK);
	printf("PAGES_PER_BLK = %d\n", PAGES_PER_BLK);
	printf("N_SLOT_PB = %d\n", N_SLOT_PB);
	printf("CMT_NSECT = %d\n", CMT_NSECT);
	printf("N_MAP_PAGES_PB = %d\n", N_MAP_PAGES_PB);
	printf("N_MAP_BLOCKS_PB = %d\n", N_MAP_BLOCKS_PB);
	printf("N_USER_BLOCKS_PB = %d\n", N_USER_BLOCKS_PB);
	printf("N_USER_OP_BLOCKS_PB = %d\n", N_USER_OP_BLOCKS_PB);
	printf("N_MAP_OP_BLOCKS_PB = %d\n", N_MAP_OP_BLOCKS_PB);
	printf("N_OP_BLOCKS_PB = %d\n", N_OP_BLOCKS_PB);
	printf("N_LPNS_PB = %d\n", N_LPNS_PB);
	printf("N_PPNS_PB = %d\n", N_PPNS_PB);
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
	for(int bb=0;bb<NBANKS;bb++) printf("<Bank%d>\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t",bb);
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

	printf("\n");
	for(int vpn=0; vpn<N_MAP_BLOCKS_PB*PAGES_PER_BLK; vpn++){
		for(int bb=0;bb<N_BANKS;bb++){
			printf("GTD[%d] == %d \t\t\t\t\t\t\t\t\t\t\t\t", vpn, GTD[bb][vpn]);
		}
		printf("\n");
	}
	for(int slot=0; slot<N_SLOT_PB;slot++){
		for(int bb=0;bb<N_BANKS;bb++){
			printf("CMT[%d].data[0:7] == [ %d | ",slot, CMT_vpn[bb][slot]);
			for (int i = 0; i < 7; i++) {
				printf("%d, ", CMT_Data[bb][slot][i]);
			}
			printf("%d | D:%d | A:%d ] \t\t", CMT_Data[bb][slot][7], CMT_dirty[bb][slot], CMT_age[bb][slot]);
		}
		printf("\n");
	}
	printf("\n");
	for(int halved_ppn=0; halved_ppn<NBLKS*NPAGES;halved_ppn++){
		for(int bb=0;bb<N_BANKS;bb++){
			int ppn = bb*NBLKS*NPAGES + halved_ppn;
			// if(halved_ppn<N_LPNS_PB) printf("L2P[%d][%d] == %d \t\t",bb, halved_ppn, L2P[bb][halved_ppn]);
			// else printf("\t\t\t\t");
			if(Block_Status[bb][halved_ppn/PAGES_PER_BLK] == MAP){
				printf("ppn[%d].data[0:7] == [ %d | ",halved_ppn, nand[ppn].spare);
				for (int i = 0; i < 7; i++) {
					printf("%d, ", nand[ppn].data[i]);
				}
				printf("%d | ", nand[ppn].data[7]);
			}else{
				printf("ppn[%d].data[0:7] == [ %d | ",halved_ppn, nand[ppn].spare);
				for (int i = 0; i < 7; i++) {
					printf("%x, ", nand[ppn].data[i]);
				}
				printf("%x | ", nand[ppn].data[7]);
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



inline int lpn2vpn(int lpn){
	return lpn/N_MAP_ENTRIES_PER_PAGE;
}

int greedy_data_blk(int bank){ // 무지성으로 greedy victim을 선정함
	// int biggest_invalid = 0;
	// int victim = -1;
	// for(int pblk=BLKS_PER_BANK-1;pblk>=0;pblk--){
	// 	if(Block_Status[bank][pblk]!=DATA) continue;
	// 	int invalid_cnt=0;
	// 	FOR(pg, PAGES_PER_BLK){
	// 		if(isValid[bank][pblk*PAGES_PER_BLK+pg] == INVALID) invalid_cnt++;
	// 	}
	// 	if(biggest_invalid<=invalid_cnt) {
	// 		biggest_invalid = invalid_cnt;
	// 		victim = pblk;
	// 	}
	// }
	// return victim;
	return 1;
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
	int victim_pblk = greedy_data_blk(bank); int free_pblk = get_free_blk_data(bank); assert(victim_pblk!=-1 && free_pblk != -1);
	int victim_first_ppn = victim_pblk * PAGES_PER_BLK; int free_first_ppn = free_pblk * PAGES_PER_BLK;
	printf("Data GC Called!\n");
	printf("Victim Data blk == %d\n", victim_pblk);
	int immigrants_cnt = 0;
	FOR(page_offset, PAGES_PER_BLK){
		int tmp_data[8]; int tmp_lpn;
		int victim_ppn = victim_first_ppn + page_offset;
		if(isValid[bank][victim_ppn] == INVALID) continue; // inValid 페이지는 복사하지 않는다.
		printf("Data GC Copy-off ppn's %d -> %d\n", victim_pblk*PAGES_PER_BLK + page_offset,free_pblk*PAGES_PER_BLK + immigrants_cnt);
		nand_read(bank, victim_pblk, page_offset, tmp_data, &tmp_lpn); // 아직 버퍼 미구현이므로 tmp_spare 볼 필요 없음. 
		nand_write(bank, free_pblk, immigrants_cnt, tmp_data, &tmp_lpn);
		update_L2P(bank, tmp_lpn, free_first_ppn + immigrants_cnt); 
		immigrants_cnt++;
		/*
		1. 동일한 lpn에 매핑된 ppn이 victim_blk*PGPBLK+pg 에서 free_pblk*PGPBLK+immigrants_cnt 로 이동함.
		2. 기존 매핑블럭 FLASH에 Invalid 처리를 함. 그 뒤, CMT를 수정해야 함. NAND에 반영은 FLUSH할때 되겠지.
		3. CMT의 공간이 꽉 차면, evict 해서라도 올려야 함.
		4. GDT도 바꿔야 함.
		*/
	}
	FOR(i, PAGES_PER_BLK) isValid[bank][victim_first_ppn + i] = VALID;
	Next_Data_PPN[bank] = free_first_ppn + immigrants_cnt;
	GC_Trigger_Data_PPN[bank] = free_first_ppn + PAGES_PER_BLK;
	nand_erase(bank, victim_pblk); 
	Block_Status[bank][victim_pblk] = EMPTY; 
	Block_Status[bank][free_pblk] = DATA;
	printf("Data GC END\n");
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
	if(send_kazu == 1){
		bank = (first_page_first_lba / SECTORS_PER_PAGE) % N_BANKS;
		lpn = (first_page_first_lba / SECTORS_PER_PAGE) / N_BANKS;
		int ppn = lpn2ppn(bank, lpn);
		if(ppn == -1){ // EMPTY여부를 확인하는건데, 이거 문제있음. 처음 ppn을 캐싱하면 -1이 아니라 쓰레기값임
			FOR(i, nsect) current_read_buffer[i] = 0xFFFFFFFFF;
		}else{
			nand_read(bank, ppn/PAGES_PER_BLK, ppn%PAGES_PER_BLK, data, &spare);
			FOR(i, nsect) current_read_buffer[i] = data[first_lba_offset + i];
		}
	}
	else{
		FOR(page_offset, send_kazu){
			lpn = (page_offset + (first_page_first_lba/SECTORS_PER_PAGE)) / N_BANKS;
			bank = (page_offset + (first_page_first_lba/SECTORS_PER_PAGE)) % N_BANKS;
			int sector_kazu = 0; int ppn = lpn2ppn(bank, lpn);
			// printf("R(%d,%d) => bank = %d, ppn = %d\n", lba, nsect, bank, ppn);
			if(page_offset == 0){ // 첫타
				sector_kazu = 8 - first_lba_offset;
				if(ppn == -1){ // Empty
					FOR(i, sector_kazu) current_read_buffer[i] = 0xFFFFFFFFF;
				}else{
					nand_read(bank, ppn/PAGES_PER_BLK, ppn%PAGES_PER_BLK, data, &spare);
					FOR(i, sector_kazu) current_read_buffer[i] = data[first_lba_offset + i];
				}
			}else if(page_offset == send_kazu - 1){ // 막타
				sector_kazu = last_lba_offset + 1;
				if(ppn == -1){
					FOR(i, sector_kazu) current_read_buffer[i] = 0xFFFFFFFF;
				}else{
					nand_read(bank, ppn/PAGES_PER_BLK, ppn%PAGES_PER_BLK, data, &spare);
					FOR(i, sector_kazu) current_read_buffer[i] = data[i];
				}
			}else{ // 중간타
				sector_kazu = 8;
				if(ppn == -1){
					FOR(i, sector_kazu) current_read_buffer[i] = 0xFFFFFFFF;
				}else{
					nand_read(bank, ppn/PAGES_PER_BLK, ppn%PAGES_PER_BLK, data, &spare);
					FOR(i, sector_kazu) current_read_buffer[i] = data[i];
				}
			}
			current_read_buffer += sector_kazu;
		}
	}
}

void write_through_lpn(int bank, int lpn, int* data){
	if(Next_Data_PPN[bank] == GC_Trigger_Data_PPN[bank]) garbage_collection(bank);
	int ppn = Next_Data_PPN[bank];
	int before_ppn = lpn2ppn(bank, lpn);
	printf("before_ppn: %d, lpn: %d\n", before_ppn, lpn);
	if(before_ppn != -1) isValid[bank][before_ppn] = INVALID; // 덮어쓰기라면 기존 L2P invalid해줘야함. 근데 이거 OP블럭도 isValid 0때리는 문제발생할수있다는듯?
	update_L2P(bank, lpn, Next_Data_PPN[bank]);
	nand_write(bank, ppn/PAGES_PER_BLK, ppn%PAGES_PER_BLK, data, &lpn);
	Next_Data_PPN[bank]++;
	printf("write_through_lpn finished\n");
	show_whole_nand();
}

void ftl_write(u32 lba, u32 nsect, u32 *write_buffer) // 0th lba ~ 8 sect => 0~7th lba
{
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
		lpn = (first_page_first_lba / SECTORS_PER_PAGE) / N_BANKS;
		bank = (first_page_first_lba / SECTORS_PER_PAGE) % N_BANKS;
		ppn = lpn2ppn(bank, lpn); sector_kazu = nsect;
		// if(line >= 7232 && line < 7240) 
		// printf("W(%d,%d) => bank = %d, ppn = %d\n", lba, nsect, bank, ppn);
		if(ppn == -1){ // Empty
			FOR(i, first_lba_offset) data[i] = 0xFFFFFFFF;
			for(int i=last_lba_offset+1;i<8;i++) data[i] = 0xFFFFFFFF;
		}else{
			nand_read(bank, ppn/PAGES_PER_BLK, ppn%PAGES_PER_BLK, data, &spare);
		}
		FOR(i, sector_kazu) data[first_lba_offset + i] = current_write_buffer[i];
		// printf("send data: [ ");
		// FOR(i, 7) printf("%2x, ",data[i]);
		// printf("%2x ]\n", data[7]);
		write_through_lpn(bank, lpn, data); current_write_buffer += sector_kazu;
	}else{
		FOR(page_offset, send_kazu){
			lpn = (page_offset + (first_page_first_lba / SECTORS_PER_PAGE)) / N_BANKS;
			bank = (page_offset + (first_page_first_lba / SECTORS_PER_PAGE)) % N_BANKS;
			ppn = lpn2ppn(bank, lpn);
			if(page_offset == 0){ // 첫타
				sector_kazu = 8 - first_lba_offset;
				if(ppn == -1){ // Empty
					FOR(i, first_lba_offset) data[i] = 0xFFFFFFFF;
				}else{
					nand_read(bank, ppn/PAGES_PER_BLK, ppn%PAGES_PER_BLK, data, &spare);
				}
				FOR(i, sector_kazu) data[first_lba_offset + i] = current_write_buffer[i];
			}else if(page_offset == send_kazu - 1){ // 막타
				sector_kazu = last_lba_offset + 1;
				if(ppn == -1){
					for(int i=last_lba_offset+1;i<8;i++){ data[i]=0xffffffff; }
				}else{
					nand_read(bank, ppn/PAGES_PER_BLK, ppn%PAGES_PER_BLK, data, &spare);
				}
				FOR(i, sector_kazu) data[i] = current_write_buffer[i];
			}else{
				sector_kazu = 8;
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
			CMT_dirty[bank][slot] = 0;
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
	int ret = 0;
	return ret;
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
		if(biggest_invalid<invalid_cnt) victim = pblk;
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
	FOR(offset, N_SLOT_PB){	if(CMT_vpn[bank][offset]==vpn) return offset; }
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
	if(is_VPN_first_time[bank][vpn] == 1){
		is_VPN_first_time[bank][vpn] = 0;
		FOR(i,CMT_NSECT) CMT_Data[bank][offset][i] = -1;
	}
	return CMT_Data[bank][offset][lpn%CMT_NSECT];
}
void update_L2P(int bank, int lpn, int ppn){ // L2P[bank][lpn] = ppn;
	int vpn = lpn2vpn(lpn);
	int offset = is_vpn_cached(bank, vpn);
	if(offset == -1){ // Cache Miss
		if(get_free_slot(bank) == -1){ make_free_slot(bank, get_LRU_slot(bank)); } // FLUSH TO NAND, 여유공간 만들기
		printf("After get_free_slot(bank)\n");
		show_whole_nand();
		int free_slot = get_free_slot(bank); assert(free_slot != -1); // 빈 슬롯 찾기
		use_free_slot(bank, vpn, free_slot); // 빈 슬롯에 쓰기
		offset = is_vpn_cached(bank, vpn); assert(offset==free_slot); // 이젠 반드시 CMT에 있어야 함
	}// ELSE: Cache Hit
	printf("Cache Hit or Caching Complete\n");
	show_whole_nand();
	if(is_VPN_first_time[bank][vpn] == 1){
		is_VPN_first_time[bank][vpn] = 0;
		FOR(i,CMT_NSECT) CMT_Data[bank][offset][i] = -1;
	}
	CMT_Data[bank][offset][lpn%CMT_NSECT] = ppn;
	CMT_dirty[bank][offset] = 1;
	printf("Update_L2P Finished\n");
	show_whole_nand();
	return;
}


static void make_free_slot(int bank, int victim_slot){ // CMT[bank][cache_slot] 을 free시킨다.
	original_make_free_slot(bank, CMT_vpn[bank][victim_slot], victim_slot);
}
static void original_make_free_slot(u32 bank, u32 vpn, u32 victim_slot)// Make_Free_Slot
{// bank, victim_slot 을 FLASH의 next_map_ppn에 FLUSH한다. map GC가 발생한다면 처리한다.
	assert(vpn == CMT_vpn[bank][victim_slot]);
	if(CMT_dirty[bank][victim_slot] == 1){// Dirty하면 nand에 써줘야함
		assert(Next_Map_PPN[bank] <= PAGES_PER_BLK * BLKS_PER_BANK);
		assert(GC_Trigger_Map_PPN[bank] <= PAGES_PER_BLK * BLKS_PER_BANK);
		if(Next_Map_PPN[bank] == GC_Trigger_Map_PPN[bank]){ map_garbage_collection(bank); } // next map ppn, gc trigger map ppn 유효한 값으로 새로 할당받기
		// 이전에 매핑된 map page의 PPN이 있다면 invalid처리 해줘야함
		if(GTD[bank][CMT_vpn[bank][victim_slot]] >= 0) 
			isValid[bank][GTD[bank][CMT_vpn[bank][victim_slot]]] = INVALID;
		GTD[bank][CMT_vpn[bank][victim_slot]] = Next_Map_PPN[bank]; // 새 map page의 ppn으로 매핑
		// isValid[bank][Next_Map_PPN[bank]] = VALID;
		assert(isValid[bank][Next_Map_PPN[bank]] == VALID);
		// printf("GTD[bank][CMT_vpn[bank][victim_slot]] = %d, CMT_vpn[bank][victim_slot] = %d\n",GTD[bank][CMT_vpn[bank][victim_slot]],CMT_vpn[bank][victim_slot]);
		int result = nand_write(bank, Next_Map_PPN[bank]/PAGES_PER_BLK, Next_Map_PPN[bank]%PAGES_PER_BLK, CMT_Data[bank][victim_slot], &CMT_vpn[bank][victim_slot]);
		// printf("nand_write(%d,%d,%d,...,...)\n",bank, Next_Map_PPN[bank]/PAGES_PER_BLK, Next_Map_PPN[bank]%PAGES_PER_BLK);

		// printf("FLUSH_RESULT = %d\n",result);
		// show_whole_nand();
		Next_Map_PPN[bank]++;
	}
	CMT_vpn[bank][victim_slot] = -1;
	CMT_age[bank][victim_slot] = 0; CMT_dirty[bank][victim_slot] = 0;
}

static void use_free_slot(u32 bank, u32 vpn, u32 free_slot)
{// vpn에 해당하는 ppn을 GTD로 구하고, 그 ppn에 있는 데이터를 CMT의 free_slot에 무지성으로 적어줌.
	assert(CMT_vpn[bank][free_slot] == -1);
	int ppn = GTD[bank][vpn]; int tmp_data[8]; int tmp_spare;
	nand_read(bank, ppn/PAGES_PER_BLK, ppn%PAGES_PER_BLK, tmp_data, &tmp_spare);
	memcpy(CMT_Data[bank][free_slot], tmp_data, sizeof(int)*SECTORS_PER_PAGE);
	// FOR(i, CMT_NSECT){
	// 	CMT_Data[bank][free_slot][i] = tmp_data[i];
	// }
	CMT_vpn[bank][free_slot] = vpn; 
	// assert(tmp_spare == vpn);
	// if(tmp_spare != vpn) printf("ERROR: tmp_spare == %d, vpn == %d\n", tmp_spare, vpn);
	CMT_age[bank][free_slot] = 0; CMT_dirty[bank][free_slot] = 0;
}
static void map_garbage_collection(u32 bank){ // NAND상에 빈 MAP용 Page를 만들어주는 함수
	// data gc 도중 map gc가 일어날 수 있음에 유의
	assert(Next_Map_PPN[bank] == GC_Trigger_Map_PPN[bank]);
	// printf("MAP GC OCCURED\n");
	int victim_blk, free_blk, offset;
	int tmp_data[8]; int vpn;
	int copy_cnt = 0;
	victim_blk = greedy_map_blk(bank); free_blk = get_free_blk_map(bank);
	FOR(pg, PAGES_PER_BLK){ // Victim의 Valid Page 노아의 방주 탈출
		if(isValid[bank][victim_blk*PAGES_PER_BLK + pg] == INVALID) continue;
		nand_read(bank, victim_blk, pg, tmp_data, &vpn);
		assert(vpn != -1); offset = is_vpn_cached(bank, vpn);
		if(offset != -1){ // copy from cache, not nand -> UNDIRTY라도 Valid인 이상 일단 이민시켜야하기때문에 write는 불가피함
			nand_write(bank, free_blk, copy_cnt, CMT_Data[bank][offset], &vpn);
		}else{// NOT CACHED: copy from nand
			nand_write(bank, free_blk, copy_cnt, tmp_data, &vpn);
		}
		// printf("Map GC Copy-off ppn's %d -> %d\n", victim_blk*PAGES_PER_BLK + pg,free_blk*PAGES_PER_BLK + copy_cnt);
		// printf("Map GC Copy-off GTD[%d][%d] Follow-up %d -> %d\n", bank, vpn, GTD[bank][vpn], free_blk*PAGES_PER_BLK + copy_cnt);
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
	// show_whole_nand();
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