#include <stdio.h>
#include <unistd.h>

struct msg
{
	long msgtype;
	/* implement here */ 
};

struct msg_ack 
{
	long msgtype;
	/* implement here */ 
};

int main()
{
	/* 
	 * @ int uid: user ID
	 * @ int receiver_id: receiver's ID
	 */ 
	int uid; 
	int receiver_id;

	printf("my id is \n");
	scanf("%d", &uid);
	getchar(); // flush

	printf("who to send ? \n");
	scanf("%d", &receiver_id); 
	getchar(); // flush  
		
	/* code to get key and QID */
	/*
	 * @ insert code here from
	 * @ .
	 * @ .
	 * @ here
	 */

	if (fork() == 0) {
		while (1) {
			/* receive message */ 
			/* get msg from queue and print out */ 
		}		
	} else {
		while (1) {
			/* send message */ 
			/* get user input and send to the msg queue */
		}
	}	

	return 0;
}
