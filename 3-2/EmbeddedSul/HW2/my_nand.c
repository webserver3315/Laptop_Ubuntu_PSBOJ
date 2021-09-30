/*
 * Lab #1 : NAND Simulator
 *  - Embedded Systems Design, ICE3028 (Fall, 2021)
 *
 * Sep. 16, 2021.
 *
 * TA: Youngjae Lee, Jeeyoon Jung
 * Prof: Dongkun Shin
 * Embedded Software Laboratory
 * Sungkyunkwan University
 * http://nyx.skku.ac.kr
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "nand.h"


/* MY CODE */
#define PAGE_DATA_SIZE (int)4*8 // 32B per Page
#define PAGE_SPARE_SIZE (int) 4 // 4Byte per Page
#define MAX_NPAGE (int)64 // 64 Pages per Block
#define MAX_NBLOCK (int)64 // Total 64 Number of Block
#define MAX_NBANK   (int)64 // total 64 banks

#define WRITTEN (int)0
#define BE_WRITTEN (int)1
#define REVMAP (int)2


/*
 * define your own data structure for NAND flash implementation
 */
// 지울 땐 블록단위, 쓸 땐 페이지단위
typedef struct Page{
	char _data[PAGE_DATA_SIZE]; // 1Byte * 8
    char _spare[PAGE_SPARE_SIZE];
	char _meta[PAGE_SPARE_SIZE];// 1 Byte * 4, [0] = written, [1] == to be written, [2] == mapped idx, [3] == ???
} Page;
typedef struct Block{
    Page _page[MAX_NPAGE]; // 4 Page
} Block;
typedef struct Bank{
	Block _block[MAX_NBLOCK]; // 4 Blocks per Bank
} Bank;
Bank Nand_Flash[MAX_NBANK];

/*
 * initialize the NAND flash memory
 * @nbanks: number of bank
 * @nblks: number of blocks per bank
 * @npages: number of pages per block
 *
 * Returns:
 *   0 on success
 *   NAND_ERR_INVALID if given dimension is invalid
 */

int NBANK, NBLOCK, NPAGE;
int nand_init(int nbanks, int nblks, int npages)
{// bank > block > page > data/spare
	if(nbanks < 0 || nbanks > MAX_NBANK) return NAND_ERR_INVALID;
	if(nblks < 0 || nblks > MAX_NBLOCK) return NAND_ERR_INVALID;
	if(npages < 0 || npages > MAX_NPAGE) return NAND_ERR_INVALID;

	NBANK = nbanks;
	NBLOCK = nblks;
	NPAGE = npages;
	for(int bank_idx=0;bank_idx<NBANK;bank_idx++){
		for(int block_idx=0;block_idx<NBLOCK;block_idx++){
			for(int page_idx=0;page_idx<NPAGE;page_idx++){
				Page* tmp_page = &(Nand_Flash[bank_idx]._block[block_idx]._page[page_idx]);	
				for(int d=0;d<PAGE_DATA_SIZE;d++){
					tmp_page->_data[d]=0;
				}
				for(int s=0;s<PAGE_SPARE_SIZE;s++){
					tmp_page->_spare[s]=0;
					tmp_page->_meta[s]=0;
				}
				if(page_idx==0)	tmp_page->_meta[BE_WRITTEN]=1; // Each Block's first Page can BE WRITTEN 
				else			tmp_page->_meta[BE_WRITTEN]=0;
			}
		}
	}
	// fprintf(stderr,"nandinit SUCCESS\n");
	return NAND_SUCCESS;
}

/*
 * write data and spare into the NAND flash memory page
 *
 * Returns:
 *   0 on success
 *   NAND_ERR_INVALID if target flash page address is invalid
 *   NAND_ERR_OVERWRITE if target page is already written
 *   NAND_ERR_POSITION if target page is empty but not the position to be written
 */
int nand_write(int bank, int blk, int page, void *data, void *spare)
{
	// 1. check invalid address: ex) Negative Addr
	// fprintf(stderr, "HERE CAME0\n");
	if(bank < 0 || bank >= NBANK) return NAND_ERR_INVALID;
	if(blk < 0 || blk >= NBLOCK) return NAND_ERR_INVALID;
	if(page < 0 || page >= NPAGE) return NAND_ERR_INVALID;
	// fprintf(stderr, "HERE CAME1\n");
	Page* tmp = &(Nand_Flash[bank]._block[blk]._page[page]);
	// 2. Check the Page is Already Written
	if(tmp->_meta[WRITTEN]==1) return NAND_ERR_OVERWRITE;
	// fprintf(stderr, "HERE CAME2\n");
	// 3. Check the Page Writting is NOT SEQUENTIAL
	if(tmp->_meta[BE_WRITTEN]!=1) return NAND_ERR_POSITION;
	// fprintf(stderr, "HERE CAME3\n");

	// 4. Map to Page_Map_Table => 아직 구현X
	// int ppn = blk*NPAGE + page%NPAGE;
	// Page_Map[bank][ppn]=

	memcpy(tmp->_data, data, sizeof(char)*PAGE_DATA_SIZE); // 32 byte
	memcpy(tmp->_spare, spare, sizeof(char)*PAGE_SPARE_SIZE); // 4 byte
	tmp->_meta[WRITTEN]=1; // ALREADY WRITTEN ON
	tmp->_meta[BE_WRITTEN]=0; // CAN BE WRITTEN OFF
	if(page < NPAGE-1){ // update be_written
		Page* next = &(Nand_Flash[bank]._block[blk]._page[page+1]);
		next->_meta[BE_WRITTEN]=1;
	}

	// fprintf(stderr, "WRITE SUCCESS\n");
	return NAND_SUCCESS;
}


/*
 * read data and spare from the NAND flash memory page
 *
 * Returns:
 *   0 on success
 *   NAND_ERR_INVALID if target flash page address is invalid
 *   NAND_ERR_EMPTY if target page is empty
 */
int nand_read(int bank, int blk, int page, void *data, void *spare)
{
	// 1. Check invalid address
	if(bank < 0 || bank >= NBANK) return NAND_ERR_INVALID;
	if(blk < 0 || blk >= NBLOCK) return NAND_ERR_INVALID;
	if(page < 0 || page >= NPAGE) return NAND_ERR_INVALID;

	// fprintf(stderr, "HERE 3-1\n");
	Page* tmp = &(Nand_Flash[bank]._block[blk]._page[page]);	
	// 2. Check the Page is Already Written, so can be READ
	if(tmp->_meta[WRITTEN]!=1) return NAND_ERR_EMPTY;
	// fprintf(stderr, "HERE 3-2\n");

	memcpy(data, tmp->_data, sizeof(char)*PAGE_DATA_SIZE); // 32 byte
	memcpy(spare, tmp->_spare, sizeof(char)*PAGE_SPARE_SIZE); // 4 byte

	// fprintf(stderr, "READ SUCCESS\n");
	return NAND_SUCCESS;
}

/*
 * erase the NAND flash memory block
 *
 * Returns:
 *   0 on success
 *   NAND_ERR_INVALID if target flash block address is invalid
 *   NAND_ERR_EMPTY if target block is already erased
 */
int nand_erase(int bank, int blk)
{
	int tobe_erased = 0;
	// 1. Check invalid Address
	if(bank < 0 || bank >= NBANK) return NAND_ERR_INVALID;
	if(blk < 0 || blk >= NBLOCK) return NAND_ERR_INVALID;

	for(int blk_idx=0;blk_idx<NBLOCK;blk_idx++){
		Block* blk = &(Nand_Flash[bank]._block[blk_idx]);
		if(blk->_page->_meta[WRITTEN]!=0) tobe_erased=1;
	}
	if(!tobe_erased) return NAND_ERR_EMPTY;

	for(int blk_idx=0;blk_idx<NBLOCK;blk_idx++){
		Block* blk = &(Nand_Flash[bank]._block[blk_idx]);
		for(int pg_idx=0;pg_idx<NPAGE;pg_idx++){
			for(int d=0;d<PAGE_DATA_SIZE;d++) blk->_page[pg_idx]._data[d] = 0;
			for(int s=0;s<PAGE_SPARE_SIZE;s++) {
				blk->_page[pg_idx]._spare[s] = 0;
				blk->_page[pg_idx]._meta[s] = 0;
			}
		}
		blk->_page[0]._meta[BE_WRITTEN] = 1; // 0번 페이지는 다시 be_written ON
	}
	
	return NAND_SUCCESS;
}
