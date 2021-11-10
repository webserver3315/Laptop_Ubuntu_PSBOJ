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
#include <assert.h>

#define N_SLOT_PB N_CACHED_MAP_PAGE_PB
#define CMT_NSECT N_MAP_ENTRIES_PER_PAGE
#define EMPTY 0
#define DATA 1
#define MAP 2

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
void evict_slot(int bank, int victim_slot){ // GC를 체크하며 해당 slot을 FLUSH함. victim_slot은 free_slot이 됨.
	assert(CMT_dirty[bank][victim_slot]==1);
	if(Next_Map_PPN[bank] == GC_Trigger_Map_PPN[bank]){ map_garbage_collection(bank); } // Trigger 건드림
	isValid[bank][GTD[bank][CMT_vpn[bank][victim_slot]]]=0; // 이전 ppn invalid 처리
	GTD[bank][CMT_vpn[bank][victim_slot]] = Next_Map_PPN[bank];
	nand_write(bank, Next_Map_PPN[bank]/PAGES_PER_BLK, Next_Map_PPN[bank]%PAGES_PER_BLK, CMT_Data[bank][victim_slot], &CMT_vpn[bank][victim_slot]);
	CMT_vpn[bank][victim_slot] = -1; CMT_age[bank][victim_slot] = 0; Next_Map_PPN[bank]++;
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
	return pblk;
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
	return pblk;
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

static void map_write(u32 bank, u32 vpn, u32 cache_slot)
{//WRITE TO NAND
	
}
static void map_read(u32 bank, u32 vpn, u32 cache_slot)
{//WRITE TO CMT
	int ppn = GTD[bank][vpn]; int blk = ppn/PAGES_PER_BLK; int empty_slot = -1;
	assert(ppn!=-1);//근데 GTD가 -1이면 어케 처리해야하지? => 새로 할당받아야지!
	FOR(slot, N_SLOT_PB){	if(CMT_vpn[bank][slot]==vpn) { return; } } // cache hit이면 그냥 리턴
	FOR(slot, N_SLOT_PB){ if(CMT_vpn[bank][slot]==-1){ empty_slot = slot; break; } }

	if(empty_slot != -1){ // 빈 슬롯 있으면, 걍 빈 슬롯에 쓰기

	}
	else{//Evict 하고, evicted page NAND에 보존하고 새로생긴 자리에 CMT 덮어쓰기. 이 때, Invalid는 cpy하지않음. 그리고 cpy하면 GTD도 새로 매핑 다시.
		int victim_slot = get_LRU_slot(bank);
		evict_slot()
		int tmp_data[PAGES_PER_BLK][SECTORS_PER_PAGE]; int tmp_spare[PAGES_PER_BLK];
		int blk = GTD
		FOR(pg, PAGES_PER_BLK){
			nand_read(bank,,pg,tmp_data[pg],&tmp_spare[pg])
		}
	}
}

static void map_garbage_collection(u32 bank){ // data gc 도중 map gc가 일어날 수 있음에 유의
	assert(Next_Map_PPN[bank]==GC_Trigger_Map_PPN[bank]);
	int victim_blk, free_blk, offset;
	int tmp_data[8]; int vpn;
	int copy_cnt = 0;
	victim_blk = greedy_map_blk(bank); free_blk = get_free_blk_map(bank);
	FOR(pg, PAGES_PER_BLK){ // Victim의 Valid한 Page 노아의 방주 탈출
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

int lpn2ppn(int bank, int lpn){
	int vpn = lpn2vpn(lpn);
	int offset = is_vpn_cached(bank, vpn);
	if(offset != -1){ return CMT_Data[bank][offset][lpn%CMT_NSECT]; } // Cache Hit
	// 이제, 해당 vpn이 cache에 없음을 전제.
	int ppn = GTD[bank][vpn];
	int tmp_data[8]; int tmp_spare;
	nand_read(bank, ppn/PAGES_PER_BLK, ppn%PAGES_PER_BLK, tmp_data, &tmp_spare);
	if(get_free_slot(bank) == -1){ my_map_write(bank, get_LRU_slot(bank)); } // FLUSH TO NAND, 여유공간 만들기
	int free_slot = get_free_slot(bank); assert(free_slot != -1); // 1번 더 다시 찾기
	memcpy(CMT_Data[bank][free_slot], tmp_data, SECTORS_PER_PAGE); // CMT 에 올리기
	CMT_vpn[bank][free_slot] = vpn; CMT_dirty[bank][free_slot] = 0; CMT_age[bank][free_slot] = 0;
	offset = is_vpn_cached(bank, vpn); assert(offset!=-1); // 이젠 반드시 CMT에 있어야 함
	return CMT_Data[bank][offset][lpn%CMT_NSECT];
}

static void garbage_collection(u32 bank)
{
	assert(Next_Data_PPN[bank]==GC_Trigger_Data_PPN[bank]);
	int victim_blk, free_blk;
	int copy_cnt = 0;
	int tmp_data[8]; int lpn, vpn;
	victim_blk = greedy_data_blk(bank); free_blk = get_free_blk_data(bank);
	FOR(pg, PAGES_PER_BLK){
		if(isValid[bank][victim_blk*PAGES_PER_BLK + pg] == 0) continue;
		nand_read(bank, victim_blk, pg, tmp_data, &lpn); // 아직 버퍼 미구현이므로 tmp_spare 볼 필요 없음. 
		isValid[bank][victim_blk*PAGES_PER_BLK + pg] = 0; // 읽거나 복사하지 마시오
		vpn = lpn2vpn(lpn);
		// 계속...
		// Data Page 위치가 바뀌니까, GTD와 CMT도 바꿔줘야 함
		/*
		1. 동일한 lpn에 매핑된 ppn이 victim_blk*PGPBLK+pg 에서 free_blk*PGPBLK+copy_cnt 로 이동함.
		2. 기존 매핑블럭 FLASH에 Invalid 처리를 함. 그 뒤, CMT를 수정해야 함. NAND에 반영은 FLUSH할때 되겠지.
		3. CMT의 공간이 꽉 차면, evict 해서라도 올려야 함.
		4. GDT도 바꿔야 함.
		*/


		nand_write(bank, free_blk, copy_cnt, tmp_data, &buffer_offset);
		copy_cnt++;
	}
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

void ftl_read(u32 lba, u32 nsect, u32 *read_buffer)
{	

}

void ftl_write(u32 lba, u32 nsect, u32 *write_buffer)
{
	stats.host_write += nsect;
}
/*
CMT_Age 건드려줘야함
CMT도 새거고 GDT도 새거인, 처음 쓸때는 어떻게 메커니즘이 작동하는거지?
CMT Dirty 등등도 일괄적으로 걍 때려버리기.
배열차원검사

GTD는 오로지 flush 될 때만 수정된다? 맞나?

*/