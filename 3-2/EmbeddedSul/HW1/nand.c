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

/*
 * define your own data structure for NAND flash implementation
 */
typedef struct _Page{
	char Data[]
} Page;
int NAND_FLASH[뱅크수][블록수];

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
int nand_init(int nbanks, int nblks, int npages)
{
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
	return NAND_SUCCESS;
}
