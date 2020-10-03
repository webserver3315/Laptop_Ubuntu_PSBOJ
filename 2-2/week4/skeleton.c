#include <unistd.h>
#include <stdlib.h>
#include <fcntl.h>

#define	ERRFILEREAD	-1
#define	ERRFILEWRITE	-2
#define	ERRFILESEEK	-3

int addlinenum(int ifd, int ofd);

int main(int argc, char **argv)
{
	int ifd, iret;	// Variables for input file
	int ofd, oret;	// Variables for output file
	int ret;
	char err1[64] = "Need More Argument!\n";
	char err2[64] = "Too Many Arguments!\n";
	char err3[64] = "Input file is not exist!\n";
	char err4[64] = "Output file has problem!\n";
	char err5[64] = "Error while inserting number\n";
	char err6[64] = "Error while closing input file\n";
	char err7[64] = "Error while closing output file\n";

	if (argc < 3) {		// When there are not enough variables
		write(STDOUT_FILENO, err1, 20);
		exit(1);
	} else if (argc > 3) {	// When there are so many variables
		write(STDOUT_FILENO, err2, 20);
		exit(1);
	} else {
		/* Open input file */
		ifd = open(argv[1], O_RDONLY);
		if (ifd < 0) {
			write(STDOUT_FILENO, err3, 25);
			exit(1);
		}

		/* Create and open output file */
		ofd = open(argv[2], O_RDWR | O_CREAT,
				S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
		if (ofd < 0) {
			write(STDOUT_FILENO, err4, 25);
			exit(1);
		}
		
		/* Add line number to output file */
		ret = addlinenum(ifd, ofd);
		if (ret < 0) {
			write(STDOUT_FILENO, err5, 29);
			exit(1);
		}

		/* Close input file */
		iret = close(ifd);
		if (iret < 0) {
			write(STDOUT_FILENO, err6, 31);
			exit(1);
		}

		/* Close output file */
		oret = close(ofd);
		if (oret < 0) {
			write(STDOUT_FILENO, err7, 32);
			exit(1);
		}
	}

	exit(0);
}

#define	RADIX	10

int IntToChar(int value, char *buf)
{
	int _value = value;
	int index = 0;
	int i;
	char temp;

	while (_value) {
		buf[index] = (_value % RADIX) + '0';
		_value /= RADIX;
		index++;
	}

	for (i = 0; i < index / 2; i++) {
		temp = buf[i];
		buf[i] = buf[(index - 1) - i];
		buf[(index - 1) -i] = temp;
	}

	return 0;
}


/*
여기부터 시작
*/

#define BUF_SIZ 128
void print_line_number(int ofd, int current_line_number, int total_line_digits){
	// char str_line_number[20];
	char str_line_number[20];
	IntToChar(current_line_number, str_line_number);
	char space = ' ';
	char bar = '|';

	int tmp = current_line_number;
	int current_line_digits=0;
	while(tmp>0){
		tmp/=10;
		current_line_digits++;
	}

	for(int i=0;i<total_line_digits-current_line_digits;i++){
		write(ofd, &space, 1);
	}
	for(int i=0;i<current_line_digits;i++){
		char c = str_line_number[i];
		write(ofd, &c, 1);
	}
	write(ofd, &space, 1);
	write(ofd, &bar, 1);
	write(ofd, &space, 1);
	return;
	
}

int addlinenum(int ifd, int ofd){
	char buf;
	int total_line_number=0;
	int rd_bytes;
	while(0<(rd_bytes = read(ifd, &buf, 1))){
		// write(ofd, &buf, 1);
		if(buf=='\n'){
			total_line_number++;
		}
	}
	int tmp = total_line_number;
	int total_line_digits=0;
	while(tmp>0){
		tmp/=10;
		total_line_digits++;
	}

	int pos = lseek(ifd, 0, SEEK_SET);
	if(pos!=0){
		return -1;
	}

	int current_line_number=1;
	print_line_number(ofd, current_line_number, total_line_digits);
	while(0<(rd_bytes = read(ifd, &buf, 1))){
		write(ofd, &buf, 1);
		if(buf=='\n'){
			if(current_line_number==total_line_number)
				break;
			current_line_number++;
			print_line_number(ofd, current_line_number, total_line_digits);
		}
	}
	return 0;
}