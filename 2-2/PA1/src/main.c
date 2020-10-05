#include <fcntl.h>
#include <stdio.h>  // string.h, stdio.h 는 나중에 필히 삭제할 것.
#include <stdlib.h>
// #include <string.h>  // string.h, stdio.h 는 나중에 필히 삭제할 것.
#include <unistd.h>

#include "mystring.h"
#include "myutil.h"

/*
Input 은 stdin 으로부터.
Access 는 fd 를 활용한 user fd로.
Output 또한 fd 를 활용한 userfd로(?)
*/

int main(int argc, char** argv) {
    int txt_fd, iret;  // Variables for input file
    int ret;
    char err1[64] = "Need More Argument!\n";
    char err2[64] = "Too Many Arguments!\n";
    char err3[64] = "Input file is not exist!\n";
    char err4[64] = "Output file has problem!\n";
    char err5[64] = "Error while inserting number\n";
    char err6[64] = "Error while closing input file\n";
    char err7[64] = "Error while closing output file\n";

    txt_fd = open(argv[1], O_RDONLY);
    if (txt_fd < 0) {
        write(STDOUT_FILENO, err3, 25);
        exit(1);
    } else if (argc > 2) {  // When there are so many variables
        write(STDOUT_FILENO, err2, 20);
        exit(1);
    } else {
        /* Open input file */
        if (txt_fd < 0) {
            write(STDOUT_FILENO, err3, 25);
            exit(1);
        }

        /* Add line number to output file */
        ret = solve(txt_fd);

        if (ret < 0) {
            write(STDOUT_FILENO, err5, 29);
            exit(1);
        }

        /* Close input file */
        iret = close(txt_fd);
        if (iret < 0) {
            write(STDOUT_FILENO, err6, 31);
            exit(1);
        }
    }
    return 0;
}