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
일단 대충 다 구현함.
테스트는 안해봄.
1. LPN 함수를 무지성 DRAM으로 바꾼 뒤, 테스트 싹 돌려서 무결성 확인
2. LPN 함수를 DFTL 버전으로 바꾼 뒤, 테스트 싹 돌려서 무결성 확인
3. I/O Buffer 의 경우, 간단히 바꾸면 될 듯 하니 두 번째 결과물 기반으로 계속 츄라이.
그리고, CMT Aging 아직 구현안됨.
=> 1. 직전.에 세이브함. 일단 CMT 비적용상태에서 알고리즘 무결성부터 테스트하자.
*/

#include "ftl.h"
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

#define FOR(x,n) for(int x=0;x<(n);x++)
#define N_SLOT_PB N_CACHED_MAP_PAGE_PB
#define CMT_NSECT N_MAP_ENTRIES_PER_PAGE
#define INVALID 0
#define VALID 1
#define EMPTY 0
#define DATA 1
#define MAP 2

int L2P [N_BANKS][N_LPNS_PB]; // lpn 이 쓰인다.

int Next_Data_PPN[N_BANKS];
int GC_Trigger_Data_PPN[N_BANKS];

int Block_Status[N_BANKS][BLKS_PER_BANK];
int isValid[N_BANKS][BLKS_PER_BANK*PAGES_PER_BLK]; // ppn임에 유의. 꼽표치고 딴데쓰면 invalid됨. 즉, invalid는 읽거나 복사하지 말라는 뜻.

int get_free_blk_data(int bank);

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

int lpn2ppn(int bank, int lpn){ // L2P[bank][lpn], 캐싱 안되어있으면 캐싱까지 해줌.
	return L2P[bank][lpn];
}
void update_L2P(int bank, int lpn, int ppn){ // L2P[bank][lpn] = ppn;
	L2P[bank][lpn] = ppn;
}

static void garbage_collection(u32 bank)
{
	assert(Next_Data_PPN[bank]==GC_Trigger_Data_PPN[bank]);
	int victim_pblk = greedy_data_blk(bank); int free_pblk = get_free_blk_data(bank); assert(victim_pblk!=-1 && free_pblk != -1);
	int victim_first_ppn = victim_pblk * PAGES_PER_BLK; int free_first_ppn = free_pblk * PAGES_PER_BLK;
	int immigrants_cnt = 0;
	FOR(page_offset, PAGES_PER_BLK){
		int tmp_data[8]; int tmp_lpn;
		int victim_ppn = victim_first_ppn + page_offset;
		if(isValid[bank][victim_ppn] == INVALID) continue; // inValid 페이지는 복사하지 않는다.
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
}
void ftl_open(){
	nand_init(N_BANKS, BLKS_PER_BANK, PAGES_PER_BLK);
	FOR(bank, N_BANKS){
		// FOR(blk, BLKS_PER_BANK) Block_Status[bank][blk]=EMPTY;
		FOR(lpn, N_LPNS_PB) L2P[bank][lpn] = -1;
		GC_Trigger_Data_PPN[bank] = PAGES_PER_BLK*(BLKS_PER_BANK - 1);
		FOR(blk, BLKS_PER_BANK){
			if(blk == BLKS_PER_BANK - 1) Block_Status[bank][blk] = EMPTY;
			else Block_Status[bank][blk] = DATA;
		}
		FOR(ppn,BLKS_PER_BANK*PAGES_PER_BLK) isValid[bank][ppn]=VALID;
		Next_Data_PPN[bank] = 0;
	}
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
	// printf("READ_HERE0\n");
	if(send_kazu == 1){
		// printf("READ_HERE1\n");
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
		// printf("READ_HERE2\n");
		FOR(page_offset, send_kazu){
			lpn = (page_offset + (first_page_first_lba/SECTORS_PER_PAGE)) / N_BANKS;
			bank = (page_offset + (first_page_first_lba/SECTORS_PER_PAGE)) % N_BANKS;
			int sector_kazu = 0; int ppn = lpn2ppn(bank, lpn);
			if(page_offset == 0){ // 첫타
				// printf("READ_HERE3\n");
				sector_kazu = 8 - first_lba_offset;
				if(ppn == -1){ // Empty
					FOR(i, sector_kazu) current_read_buffer[i] = 0xFFFFFFFFF;
				}else{
					nand_read(bank, ppn/PAGES_PER_BLK, ppn%PAGES_PER_BLK, data, &spare);
					FOR(i, sector_kazu) current_read_buffer[i] = data[first_lba_offset + i];
				}
			}else if(page_offset == send_kazu - 1){ // 막타
				// printf("READ_HERE4\n");
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
	if(before_ppn != -1) isValid[bank][before_ppn] = INVALID; // 덮어쓰기라면 기존 L2P invalid해줘야함. 근데 이거 OP블럭도 isValid 0때리는 문제발생할수있다는듯?
	update_L2P(bank, lpn, Next_Data_PPN[bank]);
	nand_write(bank, ppn/PAGES_PER_BLK, ppn%PAGES_PER_BLK, data, &lpn);
	Next_Data_PPN[bank]++;
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
		if(ppn == -1){ // Empty
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