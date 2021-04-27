#include <stdio.h>
#include <stdlib.h>
extern void quick_sort();
extern int binary_search();

int main() {
	long long int target = 2017313213;	// 검색학번
	int size = 49;						// 학생수
	long long int data[size];			// 딕셔너리
	long long int *point = data;		// 딕셔너리 베이스주소를 담고있음
	int num = 0;						// 검색된 번째 출력용
	for(int i = 0; i<size; i++)
		data[i]=0;

    printf("Here\n");

    FILE *fp;
	if( ( fp = fopen("input.txt" ,"r" )) == NULL ) {
		fprintf(stderr, "Error ");
		exit(1);
	}
	for(int i = 0; i<size; i++)
		fscanf(fp, "%d " ,point+i);
	fclose(fp);

    printf("Here2\n");
	quick_sort(data, 0, size-1);
    printf("Here3\n");


	if( ( fp = fopen("output.txt" ,"w" )) == NULL ) {
		fprintf(stderr, "Error ");
		exit(1);
	}
	for(int i = 0; i<size; i++)
		fprintf(fp,"%d ",*(point+i));
	fclose(fp);

	for (int i = 0; i < size;i++){
		printf("data[%d] == %d\n", i, data[i]);
	}

    num = binary_search(point, size, target);
	if(num == -1)
		printf("ERROR\n");
	printf("학번은 %d이고  %d번째 위치한다.\n", target, num+1);
	return 0;
}