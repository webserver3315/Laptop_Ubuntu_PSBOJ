#include "types.h"
#include "stat.h"
#include "user.h"


void testcfs()
{
   int parent = getpid();
   int child ,child2, child3;
   int i;
   double x = 0, z;
   
   if((child = fork()) == 0) { // child      // if you set parent's priority lower than child, 
                        // 2nd ps will only printout parent process,
                        // since child finished its job earlier & exit

      if((child2=fork())==0){ // child's child
         
      for(i = 0; i < 100; i++){
         for ( z = 0; z < 3000.0; z += 0.1 )
            x =  x + 3.14 * 89.64;
      }
      ps();
      exit();

      }
      else{ // child's parent
         setnice(child2,-1);
      for(i = 0; i < 100; i++){
         for ( z = 0; z < 3000.0; z += 0.1 )
            x =  x + 3.14 * 89.64;
      }
      ps();
      wait();
      exit();
      }

   } else {
	setnice(child,5);
      if((child3=fork())==0){ // parent's child
         setnice(parent,-3);
      for(i = 0; i < 100; i++){
         for ( z = 0; z < 3000.0; z += 0.1 )
            x =  x + 3.14 * 89.64;
      }
      ps();
      exit();

      }
      else{ // parent's parent
         setnice(child3,2);
      for(i = 0; i < 100; i++){
         for ( z = 0; z < 3000.0; z += 0.1 )
            x =  x + 3.14 * 89.64;
      }
      ps();
      wait();

      }

   }
   wait();
}
int main(int argc, char **argv)
{
      printf(1, "=== TEST START ===\n");
      testcfs();
      printf(1, "=== TEST   END ===\n");
      exit();

}
