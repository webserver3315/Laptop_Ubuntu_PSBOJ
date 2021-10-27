/*
 * Lab #2 : Page Mapping FTL Simulator
 *  - Embedded Systems Design, ICE3028 (Fall, 2021)
 *
 * Sep. 23, 2021.
 *
 * TA: Youngjae Lee, Jeeyoon Jung
 * Prof: Dongkun Shin
 * Embedded Software Laboratory
 * Sungkyunkwan University
 * http://nyx.skku.ac.kr
 */

#include "ftl.h"

// L2P
// Page table 은 뱅크마다 UserBlock_PB * Page 수

int page_map_table [N_BANKS][N_USER_BLOCKS_PB * PAGES_PER_BLK];
int isValid [N_BANKS][BLKS_PER_BANK * PAGES_PER_BLK];
int next_ppn[N_BANKS]; // 뱅크별로 관리하는 다음 적힐 ppn: 선형증가하며 오로지 gc일때만 다시 되감긴다
int gc_ppn[N_BANKS]; // 해당 ppn 접근시 GC 발동
int integer_arr[BLKS_PER_BANK*PAGES_PER_BLK]//PPN 각인용

int which_block_gc(int bank){
	int max_invalid_cnt=0;
	int victim_blk=-1;
	for(int ppn=BLKS_PER_BANK-1;ppn>=0;ppn--){
		int pblk = ppn/PAGES_PER_BLK;
		int this_invalid_cnt=0;
		for(int p=0;p<PAGES_PER_BLK;p++){
			if(isValid[bank][pblk][p] == 0){
				this_invalid_cnt++;
			}
		}
		if(this_invalid_cnt>=max_invalid_cnt){
			victim_blk=pblk;
		}
	}
	return victim_blk;
}

static void garbage_collection(u32 bank) { // 선착순
	stats.gc_cnt++;
/***************************************
Add

stats.gc_write++;

for every nand_write call (every valid page copy)
that you issue in this function
***************************************/
	int tmp_blk[PAGES_PER_BLK][8];

	int victim_blk = which_block_gc(bank);
	int victim_first_ppn = victim_blk*PAGES_PER_BLK;

	/*
	1. victim 블록 선정
	2. for(i) 로 data, lpn 복사
	3. 새로 이사간 ppn으로 pmt 수정
	4. next_ppn 수정
	5. 새로 이사간 블록의 Valid 모두 1로
	*/
	int valid_cnt=0;
	for(int i=0;i<PAGES_PER_BLK;i++){
		if(isValid[bank][victim_first_ppn+i]){
			
			valid_cnt++;
		}
	}

	for(int i=0;i<PAGES_PER_BLK;i++){
		if(isValid[bank][victim_first_ppn + i] == 0) 
			continue;
		int data[8];
		int spare;
		nand_read(bank, victim_blk, i, data, &spare);
		stats.gc_write++;
		nand_write(bank,)
	}

	return;
}

void ftl_open() {
	nand_init(N_BANKS, BLKS_PER_BANK, PAGES_PER_BLK);
	for(int bank_idx=0; bank_idx<N_BANKS; bank_idx++){
		for(int lpn=0;lpn<N_USER_BLOCKS_PB*PAGES_PER_BLK;lpn++){
			page_map_table[bank_idx][lpn] = -1; // initialize PAGE MAP
		}
	}
	for(int i=0;i<N_BANKS;i++){
		for(int j=0;j<BLKS_PER_BANK;j++){
			for(int k=0;k<PAGES_PER_BLK;k++){
				isValid[i][j][k]=1;
			}
		}
		next_ppn[i]=0;
		gc_ppn[i]=(BLKS_PER_BANK-1)*PAGES_PER_BLK; // OP 블록 첫 페이지 ppn
	}
	for(int i=0;i<BLKS_PER_BANK*PAGES_PER_BLK;i++){
		integer_arr[i]=i;//PPN 각인용
	}
	// LPN 전부 등록? ㄴㄴ write할때.
}

// bank마다 table 관리.
// 따라서 bank 마다 어디에 써줘야할지 페이지를 관리함. 블록내 페이지는 선형적 쓰기.
// 최악의 경우, 4B 단위로 읽을 수 있어야 한다.
void ftl_read(u32 lba, u32 nsect, u32 *read_buffer) { // STRIPING
	int lpn, offset, ppn;
	int spare;
	// lbn -> lpn -> ppn
	// lba = 4B => 호스트가 쓰려고 시도하는 최소단위 == int
	// lpn = 4B*8 => 실제 쓸 수 있는 최소단위
	for(int real_lba=lba;real_lba<lba+nsect;real_lba+=8){ // lba += 8
		offset = real_lba % SECTORS_PER_PAGE;
		// LBA -> LPN
		lpn = real_lba / SECTORS_PER_PAGE; // LPN == total_lba / 8
		// 이제 lba 는 가치가 없음, OFFSET 과 LPN 을 구했기 때문.
		int pbank = lpn % N_BANKS;
		// LPN -> PPN
		ppn = page_map_table[pbank][lpn]; // 만약 페이지맵의 값이 0xFF 인 경우는 가정하지 않는건가?
		// 기타값
		int pblk = ppn / PAGES_PER_BLK;
		int pageno = ppn % PAGES_PER_BLK;
		
		if(!isValid[pbank][pblk][pageno]){
			*read_buffer = 0xFFFFFF;
			return;
		}
		int rx[8];
		nand_read(pbank, pblk, pageno, rx, &spare); // 한번에 4*8바이트
		for(int i=offset;i<8;i++){  // 4바이트 최대 8번 복사하기
			read_buffer[i-offset] = rx[i];
		}
		read_buffer+=8; // += 32Byte
	}
}

void update_next_ppn(int bank){
	int current_next_ppn = next_ppn[bank];
	for(int ppn = current_next_ppn; ppn<PAGES_PER_BLK; ppn++){
		if(isValid[bank][ppn]){
			next_ppn[bank]=ppn;
			return;
		}
		if(ppn==PAGES_PER_BLK-1)
			ppn=0;
		//무한루프돌수도있음
	}
}

void write_through_lpn(int bank, u32 lpn, int* data){ // integer
	if(next_ppn[bank]==gc_ppn[bank]){
		garbage_collection(bank); // Free a Block, update next_ppn, gc_ppn
	}
	int ppn = next_ppn[bank];
	if(page_map_table[bank][lpn]!=-1){ // 덮어쓰기라면
		isValid[bank][page_map_table[bank][lpn]]=0;
	}
	page_map_table[bank][lpn]=next_ppn[bank];
	nand_write(bank, ppn/PAGES_PER_BLK, ppn%PAGES_PER_BLK, data, &lpn);
	next_ppn[bank]++;
}

void ftl_write(u32 lba, u32 nsect, u32 *write_buffer) { // STRIPING
// WRITE_BUFFER 에 들어있는 값을 LBA에 NSECT 만큼 쓴다.
/***************************************
Add
stats.nand_write++;
for every nand_write call (every valid page copy)
that you issue in this function
***************************************/

	int lpn, offset, ppn;
	int spare;
	// 4B씩 쓸 수 있어야 한다.
	for(int real_lba=lba; real_lba<=lba+nsect; real_lba+=8){
		offset = real_lba % SECTORS_PER_PAGE;
		lpn = real_lba / SECTORS_PER_PAGE;
		int pbank = lpn % N_BANKS;
		ppn = page_map_table[pbank][lpn];

		/*
		1. GC 필요여부 체크
		2. empty page 인지 체크
		3. 
		*/
		if(ppn==gc_ppn[pbank]){ // 만약 gc 트리거이면
			garbage_collection(pbank);
		}
		if(ppn==-1){//새거
			
		}else{ // 기존의 값 -> 저장 필요
			int pblk = ppn / PAGES_PER_BLK;
			int pageno = ppn % PAGES_PER_BLK;	// 실제 최소 쓰기단위는 32B이다.
			int tx[8];
			ftl_read(real_lba, );
			nand_write(pbank, pblk, pageno, , SPARE);
		}
	}


	stats.host_write += nsect;
	return;
}
