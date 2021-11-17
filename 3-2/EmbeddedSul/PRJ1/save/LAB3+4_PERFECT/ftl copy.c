/*
 * Lab #3 : Page Mapping FTL Simulator
 *  - Embedded Systems Design, ICE3028 (Fall, 2021)
 *
 * Sep. 30, 2021.
 *
 * TA: Youngjae Lee, Jeeyoon Jung
 * Prof: Dongkun Shin
 * Embedded Software Laboratory
 * Sungkyunkwan University
 * http://nyx.skku.ac.kr
 */

#include "ftl.h"
#include "assert.h"
#include "stdio.h"
#include <stdlib.h>
#include <string.h>

#define FOR(x,n) for(int x=0;x<(n);x++)

/*
일단 함수 선언 전부 떄려놨고, 원본은 딱 여기까지다.
이제, 이걸 "참고" 만 해서 새로 만들어야 될 모양이다.
일단 보존해놓자.
*/

/*
 * add stats.nand_read after all nand_read call
 * if you didn't use spare area when excuting GC,
 * your nand_read may less than pdf
 *
 * if you read old data when writing full page
 * your nand_read may larger than pdf
 */

int L2P [N_BANKS][N_LPNS_PB]; // lpn 이 쓰인다.
int isValid [N_BANKS][BLKS_PER_BANK * PAGES_PER_BLK]; // 실제 ppn이 쓰인다.
int next_ppn[N_BANKS]; 
int gc_trigger_ppn[N_BANKS]; // 해당 ppn 접근시 GC 발동
int free_pblk[N_BANKS]; // 현재 비어있는 pblk

int age[N_BANKS][BLKS_PER_BANK]; // ppn 들어감.
int erase_count[N_BANKS][BLKS_PER_BANK]; // ppn 들어감

int buffer_L2P [N_BANKS][N_LPNS_PB]; // lpn -> buffer 링크드 여부
int buffer_pblk[N_BUFFERS][SECTORS_PER_PAGE]; // 1섹터==int, 각 버퍼는 페이지크기.
int buffer_isValid[N_BUFFERS][SECTORS_PER_PAGE]; // halved_lpn이 아니라 ㄹㅇ lpn이 저장됨에 유의, isValid와 달리 1 0이 아니라 1 -1 임에 유의
// int buffer_next_ppn;

int frontend_buffer_page_calculate();
void age_update(int bank, int target_pblk);
double get_u(int bank, int pblk);
int get_victim_pblk_greedy(int bank);
int get_victim_pblk_cb(int bank);
int get_victim_pblk_cat(int bank);
int greedy_data_blk(int bank);
static void garbage_collection(u32 bank);
void ftl_open();
void ftl_read(u32 lba, u32 nsect, u32 *read_buffer); //read 에서 lba 를 lpn 을 안거치고 ppn으로 변환했다.
void write_through_lpn(int bank, u32 halved_lpn, int* data); // integer
void write_directly_nand(u32 lba, u32 nsect, u32 *write_buffer);
int needed_buffer_page_calculate(int lpn_start, int send_kazu);
int usable_buffer_page_calculate(); // 가용한 버퍼의 총 수를 buffer_L2P 선형탐색으로 반환
int frontend_buffer_page_calculate(); // 가용한 가장 낮은 넘버의 버퍼pg넘버 반환
void write_to_buffer(u32 lba, u32 nsect, u32 *write_buffer);
void ftl_write(u32 lba, u32 nsect, u32 *write_buffer);
void ftl_flush();
void ftl_trim(u32 lpn, u32 npage);

//0번 페이지가 써질 때 발동
void age_update(int bank, int target_pblk){ // make targetblk age to 1, the others ++
	assert(target_pblk>=BLKS_PER_BANK);
	for(int blk=0;blk<BLKS_PER_BANK;blk++){
		if( (age[bank][blk]==-1) || (age[bank][blk]==free_pblk[bank])) continue;
		else age[bank][blk]++;
	}
	age[bank][target_pblk]=1; // rewind target_pblk's age
	return;
}


double get_u(int bank, int pblk){
	double valid_pages=0;
	for(int offset=0;offset<PAGES_PER_BLK;offset++){
		if(isValid[bank][pblk*PAGES_PER_BLK+offset]!=0) valid_pages = valid_pages+1;
	}
	if(valid_pages==0) return 0;
	else return valid_pages/PAGES_PER_BLK;
}

int get_victim_pblk_greedy(int bank){
	int max_invalid_cnt=0;
	int victim_blk=-1; // -1 이 리턴되면 뭔가 문제가 있는거.
	int ret_pblk;
	for(int pblk=BLKS_PER_BANK-1;pblk>=0;pblk--){
		int pblk_invalid_cnt = 0;
		for(int i=0;i<PAGES_PER_BLK;i++){
			int cur_ppn = pblk*PAGES_PER_BLK + i;
			if(isValid[bank][cur_ppn] == 0){
				pblk_invalid_cnt++;
			}
		}
		if(pblk_invalid_cnt>=max_invalid_cnt){
			max_invalid_cnt = pblk_invalid_cnt;
			ret_pblk = pblk;
		}
	}
	// greedy: victim blk is ret_pblk
	assert(ret_pblk != free_pblk[bank]); // victim blk can't be free block
	return ret_pblk;
}
int get_victim_pblk_cb(int bank){
	return 0;
}
int get_victim_pblk_cat(int bank){
	return 0;
}

int greedy_data_blk(int bank){
	int victim_pblk;
	if(GC_POLICY == gc_greedy){
		victim_pblk = get_victim_pblk_greedy(bank); // 새로운 Spare Block 이 된다.
	}else if(GC_POLICY == gc_cb){ // COST BENEFIT
		victim_pblk = get_victim_pblk_cb(bank); // 새로운 Spare Block 이 된다.
	}else{// COST AGE TIMES policy
		victim_pblk = get_victim_pblk_cat(bank); // 새로운 Spare Block 이 된다.
	}
	return victim_pblk;
}

static void garbage_collection(u32 bank)
{
	stats.gc_cnt++;
/***************************************
Add

stats.gc_write++;

for every nand_write call (every valid page copy)
that you issue in this function
***************************************/
	// printf("GC Time!\n");

	int victim_pblk = greedy_data_blk(bank);
	
	int victim_first_ppn = victim_pblk*PAGES_PER_BLK;
	int free_first_ppn = free_pblk[bank]*PAGES_PER_BLK;

	int immigrants_cnt = 0;
	for(int i=0;i<PAGES_PER_BLK;i++){
		int victim_ppn = victim_first_ppn+i;
		if(isValid[bank][victim_ppn] == 1){ // 이민 시작
			int tmp_data[8];
			int tmp_lpn;
			nand_read(bank, victim_pblk, i, tmp_data, &tmp_lpn);
			if(immigrants_cnt==0){// 0번 페이지를 write 할 때만 발동.
				age_update(bank,free_pblk[bank]);
			}
			nand_write(bank, free_pblk[bank], immigrants_cnt, tmp_data, &tmp_lpn); stats.gc_write++;
			L2P[bank][tmp_lpn] = free_first_ppn+immigrants_cnt;
			immigrants_cnt++;
		}
	}
	for(int i=0;i<PAGES_PER_BLK;i++){
		isValid[bank][victim_first_ppn + i] = 1;
	}

	next_ppn[bank] = free_first_ppn + immigrants_cnt;
	gc_trigger_ppn[bank] = free_first_ppn + PAGES_PER_BLK;
	age[bank][victim_pblk] = -1;
	erase_count[bank][victim_pblk]++;
	int result = nand_erase(bank,victim_pblk);
	// printf("erase_result = %d\n",result);
	free_pblk[bank] = victim_pblk;
	return;
}

void ftl_open() {
	nand_init(N_BANKS, BLKS_PER_BANK, PAGES_PER_BLK);
	for(int bank=0; bank<N_BANKS; bank++){
		free_pblk[bank] = BLKS_PER_BANK-1; // 6th 블럭 == 0~세면 7번째. // 7th 블럭
		for(int lpn=0;lpn<N_LPNS_PB;lpn++){
			L2P[bank][lpn]=-1;
			buffer_L2P[bank][lpn]=-1;
		}
		for(int ppn=0;ppn<PAGES_PER_BLK*BLKS_PER_BANK;ppn++){
			isValid[bank][ppn]=1;
		}
		for(int blk=0;blk<BLKS_PER_BANK;blk++){
			age[bank][blk]=-1;
			erase_count[bank][blk]=0;
		}
		next_ppn[bank] = 0;
		gc_trigger_ppn[bank]=free_pblk[bank] * PAGES_PER_BLK;
	}
	for(int buff=0;buff<N_BUFFERS;buff++){
		for(int sect=0;sect<SECTORS_PER_PAGE;sect++){
			buffer_pblk[buff][sect]=0;
			buffer_isValid[buff][sect]=-1;
		}
	}
}

void ftl_read(u32 lba, u32 nsect, u32 *read_buffer) { //read 에서 lba 를 lpn 을 안거치고 ppn으로 변환했다.
	int* current_read_buffer = read_buffer;
	int first_lba=lba;
	int first_lba_offset = first_lba % SECTORS_PER_PAGE;
	int first_page_first_lba = first_lba - first_lba_offset;
	int last_lba = first_lba+nsect-1;
	int last_lba_offset = (last_lba % SECTORS_PER_PAGE);
	int last_page_first_lba = last_lba-last_lba_offset;

	int sector_transferred=0;
	
	int send_kazu = 1+((last_page_first_lba-first_page_first_lba) / SECTORS_PER_PAGE);

	// printf("first_lba = %d\n first_lba_offset = %d\n first_page_first_lba = %d\n",first_lba,first_lba_offset,first_page_first_lba);
	// printf("last_lba = %d\n last_lba_offset = %d\n last_page_first_lba = %d\n",last_lba,last_lba_offset,last_page_first_lba);
	// printf("send_kazu = %d\n",send_kazu);

	int bank, lpn, halved_lpn, spare;
	int data[8];
	if(send_kazu==1){
		lpn = first_page_first_lba/SECTORS_PER_PAGE;
		bank = lpn % N_BANKS;
		halved_lpn = lpn/N_BANKS;
		if(L2P[bank][halved_lpn]==-1){// Empty
			// printf("flag1\n");
			for(int i=0;i<nsect;i++){
				current_read_buffer[i]=0xFFFFFFFF;
			}
		}else{
			// printf("flag2\n");
			int ppn = L2P[bank][halved_lpn];
			nand_read(bank,ppn/PAGES_PER_BLK,ppn%PAGES_PER_BLK,data,&spare); sector_transferred+=8;
			for(int i=first_lba_offset;i<=last_lba_offset;i++){
				current_read_buffer[i-first_lba_offset]=data[i];
			}
		}
		if(buffer_L2P[bank][halved_lpn]!=-1){ // IF lpn Also Buffered, 변동사항 덮어쓴다.
			// printf("flag3\n");
			for(int i=0;i<nsect;i++){
				if(buffer_isValid[buffer_L2P[bank][halved_lpn]][i+first_lba_offset]!=-1){
					current_read_buffer[i]=buffer_pblk[buffer_L2P[bank][halved_lpn]][i+first_lba_offset];
				}
			}
		}
	}
	else{
		for(int pp=0;pp<send_kazu;pp++){ // 각각의 읽을 페이지에 대하여
			lpn = pp + first_page_first_lba/SECTORS_PER_PAGE;
			bank = lpn % N_BANKS;
			halved_lpn = lpn/N_BANKS;
			int sector_kazu = 0; // 해당 lpn으로부터 read_buffer 로 적어야 하는 sector 수: 1~8
			if(pp==0){ // 첫 페이지 -> empty면 모든 섹터를 0xff로 출력해야함
				sector_kazu = 8 - first_lba_offset;
				// printf("this: first_lba_offset = %d, sector_kazu = %d\n",first_lba_offset,sector_kazu);
				if(L2P[bank][halved_lpn]==-1){ // Empty
					for(int i=0;i<sector_kazu;i++){
						current_read_buffer[i]=0xFFFFFFFF;
					}
				}else{
					int ppn = L2P[bank][halved_lpn];
					nand_read(bank,ppn/PAGES_PER_BLK,ppn%PAGES_PER_BLK,data,&spare); sector_transferred+=8;
					for(int i=first_lba_offset;i<8;i++){
						current_read_buffer[i-first_lba_offset] = data[i];
					}
				}
				// buffer 덮어쓰기
				if(buffer_L2P[bank][halved_lpn]!=-1){ // IF lpn Also Buffered, 변동사항 덮어쓴다.
					for(int i=0;i<sector_kazu;i++){
						// printf("j=%d\n",i);
						// printf("buffer_L2P[bank][halved_lpn] = %d\n",buffer_L2P[bank][halved_lpn]);
						// printf("buffer_isValid[buffer_L2P[bank][halved_lpn]][i] = %d\n",buffer_isValid[buffer_L2P[bank][halved_lpn]][i]);
						if(buffer_isValid[buffer_L2P[bank][halved_lpn]][i+first_lba_offset]!=-1){ // 여기 2차원 i+firstlbaoffset과 아래는 통일시켜야만한다!!!!!!
							current_read_buffer[i]=buffer_pblk[buffer_L2P[bank][halved_lpn]][i+first_lba_offset];
							// printf("current_read_buffer[%d] := %2x\n",i,buffer_pblk[buffer_L2P[bank][halved_lpn]][i+first_lba_offset]);
						}
					}
				}
			}else if(pp==send_kazu-1){ // 마지막 페이지 -> empty면 모든 섹터를 0xff로 출력해야 함
				sector_kazu = last_lba_offset+1; // 1~8
				if(L2P[bank][halved_lpn]==-1){ // Empty
					for(int i=0;i<sector_kazu;i++){
						current_read_buffer[i]=0xFFFFFFFF;
					}
				}else{
					int ppn = L2P[bank][halved_lpn];
					nand_read(bank,ppn/PAGES_PER_BLK,ppn%PAGES_PER_BLK,data,&spare); sector_transferred+=8;
					for(int i=0;i<sector_kazu;i++){
						current_read_buffer[i] = data[i];
					}
				}

				// buffer 덮어쓰기
				if(buffer_L2P[bank][halved_lpn]!=-1){ // IF lpn Also Buffered, 변동사항 덮어쓴다.
					for(int i=0;i<sector_kazu;i++){
						if(buffer_isValid[buffer_L2P[bank][halved_lpn]][i]!=-1){
							current_read_buffer[i]=buffer_pblk[buffer_L2P[bank][halved_lpn]][i];
							// printf("current_read_buffer[%d] := %2x\n",i,buffer_pblk[buffer_L2P[bank][halved_lpn]][i]);
						}
					}
				}
			}else{ // 가운데 페이지 -> empty면 0~7까지 전부 0xff
				sector_kazu = 8;
				if(L2P[bank][halved_lpn] == -1){ // Empty
					for(int i=0;i<8;i++){
						current_read_buffer[i]=0xFFFFFFFF;
					}
				}else{
					int ppn = L2P[bank][halved_lpn];
					nand_read(bank,ppn/PAGES_PER_BLK,ppn%PAGES_PER_BLK,data,&spare); sector_transferred+=8;
					sector_transferred+=8;
					for(int i=0;i<8;i++){
						current_read_buffer[i] = data[i];
					}
				}
				
				// buffer 덮어쓰기
				if(buffer_L2P[bank][halved_lpn]!=-1){ // IF lpn Also Buffered, 변동사항 덮어쓴다.
					for(int i=0;i<SECTORS_PER_PAGE;i++){
						if(buffer_isValid[buffer_L2P[bank][halved_lpn]][i]!=-1){
							current_read_buffer[i]=buffer_pblk[buffer_L2P[bank][halved_lpn]][i];
							// printf("current_read_buffer[%d] := %2x\n",i,buffer_pblk[buffer_L2P[bank][halved_lpn]][i]);
						}
					}
				}
			}
			current_read_buffer+=sector_kazu;
		}
	}
}



void write_through_lpn(int bank, u32 halved_lpn, int* data){ // integer
	if(next_ppn[bank]==gc_trigger_ppn[bank]){ // GC 발동
		garbage_collection(bank);
	}
	int ppn = next_ppn[bank];
	if(L2P[bank][halved_lpn]!=-1){
		isValid[bank][L2P[bank][halved_lpn]]=0;
	}
	L2P[bank][halved_lpn]=next_ppn[bank];
	if(next_ppn[bank]%PAGES_PER_BLK==0){
		age_update(bank,next_ppn[bank]/PAGES_PER_BLK);
	}
	int result = nand_write(bank, ppn/PAGES_PER_BLK, ppn%PAGES_PER_BLK, data, &halved_lpn); stats.nand_write++; // memcpy 32Byte && 4Byte
	next_ppn[bank]++;
}

void write_directly_nand(u32 lba, u32 nsect, u32 *write_buffer){
	int* current_write_buffer = write_buffer;
	
	int first_lba=lba;
	int first_lba_offset = first_lba % SECTORS_PER_PAGE;
	int first_page_first_lba = first_lba - first_lba_offset;

	int last_lba = first_lba+nsect-1;
	int last_lba_offset = (last_lba % SECTORS_PER_PAGE);
	int last_page_first_lba = last_lba-last_lba_offset;

	int send_kazu = 1 + ((last_page_first_lba-first_page_first_lba) / SECTORS_PER_PAGE);

	int bank, lpn, ppn, halved_lpn, spare;
	int data[8];
	if(send_kazu == 1){ // 한 페이지도 채 안되는 포장
		// 대가리도 0xff가, 끄트머리도 0xff가 될 가능성이 있음
		// printf("flag1\n");
		int sector_transferred = 0;
		lpn = first_page_first_lba/SECTORS_PER_PAGE;
		bank = lpn % N_BANKS;

		halved_lpn = lpn / N_BANKS; 
		if(L2P[bank][halved_lpn] == -1){ // Empty
			for(int i=0;i<first_lba_offset;i++){
				data[i]=0xffffffff;
			}
			for(int i=last_lba_offset+1;i<8;i++){
				data[i]=0xffffffff;
			}
		}else{
			ppn = L2P[bank][halved_lpn];
			nand_read(bank,ppn/PAGES_PER_BLK,ppn%PAGES_PER_BLK,data,&spare);
		}
		for(int i=0;i<last_lba_offset-first_lba_offset+1;i++){
			data[first_lba_offset+i]=current_write_buffer[i]; sector_transferred++;
		}// 한페이지 포장완료
		write_through_lpn(bank, halved_lpn, data);//포장한놈 배송
		current_write_buffer+=sector_transferred;
	}
	else{ // 여러 페이지 포장
		for(int pp=0; pp<send_kazu; pp++){ // 한 페이지 포장
			int sector_transferred = 0;
			lpn = pp + first_page_first_lba/SECTORS_PER_PAGE;
			bank = lpn % N_BANKS;
			halved_lpn = lpn / N_BANKS; 
			// 만약 한 블록도 채 안되는 용량이라면?
			if(pp==0){ // 32B씩 포장하되, 대가리가 0xff 될 가능성 있음
				if(L2P[bank][halved_lpn] == -1){ // Empty
					for(int i=0;i<first_lba_offset;i++){
						data[i]=0xffffffff;
					}
				}else{ // Not Empty, 즉 기존 데이터 보존
					ppn = L2P[bank][halved_lpn];
					nand_read(bank,ppn/PAGES_PER_BLK,ppn%PAGES_PER_BLK,data,&spare);
				}
				for(int i=0;i<8-first_lba_offset;i++){
					data[first_lba_offset+i]=current_write_buffer[i]; sector_transferred++;
				}
			}
			else if(pp==send_kazu-1){ // 32B씩 포장하되, 끄트머리가 0xff 될 가능성 있음
				if(L2P[bank][halved_lpn] == -1){ // Empty
					for(int i=last_lba_offset+1;i<8;i++){
						data[i]=0xffffffff;
					}
				}else{ // Not Empty, 즉 기존 데이터 보존
					ppn = L2P[bank][halved_lpn];
					nand_read(bank,ppn/PAGES_PER_BLK,ppn%PAGES_PER_BLK,data,&spare);
				}
				for(int i=0;i<=last_lba_offset;i++){
					data[i]=current_write_buffer[i]; sector_transferred++;
				}
			}
			else{ // 아다리 맞춰서 32B씩 무지성으로 포장하면 됨. 생존데이터 없음.
				for(int i=0;i<8;i++){
					data[i] = current_write_buffer[i]; sector_transferred++;
				}
			}// data 포장 완료
			write_through_lpn(bank, halved_lpn, data);//포장한놈 배송
			current_write_buffer+=sector_transferred;//해당 페이지에 실제로 들어간 섹터 수만큼 전진
		}
	}
	return;
}

int needed_buffer_page_calculate(int lpn_start, int send_kazu){
	int ret=0;
	for(int lpn = lpn_start; lpn<lpn_start+send_kazu; lpn++){
		int bank = lpn%N_BANKS;
		int halved_lpn = lpn/N_BANKS;
		if(buffer_L2P[bank][halved_lpn]==-1) ret++;
	}
	return ret;
}

int usable_buffer_page_calculate(){ // 가용한 버퍼의 총 수를 buffer_L2P 선형탐색으로 반환
	int ret=0;
	for(int i=0;i<N_BUFFERS;i++){
		int s;
		for(s=0;s<SECTORS_PER_PAGE;s++){
			if(buffer_isValid[i][s]!=-1) break;
		}
		if(s==SECTORS_PER_PAGE){
			ret++;
		}
	}
	// printf("usable_buffer_page_calculate: return %d\n",ret);
	return ret;
}

int frontend_buffer_page_calculate(){ // 가용한 가장 낮은 넘버의 버퍼pg넘버 반환
	int frontend = __INT32_MAX__; // valid한 buffer page 중 가장 낮은 번호
	for(int i=0;i<N_BUFFERS;i++){
		int s;
		for(s=0;s<SECTORS_PER_PAGE;s++){
			if(buffer_isValid[i][s]!=-1) break;
		}
		if(s==SECTORS_PER_PAGE){
			if(frontend>i) frontend = i;
		}
	}
	if(frontend != __INT32_MAX__){
		// printf("frontend_buffer_page_calculate: return %d\n",frontend);
	}else{
		// printf("return - ERROR: frontend_buffer_page_calculate: no available buffer\n");
	}
	return frontend;
}

void write_to_buffer(u32 lba, u32 nsect, u32 *write_buffer){
	int* current_write_buffer = write_buffer;
	int first_lba=lba;
	int first_lba_offset = first_lba % SECTORS_PER_PAGE;
	int first_page_first_lba = first_lba - first_lba_offset;
	int last_lba = first_lba+nsect-1;
	int last_lba_offset = (last_lba % SECTORS_PER_PAGE);
	int last_page_first_lba = last_lba-last_lba_offset;
	int send_kazu = 1 + ((last_page_first_lba-first_page_first_lba) / SECTORS_PER_PAGE);

	// printf("first_lba = %d\n first_lba_offset = %d\n first_page_first_lba = %d\n",first_lba,first_lba_offset,first_page_first_lba);
	// printf("last_lba = %d\n last_lba_offset = %d\n last_page_first_lba = %d\n",last_lba,last_lba_offset,last_page_first_lba);
	// printf("send_kazu = %d\n",send_kazu);

	// 이미 버퍼에 있는 lpn은 새버퍼 받을 필요 없음, 뱅크별로 다름.

	// read할때 buffer에 해당데이터 있으면 머지에서 출력해야할텐데, 이거 머지할떄 buffer에서 사라지나?
	// nand로 directly 하게 바로 쓰였다면, buffer에 있는 해당 lpn은 아예 invalid시켜야함
	// flush 필요여부 체크
	int buffer_page_needed = needed_buffer_page_calculate(first_page_first_lba/SECTORS_PER_PAGE,send_kazu);
	// int buffer_page_remaining = N_BUFFERS - buffer_next_ppn;
	int buffer_page_remaining = usable_buffer_page_calculate();
	// printf("buffer_page_needed: %d VS buffer_page_remaining: %d\n",buffer_page_needed,buffer_page_remaining);
	if(buffer_page_needed > buffer_page_remaining){
		ftl_flush(); // buffer_next_ppn := 0(rewind)
	}
	
	for(int lpn = first_page_first_lba/SECTORS_PER_PAGE; lpn<=last_page_first_lba/SECTORS_PER_PAGE; lpn++){
		// printf("Here 1\n"); // not empty buf_l2p일 때를 유심히 보라
		int bank = lpn%N_BANKS;
		int halved_lpn = lpn/N_BANKS;
		int buffer_next_ppn = frontend_buffer_page_calculate();
		if(buffer_L2P[bank][halved_lpn] == -1){ // not buffered yet, 새로 할당받음
			if(buffer_next_ppn==__INT32_MAX__){
				// printf("ERROR CAPTURED\n");
				return;
			}
			buffer_L2P[bank][halved_lpn] = buffer_next_ppn;
			// printf("buffer_next_ppn := %d\n",buffer_next_ppn);
		}
		// isValid 채워넣기
		if(send_kazu == 1){ // 단 하나의 페이지
			int sect;
			// printf("Here 6\n"); // not empty buf_l2p일 때를 유심히 보라
			for(sect=first_lba_offset; sect<=last_lba_offset; sect++){ // 선별 덮어쓰기
				buffer_isValid[buffer_L2P[bank][halved_lpn]][sect]=lpn;
				buffer_pblk[buffer_L2P[bank][halved_lpn]][sect]=current_write_buffer[0];
				// printf("buffer_pblk[%d][%d] := %2x\n",buffer_L2P[bank][halved_lpn],sect,current_write_buffer[0]);
				current_write_buffer++;
			}
		}
		else if(lpn != first_page_first_lba/SECTORS_PER_PAGE && lpn!=last_page_first_lba/SECTORS_PER_PAGE){ // 복수개 페이지이고, 처음과 끝 페이지가 아닐 때
			// printf("Here 2\n");
			for(int sect=0; sect<SECTORS_PER_PAGE; sect++){
				buffer_isValid[buffer_L2P[bank][halved_lpn]][sect]=lpn;
				buffer_pblk[buffer_L2P[bank][halved_lpn]][sect]=current_write_buffer[0];
				// printf("buffer_pblk[%d][%d] := %2x\n",buffer_L2P[bank][halved_lpn],sect,current_write_buffer[0]);
				current_write_buffer++;
			}
		}
		else{// 처음 또는 끝 lpn
			// printf("Here 3\n");
			int sect;
			if(lpn == first_page_first_lba/SECTORS_PER_PAGE){ // 안건드는 섹터 있을가능성
				// printf("Here 4\n");
				for(sect=first_lba_offset; sect<SECTORS_PER_PAGE; sect++){ // 선별 덮어쓰기
					buffer_isValid[buffer_L2P[bank][halved_lpn]][sect]=lpn;
					buffer_pblk[buffer_L2P[bank][halved_lpn]][sect]=current_write_buffer[0];
					// printf("buffer_pblk[%d][%d] := %2x\n",buffer_L2P[bank][halved_lpn],sect,current_write_buffer[0]);
					current_write_buffer++;
				}
			}
			else if(lpn==last_page_first_lba/SECTORS_PER_PAGE){ // 안건드는 섹터 있을가능성
				// printf("Here 5\n");
				for(sect=0;sect<=last_lba_offset;sect++){
					buffer_isValid[buffer_L2P[bank][halved_lpn]][sect]=lpn;
					buffer_pblk[buffer_L2P[bank][halved_lpn]][sect]=current_write_buffer[0];
					// printf("buffer_pblk[%d][%d] := %2x\n",buffer_L2P[bank][halved_lpn],sect,current_write_buffer[0]);
					current_write_buffer++;
				}
			}
		}
	}
}

void ftl_write(u32 lba, u32 nsect, u32 *write_buffer)
{ // lba 랑 nsect로 BANK, LPN 을 결정하고  0xFF 채움 여부 결정한 뒤 write_through_lpn 으로 넘겨야 한다.
/***************************************
Add

stats.nand_write++;

for every nand_write call (every valid page copy)
that you issue in this function
***************************************/
	if(nsect>BUFFER_SIZE){ // 애초에 총 버퍼보다 클 경우
		write_directly_nand(lba,nsect,write_buffer);
	}
	else{
		write_to_buffer(lba,nsect,write_buffer);
	}
	stats.host_write += nsect;
}

void ftl_flush(){
	// printf("Flush Time!\n");
	for(int buffer_ppn=0;buffer_ppn<N_BUFFERS;buffer_ppn++){
		int buff[8]; // tmp
		int lpn=-1;
		for(int sect=0;sect<SECTORS_PER_PAGE;sect++){
			if(buffer_isValid[buffer_ppn][sect]!=-1){
				lpn = buffer_isValid[buffer_ppn][sect];
				break;
			}
		}
		if(lpn==-1) {
			// printf("return - ERROR: ftl_flush target lpn can't be -1\n");
			continue;
		}

		if(L2P[lpn%N_BANKS][lpn/N_BANKS]!=-1){ // NOT EMPTY => 보존
			ftl_read(lpn*SECTORS_PER_PAGE, SECTORS_PER_PAGE, buff);
			for(int sect=0;sect<SECTORS_PER_PAGE;sect++){
				if(buffer_isValid[buffer_ppn][sect]!=-1){ // buffer에 업데이트된 섹션일 경우
					buff[sect]=buffer_pblk[buffer_ppn][sect]; // 덮어쓰기
				}
				buffer_isValid[buffer_ppn][sect]=-1; // 해당섹션 invalid화
			}
		}
		else{ // empty => 새 ppn 할당부터 받아야 함
			// 기존처럼 gc 체크..? 아 아니다. gc필요여부 체크는 write_through_lpn에서 할거다.
			for(int sect=0;sect<SECTORS_PER_PAGE;sect++){
				if(buffer_isValid[buffer_ppn][sect]!=-1){ // buffer에 업데이트된 섹션일 경우
					buff[sect]=buffer_pblk[buffer_ppn][sect]; // 덮어쓰기
				}else{
					buff[sect]=0xFFFFFFFF; // 애초에 empty였으므로 0xFF채워넣기
				}
				buffer_isValid[buffer_ppn][sect]=-1; // 해당섹션 invalid화
			}
		}
		write_through_lpn(lpn%N_BANKS,lpn/N_BANKS,buff);
		buffer_L2P[lpn%N_BANKS][lpn/N_BANKS] = -1; // L2P mapping도 해제
	}
}

void ftl_trim(u32 lpn, u32 npage) {
	/*
	lpn부터 npage만큼의 페이지를 버퍼에서도 없애고 nand와의 연결도 끊는다.
	*/	
	// printf("Trim Time!\n");
	for(int ll=lpn;ll<lpn+npage;ll++){
		int halved_lpn = ll/N_BANKS;
		int bank = ll%N_BANKS;
		isValid[bank][L2P[bank][halved_lpn]]=0;
		if(buffer_L2P[bank][L2P[bank][halved_lpn]]!=-1){ // buffer도 연결되어있을경우
			for(int i=0;i<SECTORS_PER_PAGE;i++){
				buffer_isValid[buffer_L2P[bank][L2P[bank][halved_lpn]]][i]=-1;
			}
		} // 중간에 빵꾸난 buffer 이거 어떻게 처리하지... 여유 1개가 가운데에 뻥뚫려버리는데 -> 동적 가용버퍼획득으로 해결
		buffer_L2P[bank][L2P[bank][halved_lpn]]=-1;
		L2P[bank][halved_lpn]=-1;
	}
}

/*
만약 오류가 난다면....

배열 차원검사.
isValid 2번째 오프셋으로 ppn말고 lpn 넣지는 않았는지

*/