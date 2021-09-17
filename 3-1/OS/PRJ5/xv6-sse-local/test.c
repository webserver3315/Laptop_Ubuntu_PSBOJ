#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int
main()
{
  char buf[512];
  int fd, i, blocks;

  fd = open("big.file", O_CREATE | O_WRONLY);
  if(fd < 0){
    printf(2, "big: cannot open big.file for writing\n");
    exit();
  }

  blocks = 0;
  while(1){
    *(int*)buf = blocks;
    int cc = write(fd, buf, sizeof(buf));
    if (cc <= 0)
	printf(1,"error\n");
    if(blocks == 2000)
    	break;
    blocks++;
	if (blocks % 100 == 0)
		printf(2, ".");
  }

  int fd2 = open("README", O_CREATE | O_WRONLY);
  if(fd2 < 0){
    printf(2, "big: cannot open big.file for writing\n");
    exit();
  }

  printf(1, "baddr : %d\n", baddr(fd, 1));
  printf(1, "baddr : %d\n", baddr(fd, 150));
  printf(1, "baddr : %d\n\n", baddr(fd, 1500));

  printf(1, "baddr : %d\n", baddr(fd2, 1));
  printf(1, "baddr : %d\n", baddr(fd2, 150));
  printf(1, "baddr : %d\n", baddr(fd2, 1500));

  printf(1, "baddr : %d\n", baddr(fd2, 3000));


  printf(1, "\nwrote %d blocks\n", blocks);

  close(fd);
  fd = open("big.file", O_RDONLY);
  if(fd < 0){
    printf(2, "big: cannot re-open big.file for reading\n");
    exit();
  }
  for(i = 0; i < blocks; i++){
    int cc = read(fd, buf, sizeof(buf));
    if(cc <= 0){
      printf(2, "big: read error at block %d\n", i);
      exit();
    }
    if(*(int*)buf != i){
      printf(2, "big: read the wrong data (%d) for block %d\n",
             *(int*)buf, i);
      exit();
    }
  }

  printf(1, "baddr : %d\n", baddr(fd, 1));
  printf(1, "baddr : %d\n", baddr(fd, 150));
  printf(1, "baddr : %d\n\n", baddr(fd, 1500));

  printf(1, "done; ok\n"); 

  exit();
}
