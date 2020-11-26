#include <pthread.h>
#include <stdlib.h>
#include <stdio.h>
#include <time.h>

struct thread_data {
	int tid;
	int result;
};

int row;
int col;

void *thread_mvm(void *arg)
{
	/*
	 * Insert your code
	 */
}

int main(int argc, char *argv[])
{
	if (argc != 3) {
		printf("Usage: %s <row> <column>\n", argv[0]);
		exit(1);
	}

	row = atoi(argv[1]);
	col = atoi(argv[2]);

	pthread_t tid[row];
	struct thread_data t_data[row];

	srand(time(NULL));

	/*
	 *  Insert your code
	 */

	/*  
	 *  Hint for Pthread Usage
	 *
	 *  pthread_create(&tid[i], NULL, thread_mvm, (void*)&t_data[i]);
	 *  
	 *  i means array index
	 */

	return 0;
}
