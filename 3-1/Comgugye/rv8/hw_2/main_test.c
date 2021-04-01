#include <stdio.h>

// extern void spiral ();

/*
s1: 
s2: 
s3: 
s4: 
s5: 
s6: 
s7: 
s8: 
s9: 
s10: 
*/


void spiral (long long int (*p)[15], int len)
{
    int i;

    int x = 0;
    int y = -1;
    int cnt = 1;
    int turn = 1;

    while(len >= 0)
  {
    for(i = 0; i < len; i++) 
    {
      y= y + turn;
      p[x][y] = cnt;
      cnt++;
    
    }
    len--;

    for(i = 0; i < len; i++)
    {
      x= x + turn;
      p[x][y] = cnt;
      cnt++;
    }    
    turn = turn * (-1); 
  }
  
}

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


// int main()
// {

//   long long int array[15][15];
//   int len = 15;
//   long long int (*p)[15] = array;
  
//   printf("Before:\n p: %p\n len: %d\n", p, len);
//   printf("Before:\n p: %p\n len: %d\n", p, len);

//   spiral (p, len);
  
//   int a, b;
//   // printf("len=%d\n", len);
//   // len = 15;
//   printf("After:\n p: %p\n len: %d\n", p, len);
//   for(a = 0; a < len; a++)
//   {    
//     for(b = 0; b < len; b++)
//     printf("%4d", array[a][b]);
//     printf("\n");
//   }
// }
