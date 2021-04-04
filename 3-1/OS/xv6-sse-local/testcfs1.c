#include "types.h"
#include "stat.h"
#include "user.h"

void testcfs()
{
	int parent = getpid();
	int child;
	int i;
	volatile double x = 0, z;
	
	if((child = fork()) == 0) { // child
		setnice(parent, 5);	
		printf(2, "Child %d created\n",getpid());
		// if you set parent's priority lower than child, 
		// 2nd ps will only printout parent process,
		// because child finished its job earlier than parent & exit
		for(i = 0; i < 300; i++){
			for ( z = 0; z < 180000.0; z += 0.1 )
				x =  x + 3.14 * 89.64;
		}
		ps();
		exit();
	} else {	
		setnice(child, 0);	  //parent
		printf(3, "Parent %d creating child %d\n",getpid(), child);
		for(i = 0; i < 300; i++){
			for ( z = 0; z < 180000.0; z += 0.1 )
				x =  x + 3.14 * 89.64;
		}
		ps();
		wait();
	}
}
int main(int argc, char **argv)
{
		printf(1, "=== TEST START ===\n");
		testcfs();
		printf(1, "=== TEST   END ===\n");
		exit();

}
