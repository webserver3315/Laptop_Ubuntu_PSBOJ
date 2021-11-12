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
#define EMPTY 0
#define DATA 1
#define MAP 2

int L2P [N_BANKS][N_LPNS_PB]; // lpn 이 쓰인다.

int CMT_vpn[N_BANKS][N_SLOT_PB]; // -1 == FREE CMT SLOT
int CMT_dirty[N_BANKS][N_SLOT_PB];
int CMT_age[N_BANKS][N_SLOT_PB];
int CMT_Data[N_BANKS][N_SLOT_PB][N_MAP_ENTRIES_PER_PAGE];

int GTD[N_BANKS][N_MAP_PAGES_PB]; // lpn2ppn for Mapping Block
int Next_Data_PPN[N_BANKS];
int Next_Map_PPN[N_BANKS];
int GC_Trigger_Data_PPN[N_BANKS];
int GC_Trigger_Map_PPN[N_BANKS];

int Block_Status[N_BANKS][BLKS_PER_BANK];
int isValid[N_BANKS][BLKS_PER_BANK*PAGES_PER_BLK]; // ppn임에 유의. 꼽표치고 딴데쓰면 invalid됨. 즉, invalid는 읽거나 복사하지 말라는 뜻.

int get_LRU_slot(int bank){ // 무지성으로 해당 bank에서 Most LRU Slot을 반환함.
	int biggest_age = -1;
	int ret = -1;
	FOR(slot, N_SLOT_PB){
		if(biggest_age<CMT_age[bank][slot]) {
			biggest_age = CMT_age[bank][slot]; ret = slot;
		}
	}
	return ret;
}
int get_free_slot(int bank){
	FOR(slot, N_SLOT_PB) if(CMT_vpn[bank][slot] == -1) return slot;
	return -1;
}
int greedy_data_blk(int bank){ // 무지성으로 greedy victim을 선정함
	int biggest_invalid = -1;
	int victim = -1;
	FOR(pblk, BLKS_PER_BANK){
		if(Block_Status[bank][pblk]!=DATA) continue;
		int invalid_cnt=0;
		FOR(pg, PAGES_PER_BLK){
			if(isValid[bank][pblk*PAGES_PER_BLK+pg]==1) invalid_cnt++;
		}
		if(biggest_invalid<invalid_cnt) victim = pblk;
	}
	return victim;
}
int greedy_map_blk(int bank){ // 무지성으로 greedy victim을 선정함
	int biggest_invalid = -1;
	int victim = -1;
	FOR(pblk, BLKS_PER_BANK){
		if(Block_Status[bank][pblk]!=MAP) continue;
		int invalid_cnt=0;
		FOR(pg, PAGES_PER_BLK){
			if(isValid[bank][pblk*PAGES_PER_BLK+pg]==1) invalid_cnt++;
		}
		if(biggest_invalid<invalid_cnt) victim = pblk;
	}
	return victim;
}
int get_free_blk_map(int bank){ // 역방향으로 검사
	for(int blk = BLKS_PER_BANK-1; blk >= 0; blk--){
		if(Block_Status[bank][blk]==EMPTY) return ret;
	}
	return -1;
}
int get_free_blk_data(int bank){ // 순방향으로 검사
	FOR(blk, BLKS_PER_BANK){
		if(Block_Status[bank][blk]==EMPTY) return ret;
	}
	return -1;
}
int is_vpn_cached(int bank, int vpn){
	FOR(offset, N_SLOT_PB){	if(CMT_vpn[bank][offset]==vpn) return offset; }
	return 0;
}
inline int lpn2vpn(int lpn){
	return lpn/N_MAP_ENTRIES_PER_PAGE;
}

static void map_write(u32 bank, u32 vpn, u32 victim_slot)
{// bank, victim_slot 을 NAND에 FLUSH한다. map GC가 발생한다면 처리한다.
	if(CMT_dirty[bank][victim_slot]==1){// Dirty하면 nand에 써줘야함
		if(Next_Map_PPN[bank] == GC_Trigger_Map_PPN[bank]){ map_garbage_collection(bank); } // Trigger 건드림
		isValid[bank][GTD[bank][CMT_vpn[bank][victim_slot]]]=0; // 이전 ppn invalid 처리
		GTD[bank][CMT_vpn[bank][victim_slot]] = Next_Map_PPN[bank];
		nand_write(bank, Next_Map_PPN[bank]/PAGES_PER_BLK, Next_Map_PPN[bank]%PAGES_PER_BLK, CMT_Data[bank][victim_slot], &CMT_vpn[bank][victim_slot]);
	}
	CMT_vpn[bank][victim_slot] = -1; CMT_age[bank][victim_slot] = 0;
}
static void map_read(u32 bank, u32 vpn, u32 free_slot)
{// vpn에 해당하는 ppn을 GTD로 구하고, 그 ppn에 있는 데이터를 CMT의 free_slot에 무지성으로 적어줌.
	assert(CMT_vpn[bank][free_slot] == -1);
	int ppn = GTD[bank][vpn]; int tmp_data[8]; int tmp_spare;
	nand_read(bank, ppn/PAGES_PER_BLK, ppn%PAGES_PER_BLK, tmp_spare, &tmp_spare);
	memcpy(CMT_Data[bank][free_slot], tmp_data, SECTORS_PER_PAGE);
	CMT_vpn[bank][free_slot] = vpn; CMT_age[bank][free_slot] = 0; CMT_dirty[bank][free_slot] = 0;
}
static void my_map_write(int bank, int cache_slot){
	map_write(bank, CMT_vpn[bank][cache_slot], cache_slot);
}

/*
L2P 사양
0. lpn으로 vpn 구하기
1. vpn에 해당하는 CMT 체크 => 캐시히트면 그냥 CMT에 적힌 값 리턴
2. vpn이 CMT에 없다면, GTD 체크
3. GTD에도 값이 안적혀있다면, 아다임. => 대안 강구할 것 => GTD는 -1이 될 수 없도록 초기화를 시켜둠.
4. GTD에 있다면, map_block의 해당 ppn 페이지를 잠시 copy
5. CMT에 복사해줘야함. CMT 빈공간 확인
7. CMT에 빈공간 없으면, evict 해서라도 만들어야 한다. evict하자.
8. evict 대상은 LRU로 정하고, evict 도 함수를 따로 만들었으니 그대로 쓰자.
9. 이 evcit 과정 중에 map_gc 가 발생할 수 있음에 유의하자.
*/
int lpn2ppn(int bank, int lpn){ // L2P[bank][lpn], 캐싱 안되어있으면 캐싱까지 해줌.
	/*
	int vpn = lpn2vpn(lpn);
	int offset = is_vpn_cached(bank, vpn);
	if(offset == -1){// Cache Miss
		if(get_free_slot(bank) == -1){ my_map_write(bank, get_LRU_slot(bank)); } // FLUSH TO NAND, 여유공간 만들기
		int free_slot = get_free_slot(bank); assert(free_slot != -1); // 빈 슬롯 찾기
		map_read(bank, vpn, free_slot); // 빈 슬롯에 쓰기
		offset = is_vpn_cached(bank, vpn); assert(offset==free_slot); // 이젠 반드시 CMT에 있어야 함
	}// ELSE: Cache HIT
	return CMT_Data[bank][offset][lpn%CMT_NSECT];
	*/
	return L2P[bank][lpn];
}
void update_L2P(int bank, int lpn, int ppn){ // L2P[bank][lpn] = ppn;
	/*
	lpn-ppn 쌍을 연결지어줌. 만약 이미 등록되어있다면 기존의 것을 OVERWRITE함.
	L2P 업데이트 알고리즘 (Data 용) 
	1. CMT에 캐싱여부 확인
	2. CMT에 캐싱되어있다면, 해당 lpn만 정정해주고 dirty 켜주기
	3. CMT에 캐싱안되어있다면, CMT 빈공간 체크 후 빈공간 없으면 evict해서라도 caching 시켜주기
	4. CMT 수정, dirty 켜주기. NAND에 반영은 나중에 evict 될 때 되겠지.
	*/
	/*
	int vpn = lpn2vpn(lpn);
	int offset = is_vpn_cached(bank, vpn);
	if(offset == -1){ // Cache Miss
		if(get_free_slot(bank) == -1){ my_map_write(bank, get_LRU_slot(bank)); } // FLUSH TO NAND, 여유공간 만들기
		int free_slot = get_free_slot(bank); assert(free_slot != -1); // 빈 슬롯 찾기
		map_read(bank, vpn, free_slot); // 빈 슬롯에 쓰기
		offset = is_vpn_cached(bank, vpn); assert(offset==free_slot); // 이젠 반드시 CMT에 있어야 함
	}// ELSE: Cache Hit
	CMT_Data[bank][offset][lpn%CMT_NSECT] = ppn;
	int slot; for(slot=0; slot<N_SLOT_PB; slot++) if(CMT_vpn[bank][slot]==vpn) break;
	CMT_dirty[bank][slot] = 1;
	return;
	*/
	L2P[bank][lpn] = ppn;
}

static void map_garbage_collection(u32 bank){ // data gc 도중 map gc가 일어날 수 있음에 유의
	assert(Next_Map_PPN[bank]==GC_Trigger_Map_PPN[bank]);
	int victim_blk, free_blk, offset;
	int tmp_data[8]; int vpn;
	int copy_cnt = 0;
	victim_blk = greedy_map_blk(bank); free_blk = get_free_blk_map(bank);
	FOR(pg, PAGES_PER_BLK){ // Victim의 Valid Page 노아의 방주 탈출
		if(isValid[bank][victim_blk*PAGES_PER_BLK + pg]==0) continue;
		nand_read(bank, victim_blk, pg, tmp_data, &vpn); assert(vpn!=-1);
		offset = is_vpn_cached(bank, vpn);
		if(offset!=-1){ // copy from cache, not nand -> UNDIRTY라도 Valid인 이상 일단 이민시켜야하기때문에 write는 불가피함
			nand_write(bank, free_blk, copy_cnt, CMT_Data[bank][offset], vpn);
		}else{// NOT CACHED: copy from nand
			nand_write(bank, free_blk, copy_cnt, tmp_data, vpn);
		}
		GTD[bank][vpn] = free_blk*PAGES_PER_BLK + copy_cnt; // CMT는 건드릴 필요 없음.
		copy_cnt++;
	}
	Next_Map_PPN[bank] = free_blk*PAGES_PER_BLK + copy_cnt;  GC_Trigger_Map_PPN[bank] = (free_blk+1)*PAGES_PER_BLK;
	FOR(pg, PAGES_PER_BLK){ // victim 싹 원상복귀
		isValid[bank][victim_blk*PAGES_PER_BLK + pg] = 1;
	}
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



static void garbage_collection(u32 bank)
{
	assert(Next_Data_PPN[bank]==GC_Trigger_Data_PPN[bank]);
	int victim_pblk = greedy_data_blk(bank); int free_pblk = get_free_blk_data(bank); assert(victim_pblk!=-1 && free_pblk != -1);
	int victim_first_ppn = victim_pblk * PAGES_PER_BLK; int free_first_ppn = free_pblk * PAGES_PER_BLK;
	int tmp_data[8]; int lpn, vpn;
	int immigrants_cnt = 0;
	int victim_ppn;
	FOR(page_offset, PAGES_PER_BLK){
		victim_ppn = victim_first_ppn + page_offset;
		if(isValid[bank][victim_ppn] == 0) continue;
		nand_read(bank, victim_pblk, page_offset, tmp_data, &lpn); // 아직 버퍼 미구현이므로 tmp_spare 볼 필요 없음. 
		nand_write(bank, free_pblk, immigrants_cnt, tmp_data, &lpn);
		update_L2P(bank, lpn, free_first_ppn + immigrants_cnt); immigrants_cnt++;
		// Data Page 위치가 바뀌니까, GTD와 CMT도 바꿔줘야 함
		/*
		1. 동일한 lpn에 매핑된 ppn이 victim_blk*PGPBLK+pg 에서 free_pblk*PGPBLK+immigrants_cnt 로 이동함.
		2. 기존 매핑블럭 FLASH에 Invalid 처리를 함. 그 뒤, CMT를 수정해야 함. NAND에 반영은 FLUSH할때 되겠지.
		3. CMT의 공간이 꽉 차면, evict 해서라도 올려야 함.
		4. GDT도 바꿔야 함.
		*/
	}
	FOR(i, PAGES_PER_BLK) isValid[bank][victim_first_ppn + i] = 1;
	Next_Data_PPN[bank] = free_first_ppn + immigrants_cnt;
	GC_Trigger_Data_PPN[bank] = free_first_ppn + PAGES_PER_BLK;
	nand_erase(bank, victim_pblk); Block_Status[bank][victim_pblk] = EMPTY;
	return;
}
void ftl_open()
{
	FOR(bank, N_BANKS){
		FOR(slot,CMT_NSECT){
			CMT_vpn[bank][slot] = -1; CMT_dirty[bank][slot]=0; CMT_age[bank][slot]=0;
			FOR(e,CMT_NSECT) CMT_Data[bank][slot][e]=-1;
		}
		FOR(vpn, N_MAP_PAGES_PB){
			GTD[bank][vpn]=PAGES_PER_BLK*(N_USER_BLOCKS + N_USER_OP_BLOCKS_PB) + vpn;
		}
		GC_Trigger_Map_PPN[bank] = PAGES_PER_BLK*(N_USER_BLOCKS+N_USER_OP_BLOCKS_PB+N_MAP_BLOCKS_PB+N_MAP_OP_BLOCKS_PB-1);
		Next_Data_PPN[bank] = 0;
		GC_Trigger_Data_PPN[bank] = PAGES_PER_BLK*(N_USER_BLOCKS+N_USER_OP_BLOCKS_PB-1);
		Next_Map_PPN[bank] = PAGES_PER_BLK*(N_USER_BLOCKS_PB+N_USER_OP_BLOCKS_PB);
		FOR(ppn,BLKS_PER_BANK*PAGES_PER_BLK) isValid[bank][ppn]=1;
		FOR(blk, BLKS_PER_BANK) Block_Status[bank][blk]=EMPTY;
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
	if(send_kazu == 1){
		int ppn = lpn2ppn(bank, lpn);
		bank = (first_page_first_lba / SECTORS_PER_PAGE) % N_BANKS;
		lpn = (first_page_first_lba / SECTORS_PER_PAGE) / N_BANKS;
		if(ppn == -1){ // EMPTY여부를 확인하는건데, 이거 문제있음. 처음 ppn을 캐싱하면 -1이 아니라 쓰레기값임
			FOR(i, nsect) current_read_buffer[i] = 0xFFFFFFFFF;
		}else{
			nand_read(bank, ppn/PAGES_PER_BLK, ppn%PAGES_PER_BLK, data, &spare);
			FOR(i, nsect) current_read_buffer[i] = data[first_lba_offset + i];
		}
	}
	else{
		int ppn, sector_kazu;
		FOR(page_offset, send_kazu){
			ppn = lpn2ppn(bank, lpn); sector_kazu = 0;
			lpn = (page_offset + (first_page_first_lba/SECTORS_PER_PAGE)) / N_BANKS;
			bank = (page_offset + (first_page_first_lba/SECTORS_PER_PAGE)) % N_BANKS;
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
					FOR(i, 8 - sector_kazu) current_read_buffer[last_lba_offset + 1 + i] = 0xFFFFFFFF;
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
	if(before_ppn != -1) isValid[bank][before_ppn]=0; // 덮어쓰기라면 기존 L2P invalid해줘야함. 근데 이거 OP블럭도 isValid 0때리는 문제발생할수있다는듯?
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
	int last_lba = first_lba+nsect; // 여기까지는 쓰면 안됨
	int last_lba_offset = (last_lba % SECTORS_PER_PAGE);
	int last_page_first_lba = last_lba-last_lba_offset;
	int send_kazu = 1 + ((last_page_first_lba - first_page_first_lba) / SECTORS_PER_PAGE);
	if(last_lba_offset == 0) send_kazu--;
	// lba0, nsect8 일 때 send_kazu must be 1

	int data[SECTORS_PER_PAGE]; int bank, lpn, ppn, spare;
	int sector_kazu = 0;
	if(send_kazu == 1){
		sector_kazu = nsect;
		lpn = (first_page_first_lba / SECTORS_PER_PAGE) / N_BANKS;
		bank = (first_page_first_lba / SECTORS_PER_PAGE) % N_BANKS;
		ppn = lpn2ppn(bank, lpn);
		if(ppn == -1){ // Empty
			FOR(i, first_lba_offset) data[i] = 0xFFFFFFFF;
			FOR(i, 8 - last_lba_offset) data[i + last_lba_offset] = 0xFFFFFFFF;
		}else{
			nand_read(bank, ppn/PAGES_PER_BLK, ppn%PAGES_PER_BLK, data, &spare);
		}
		FOR(i, sector_kazu) data[first_lba_offset + i] = current_write_buffer[i];
		write_through_lpn(bank, lpn, data); current_write_buffer += sector_kazu;
	}else{
		int page_offset;// 제거할 것
		FOR(page_offset, send_kazu){
			lpn = (first_page_first_lba / SECTORS_PER_PAGE) / N_BANKS;
			bank = (first_page_first_lba / SECTORS_PER_PAGE) % N_BANKS;
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
					FOR(i, 7 - last_lba_offset) data[last_lba_offset + 1 + i] = 0xFFFFFFFF;
				}else{
					nand_read(bank, ppn/PAGES_PER_BLK, ppn%PAGES_PER_BLK, data, &spare);
				}
				FOR(i, sector_kazu) data[i] = current_write_buffer[i]; current_write_buffer += sector_kazu;
			}else{
				FOR(i, SECTORS_PER_PAGE) data[i] = current_write_buffer[i]; current_write_buffer += sector_kazu;
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