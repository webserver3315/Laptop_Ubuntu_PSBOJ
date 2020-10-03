#include <stdio.h>

int main(){
    int i;
    scanf("%d", &i)

    char* str_line_number;
	str_line_number=IntToChar(current_line_number, str_line_number);
	char space = ' ';
	char bar = '|';

	int tmp = current_line_number;
	int current_line_digits=0;
	while(tmp>0){
		tmp/=10;
		current_line_digits++;
	}

	for(int i=0;i<total_line_number-current_line_digits;i++){
		write(ofd, &space, 1);
	}
	for(int i=0;i<sizeof(str_line_number)-1;i++){
		char c = str_line_number[i];
		write(ofd, &c, 1);
	}

	for(int i=0;i<digits+4;i++){
		write(ofd, &space, 1);
		write(ofd, &bar, 1);
		write(ofd, &space, 1);
	}

    return 0;
}