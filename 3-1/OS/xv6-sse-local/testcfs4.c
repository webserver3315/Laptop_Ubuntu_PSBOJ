#include "types.h"
#include "stat.h"
#include "user.h"


void test_p1_2()
{
   int pid = getpid();
   int i;
   double x = 0, z;
   printf(1, "1st pid: %d\n", pid);   
   pid = fork();
   if(pid == 0){   //child
      for(i = 0; i < 5; i++){
         for ( z = 0; z < 3000000.0; z += 0.1 )
            x =  x + 3.14 * 89.64;
         ps();
      }
      exit();
   } else {   //parent
printf(1,"parent\n");
      ps();
      sleep(500);
printf(1,"parent\n");
      ps();
      wait();
   }
}

int main(int argc, char **argv)
{
      printf(1, "=== TEST START ===\n");
      test_p1_2();
      printf(1, "=== TEST   END ===\n");

      exit();

}
