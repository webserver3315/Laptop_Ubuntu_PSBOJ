#include <stdio.h>

extern void spiral ();

int main()
{

  long long int array[15][15];
  int len = 15;
  long long int (*p)[15] = array;
  
  spiral (p, len);

  int a, b; 
  for(a = 0; a < len; a++)
  {    
    for(b = 0; b < len; b++)
    printf("%4d", array[a][b]);
    printf("\n");
  }
}
