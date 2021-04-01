#include <stdio.h>
#include <stdlib.h>
extern void quick_sort();
extern int binary_search();
int main() {

long long int target = 2020710435;
int size = 49;
long long int data[size];
long long int *point = data;
int num = 0;
for(int i = 0; i<size; i++)
data[i]=0;

FILE *fp;
if( ( fp = fopen("input.txt" ,"r" )) == NULL ) {
fprintf(stderr, "Error ");
exit(1);
}
for(int i = 0; i<size; i++)
fscanf(fp, "%d " ,point+i);
fclose(fp);

quick_sort(data, 0, size-1);

if( ( fp = fopen("output.txt" ,"w" )) == NULL ) {
fprintf(stderr, "Error ");
exit(1);
}
for(int i = 0; i<size; i++)
fprintf(fp,"%d ",*(point+i));
fclose(fp);

num = binary_search(point, size, target);
if(num == -1)
	printf("ERROR\n");
printf("학번은 %d이고  %d번째 위치한다.\n", target, num+1);
return 0;
}