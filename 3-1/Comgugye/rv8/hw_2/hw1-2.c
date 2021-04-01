
void spiral (int (*p)[15], int len)
{
    int i;

    int x   = 0;
    int y   = -1;
    int cnt = 1;
    int turn   = 1;

    while(len >= 0)
  {
    for(i = 0; i < len; i++) 
    {
      y       = y + turn;
      p[x][y] = cnt;
      cnt ++;
    
    }
    len --;

    for(i = 0; i < len; i++)
    {
      x       = x + turn;
      p[x][y] = cnt;
      cnt++;
      
    }    
    turn = turn * -1; 
  }
  
}
