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

typedef unsigned int u32;

struct Page {
    u32 data[8]; //32byte
    u32 spare; //4byte
};

struct Page* nand;
char* iswritten; 
int* blk_index;
int NBANKS, NBLKS, NPAGES;

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
int nand_init(int nbanks, int nblks, int npages) {
    if (nbanks <= 0 || nblks <= 0 || npages <= 0) return NAND_ERR_INVALID;
    nand = (struct Page *)malloc(sizeof(struct Page) * nbanks * nblks * npages);
    iswritten = (char *)malloc(sizeof(char) * nbanks * nblks * npages);
    memset(iswritten, 0 , sizeof(char) * nbanks * nblks * npages);
    blk_index = (int *)malloc(sizeof(int) * nbanks * nblks);
    memset(blk_index, 0, sizeof(int) * nbanks * nblks);
    NBANKS = nbanks, NBLKS = nblks, NPAGES = npages;
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
void print_page(int page_idx){
	printf("nand[%d].data[0:7] == [",page_idx);
	for (int i = 0; i < 7; i++) {
        printf("%x, ", nand[page_idx].data[i]);
    }
	printf("%x]\n", nand[page_idx].data[7]);
}

int nand_write(int bank, int blk, int page, void *data, void *spare) {
    // printf("NAND_WRITE: bank:%d, blk:%d, page:%d\n",bank,blk,page);
    if (bank >= NBANKS || blk >= NBLKS || page >= NPAGES || bank < 0 || blk < 0 || page < 0) return NAND_ERR_INVALID;
    int page_idx = bank * (NBLKS * NPAGES) + blk * (NPAGES) + page; 
    int blk_idx = bank * NBLKS + blk; 
    if (blk_index[blk_idx] != page) return NAND_ERR_POSITION;
    if (iswritten[page_idx] != 0) return NAND_ERR_OVERWRITE;
    blk_index[blk_idx]++;
    iswritten[page_idx] = 1;
    for (int i = 0; i < 8; i++) {
        // printf("nand[%d].data[%d] := %x\n",page_idx,i, *((u32*)data + i));
        nand[page_idx].data[i] = *((u32*)data + i);
    }
    nand[page_idx].spare = *(u32*)spare;
	// print_page(page_idx);
    // printf("nand[%d].spare := %d\n",page_idx,*(u32*)spare);
    // printf("NAND_WRITE ended SUCCESSFULLY\n");
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
int nand_read(int bank, int blk, int page, void *data, void *spare) {
    // printf("NAND_READ: bank:%d, blk:%d, page:%d\n",bank,blk,page);
    if (bank >= NBANKS || blk >= NBLKS || page >= NPAGES || bank < 0 || blk < 0 || page < 0) return NAND_ERR_INVALID;
    int page_idx = bank * (NBLKS * NPAGES) + blk * (NPAGES) + page;
    if (iswritten[page_idx] == 0) return NAND_ERR_EMPTY;
    for (int i = 0; i < 8; i++) {
        // printf("nand[%d].data[%d] == %x\n",page_idx, i, nand[page_idx].data[i]);
        *((u32*)data + i) = nand[page_idx].data[i];
    }
    *(u32*)spare = nand[page_idx].spare;
	// print_page(page_idx);
    // printf("spare == %d\n",nand[page_idx].spare);
    // printf("NAND_READ ended SUCCESSFULLY\n");
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
int nand_erase(int bank, int blk) {
    if (bank >= NBANKS || blk >= NBLKS || bank < 0 || blk < 0) return NAND_ERR_INVALID;
    int blk_idx = bank * NBLKS + blk;
    if (blk_index[blk_idx] == 0) return NAND_ERR_EMPTY;
    blk_index[blk_idx] = 0;
    for (int i = 0; i < NPAGES; i++) iswritten[blk_idx * NPAGES + i] = 0;
	// My Code
	// for (int i = 0; i < NPAGES; i++){
	// 	for(int p=0;p<8;p++)
	// 		nand[bank * (NBLKS * NPAGES) + blk * (NPAGES) + i].data[p] = 0;
	// 	nand[bank * (NBLKS * NPAGES) + blk * (NPAGES) + i].spare = 0;
	// }
    return NAND_SUCCESS;
}

