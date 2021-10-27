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

/* DFTL simulator
 * you must make CMT, GTD to use L2P cache
 * you must increase stats.cache_hit value when L2P is in CMT
 * when you can not find L2P in CMT, you must flush cache 
 * and load target L2P in NAND through GTD and increase stats.cache_miss value
 */



int L2P [N_BANKS][N_LPNS_PB]; // lpn 이 쓰인다.
int isValid [N_BANKS][BLKS_PER_BANK * PAGES_PER_BLK]; // 실제 ppn이 쓰인다.
int next_ppn[N_BANKS]; 
int gc_trigger_ppn[N_BANKS]; // 해당 ppn 접근시 GC 발동
int free_pblk[N_BANKS]; // 현재 비어있는 pblk


void print_constant(){
	printf("N_BANKS = %d\n",N_BANKS);
	printf("BLKS_PER_BANK = %d\n",BLKS_PER_BANK);
	printf("PAGES_PER_BLK = %d\n",PAGES_PER_BLK);
	printf("SECTOR_SIZE = %d\n",SECTOR_SIZE);
	printf("SECTORS_PER_PAGE = %d\n",SECTORS_PER_PAGE);
	// printf("N_GC_BLOCKS = %d\n",N_GC_BLOCKS);

	printf("N_PPNS_PB = %d\n",N_PPNS_PB);
	printf("N_USER_BLOCKS_PB = %d\n",N_USER_BLOCKS_PB);
	printf("N_OP_BLOCKS_PB = %d\n",N_OP_BLOCKS_PB);
	printf("N_LPNS_PB = %d\n",N_LPNS_PB);
	printf("N_PPNS = %d\n",N_PPNS);
	printf("N_BLOCKS = %d\n",N_BLOCKS);
	printf("N_USER_BLOCKS = %d\n",N_USER_BLOCKS);
	printf("N_OP_BLOCKS = %d\n",N_OP_BLOCKS);
	printf("N_LPNS = %d\n",N_LPNS);
	printf("L2p[%d][%d]\n",N_BANKS,N_LPNS_PB);
	printf("isValid[%d][%d]\n",N_BANKS,BLKS_PER_BANK * PAGES_PER_BLK);
	printf("next_ppn[%d]\n",N_BANKS);
	printf("gc_trigger_ppn[%d]\n",N_BANKS);
	printf("free_pblk[%d]\n",N_BANKS);

	printf("\n");
	printf("N_MAP_ENTRIES_PER_PAGE = %d\n",N_MAP_ENTRIES_PER_PAGE);
	printf("N_MAP_PAGES_PB = GTD size = %d\n",N_MAP_PAGES_PB);
	printf("N_CACHED_MAP_PAGE_PB = CMT size = %d\n",N_CACHED_MAP_PAGE_PB);
	printf("BLKS_PER_BANK = %d\n",BLKS_PER_BANK);
	printf("N_MAP_BLOCKS_PB = %d\n",N_MAP_BLOCKS_PB);
	printf("N_USER_BLOCKS_PB = %d\n",N_USER_BLOCKS_PB);
	printf("N_OP_BLOCKS_PB = %d\n",N_OP_BLOCKS_PB);
	// printf("N_MAP_BLOCKS = %d\n",N_MAP_BLOCKS)
	// printf("N_USER_BLOCKS = %d\n",N_USER_BLOCKS)

	printf("\n\n\n");
}


// extern struct Page {
// 	u32 data[8]; //32byte
// 	u32 spare; //4byte
// };
// extern struct Page* nand;
// extern char* iswritten; 
// extern int* blk_index;
// extern int NBANKS, NBLKS, NPAGES;
// extern void print_page();

// void show_whole_nand(){
// 	// printf("SHOW_WHOLE_NAND\n");
// 	for(int bb=0;bb<NBANKS;bb++) // printf("<Bank%d>\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t",bb);
// 	// printf("\n");
// 	for(int bb=0;bb<NBANKS;bb++) // printf("next_ppn[%d] = %d\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t",bb,next_ppn[bb]);
// 	// printf("\n");
// 	for(int bb=0;bb<NBANKS;bb++) // printf("gc_trigger_ppn[%d] = %d\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t",bb,gc_trigger_ppn[bb]);
// 	// printf("\n");
// 	for(int bb=0;bb<NBANKS;bb++) // printf("free_pblk[%d] = %d\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t",bb,free_pblk[bb]);
// 	// printf("\n");

// 	for(int halved_ppn=0; halved_ppn<NBLKS*NPAGES;halved_ppn++){
// 		for(int bb=0;bb<N_BANKS;bb++){

// 			int ppn = bb*NBLKS*NPAGES + halved_ppn;
// 			if(halved_ppn<N_LPNS_PB) // printf("L2P[%d][%d] == %d \t\t",bb, halved_ppn, L2P[bb][halved_ppn]);
// 			else // printf("\t\t\t\t");
// 			// printf("ppn[%d].data[0:7] == [ %d | ",ppn, nand[ppn].spare);
// 			for (int i = 0; i < 7; i++) {
// 				// printf("%x, ", nand[ppn].data[i]);
// 			}
// 			// printf("%x | %d] \t\t", nand[ppn].data[7], isValid[bb][halved_ppn]);
// 		}
// 		// printf("\n");
// 	}
// }

// void show_nand(){
// 	// printf("LPN\tTO\t\tDATA\tLPN\tPPN\tVALID\n");
// 	for(int bb=0;bb<BLKS_PER_BANK;bb++){
// 		for(int pp=0;pp<PAGES_PER_BLK;pp++){
// 			if(bb<N_USER_BLOCKS){
// 				// printf("%d\t%d\t\t\t%c\t%d\t%d\t%d\n",bb*PAGES_PER_BLK+pp,L2P[0][bb*PAGES_PER_BLK+pp],nand[bb*PAGES_PER_BLK+pp].data[0]+'a'-1, nand[bb*PAGES_PER_BLK+pp].spare, bb*PAGES_PER_BLK+pp, isValid[0][bb*PAGES_PER_BLK+pp]);
// 			}
// 			else{
// 				// printf("\t\t\t\t%c\t%d\t%d\t%d\n",nand[bb*PAGES_PER_BLK+pp].data[0]+'a'-1, nand[bb*PAGES_PER_BLK+pp].spare, bb*PAGES_PER_BLK+pp, isValid[0][bb*PAGES_PER_BLK+pp]);
// 			}
// 		}
// 	}
// }


int get_victim_pblk(int bank){
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
	// // printf("victim block is %d\n",ret_pblk);
	return ret_pblk;
}

static void map_write(u32 bank, u32 map_page, u32 cache_slot)
{
	/* you use this function when you must flush
	 * cache from CMT to NAND MAP area
	 * flush cache with LRU policy and fix GTD!!
	 */

}
static void map_read(u32 bank, u32 map_page, u32 cache_slot)
{
	/* you use this function when you must load 
	 * L2P from NAND MAP area to CMT
	 * find L2P MAP with GTD and fill CMT!!
	 */
}

static void map_garbage_collection(u32 bank)
{
	/*stats.map_gc_cnt++ every map_garbage_collection call*/
	/*stats.map_gc_write++ every nand_write call*/

}
static void garbage_collection(u32 bank)
{
	/* stats.gc_cnt++ every garbage_collection call*/
	stats.gc_cnt++;
	/* stats.gc_write++ every nand_write call*/
	int victim_pblk = get_victim_pblk(bank); // 새로운 Spare Block 이 된다.
	int victim_first_ppn = victim_pblk*PAGES_PER_BLK;
	int free_first_ppn = free_pblk[bank]*PAGES_PER_BLK;
	int immigrants_cnt = 0;
	for(int i=0;i<PAGES_PER_BLK;i++){
		int victim_ppn = victim_first_ppn+i;
		if(isValid[bank][victim_ppn] == 1){ // 이민 시작
			int tmp_data[8];
			int tmp_lpn;
			nand_read(bank, victim_pblk, i, tmp_data, &tmp_lpn);
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
	int result = nand_erase(bank,victim_pblk);
	// printf("erase_result = %d\n",result);
	free_pblk[bank] = victim_pblk;
	return;
}
void ftl_open() {
	print_constant();
	nand_init(N_BANKS, BLKS_PER_BANK, PAGES_PER_BLK);
	for(int bank=0; bank<N_BANKS; bank++){
		free_pblk[bank] = BLKS_PER_BANK-1; // 6th 블럭 == 0~세면 7번째. // 7th 블럭
		for(int lpn=0;lpn<N_LPNS_PB;lpn++){
			L2P[bank][lpn]=-1;
		}
		for(int ppn=0;ppn<PAGES_PER_BLK*BLKS_PER_BANK;ppn++){
			isValid[bank][ppn]=1;
		}
		next_ppn[bank] = 0;
		gc_trigger_ppn[bank]=free_pblk[bank] * PAGES_PER_BLK;
	}
}

void ftl_read(u32 lba, u32 nsect, u32 *read_buffer){	
	int* current_read_buffer = read_buffer;	
	int first_lba=lba;
	int first_lba_offset = first_lba % SECTORS_PER_PAGE;
	int first_page_first_lba = first_lba - first_lba_offset;
	int last_lba = first_lba+nsect-1;
	int last_lba_offset = (last_lba % SECTORS_PER_PAGE);
	int last_page_first_lba = last_lba-last_lba_offset;

	int sector_transferred=0;
	
	int send_kazu = 1+((last_page_first_lba-first_page_first_lba) / SECTORS_PER_PAGE);

	int bank, lpn, halved_lpn, spare;
	int data[8];
	if(send_kazu==0){
		lpn = first_page_first_lba/SECTORS_PER_PAGE;
		bank = lpn % N_BANKS;
		halved_lpn = lpn/N_BANKS;
		if(L2P[bank][halved_lpn]==-1){// Empty
			for(int i=0;i<nsect;i++){
				current_read_buffer[i]=0xFFFFFFFF;
			}
		}else{
			int ppn = L2P[bank][halved_lpn];
			nand_read(bank,ppn/PAGES_PER_BLK,ppn%PAGES_PER_BLK,data,&spare); sector_transferred+=8;
			for(int i=first_lba_offset;i<=last_lba_offset;i++){
				current_read_buffer[i-first_lba_offset]=data[i];
			}
		}
	}
	else{
		for(int pp=0;pp<send_kazu;pp++){ // 각각의 읽을 페이지에 대하여
			lpn = pp + first_page_first_lba/SECTORS_PER_PAGE;
			bank = lpn % N_BANKS;
			halved_lpn = lpn/N_BANKS;
			int sector_kazu = 0; // 해당 lpn으로부터 read_buffer 로 적어야 하는 sector 수
			if(pp==0){
				sector_kazu = 8 - first_lba_offset;
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
			}else if(pp==send_kazu-1){
				sector_kazu = last_lba_offset;
				if(L2P[bank][halved_lpn]==-1){ // Empty
					for(int i=0;i<sector_kazu;i++){
						current_read_buffer[i]=0xFFFFFFFF;
					}
				}else{
					int ppn = L2P[bank][halved_lpn];
					nand_read(bank,ppn/PAGES_PER_BLK,ppn%PAGES_PER_BLK,data,&spare); sector_transferred+=8;
					for(int i=0;i<=last_lba_offset;i++){
						current_read_buffer[i] = data[i];
					}
				}
			}else{
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
			}
			current_read_buffer+=sector_kazu;
		}
	}
}


void write_through_lpn(int bank, u32 halved_lpn, int* data){ // integer
	if(next_ppn[bank]==gc_trigger_ppn[bank]){ // GC 발동
		garbage_collection(bank); // Free a Block, update next_ppn, gc_trigger_ppn
	}
	int ppn = next_ppn[bank];
	if(L2P[bank][halved_lpn]!=-1){ // 덮어쓰기라면 => 이방식으로 판별하면 문제발생할듯. Spare Block 도 덮어쓰는걸로 취급할 기세아니냐?
		isValid[bank][L2P[bank][halved_lpn]]=0;
	}
	L2P[bank][halved_lpn]=next_ppn[bank];
	int result = nand_write(bank, ppn/PAGES_PER_BLK, ppn%PAGES_PER_BLK, data, &halved_lpn); stats.nand_write++; // memcpy 32Byte && 4Byte
	// printf("nand_write result = %d\n",result);
	next_ppn[bank]++;
}

void ftl_write(u32 lba, u32 nsect, u32 *write_buffer)
{
	/* stats.nand_write++ every nand_write call*/
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
	if(send_kazu == 0){ // 한 페이지도 채 안되는 포장
		// 대가리도 0xff가, 끄트머리도 0xff가 될 가능성이 있음
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
	stats.host_write += nsect;
	return;
}
