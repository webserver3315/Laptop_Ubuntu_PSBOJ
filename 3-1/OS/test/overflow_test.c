#include <stdio.h>
#define MAXIMUM_INT 0x7FFFFFFF
#define MINIMUM_INT 0x80000000

int is_overflow(int a, int b){ // Does a+b OVERFLOWS? => 1 == true, 0 == false
  if (b > 0){ // a + |b|
    if(a>MAXIMUM_INT-b){
	    printf("%d + %d == %d => overflow\n",a,b,a+b);
      return 1;
    }
  }
  else if(b<0){ // a - |b|
    if(a<MINIMUM_INT-b){
	    printf("%d + %d == %d => overflow\n",a,b,a+b);
      return 1;
    }
  }
  return 0;
}

int is_overflow2(int a, int b){
	int overflow;
	if (a^b < 0) overflow=0; /* opposite signs can't overflow */
	else if (a>0) overflow=(b>MAXIMUM_INT-a);
	else overflow=(b<MINIMUM_INT-a);
	return overflow;
}
int main(){
	int a, b;
	scanf("%d %d",&a,&b);

	int ret;
	ret=is_overflow(a,b);
	if(ret==1){
		printf("OVFL HAPPENED");
	}
	else{
		printf("SAFE");
	}
	return 0;
}
