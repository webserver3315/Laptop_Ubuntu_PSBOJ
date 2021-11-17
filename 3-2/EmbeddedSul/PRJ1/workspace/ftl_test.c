/*
 * Lab #2 : FTL Simulator
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
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <time.h>

struct ftl_stats stats;

static void show_info(void)
{
	printf("Bank: %d\n", N_BANKS);
	printf("Blocks / Bank: %d blocks\n", BLKS_PER_BANK);
	printf("Pages / Block: %d pages\n", PAGES_PER_BLK);
	printf("Sectors per Page: %lu\n", SECTORS_PER_PAGE);
	printf("OP ratio: %d%%\n", OP_RATIO);
	printf("Physical Blocks: %d\n", N_BLOCKS);
	printf("User Blocks: %lu\n", N_USER_BLOCKS);
	printf("Map Blocks: %lu\n", N_MAP_BLOCKS);
	printf("OP Blocks: %lu\n", N_OP_BLOCKS);
	printf("PPNs: %d\n", N_PPNS);
	printf("LPNs: %lu\n", N_LPNS);
	printf("\n");
}

static u32 get_data()
{
	return rand() & 0xff;
}

extern void show_whole_nand();
extern void show_score();
int line = 2;
int debug = 0;

int main(int argc, char **argv)
{
	if (argc >= 2 && !freopen(argv[1], "r", stdin)) {
		perror("freopen in");
		return EXIT_FAILURE;
	}
	if (argc >= 3 && !freopen(argv[2], "w", stdout)) {
		perror("freopen out");
		return EXIT_FAILURE;
	}

	int seed;
	if (scanf("S %d", &seed) < 1) {
		fprintf(stderr, "wrong input format\n");
		return EXIT_FAILURE;
	}
	srand(time(NULL));
	// srand(seed);

	ftl_open();
	show_info();

	while (1) {
		if(debug) printf("=============================LINE %d===========================\n", line);
		int i;
		char op;
		u32 lba;
		u32 nsect;
		u32 *buf;
		if (scanf(" %c", &op) < 1)
			break;
		switch (op) {
		case 'R':
			scanf("%d %d", &lba, &nsect);
                        assert(lba >= 0 && lba + nsect <= N_LPNS * SECTORS_PER_PAGE);
			buf = malloc(SECTOR_SIZE * nsect);
			ftl_read(lba, nsect, buf);
			printf("Read(%u,%u): [ ", lba, nsect);
			for (i = 0; i < nsect; i++)
				printf("%2x ", buf[i]);
			printf("]\n");
                        free(buf);
			if(debug){
				show_whole_nand();
			}
			line++;
			break;
		case 'W':
			scanf("%d %d", &lba, &nsect);
                        assert(lba >= 0 && lba + nsect <= N_LPNS * SECTORS_PER_PAGE);
			buf = malloc(SECTOR_SIZE * nsect);
			for (i = 0; i < nsect; i++)
				buf[i] = get_data();
			ftl_write(lba, nsect, buf);
			printf("Write(%u,%u): [ ", lba, nsect);
			for (i = 0; i < nsect; i++)
				printf("%2x ", buf[i]);
			printf("]\n");
                        free(buf);
			if(debug){
				show_whole_nand();
			}
			line++;
			break;
		default:
			fprintf(stderr, "Wrong op type\n");
			return EXIT_FAILURE;
		}
	}
	show_score();
	return 0;
}
