#include <stdlib.h>
#include <stdio.h>

int send_sig_cnt;
int recv_sig_cnt;
int recv_ack_cnt;
pid_t pid;

void proc_exit_handler(int sig)
{
}

void recv_ack_handler(int sig)
{
}

void send_sig_handler(int sig)
{
}

void send_ack(int sig)
{
}

int main(int argc, char *argv[])
{
	if (argc != 2) {
		fprintf(stderr, "The number of argument should be 2\n");
		exit(1);
	}

	send_sig_cnt = atoi(argv[1]);

	printf("sending signal: %d\n", send_sig_cnt);
	
	/* Install Signal Handler */

	return 0;
}
