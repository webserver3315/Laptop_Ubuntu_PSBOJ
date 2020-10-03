#include <fcntl.h>
// #include <mystring.h>
#include <stdio.h>  // string.h, stdio.h 는 나중에 필히 삭제할 것.
#include <stdlib.h>
#include <string.h>  // string.h, stdio.h 는 나중에 필히 삭제할 것.
#include <unistd.h>

#define MAX_LENGTH 128 * 1024 * 1024  // 줄당 최대 128MB 가정

int get_string_from_fd(int fd, char* dest) {  // fd로부터 개행까지 읽어온 뒤 개행은 빼고, dest에 덮어씀
    int rd_bytes;
    char c;
    int col = 0;
    dest[0] = 0;                                //empty array
    while (0 < (rd_bytes = read(fd, &c, 1))) {  // \n 없이 전부 읽고 저장하기
        dest[col++] = c;
        if (c == '\n') {
            dest[col++] = '\0';
            break;
        }
    }
    return strlen(dest);
}

//한 단어만 받았을 때, 단어의 행과 열을 stdout에 출력
int operate_1(int txt_fd, char* text_line, char* word) {
    char* result;
    int row = 0;
    while (0 < get_string_from_fd(txt_fd, text_line)) {
        printf("3rd\n");
        printf("%s", text_line);
        row++;
        result = strtok(text_line, " \t");

        int col = result - text_line;
        // printf("%d:%d %s\n", row, col, result);
        while (result != NULL) {
            result = strtok(NULL, " \t");
            printf("%d:%d : %s\n", row, col, result);
            printf("4th\n");
            col = result - text_line;
            if (0 == strcmp(result, word)) {
                printf("%d:%d : %s\n", row, col, result);
            }
        }
    }
}

int main(int argc, char** argv) {
    char err1[64] = "Need More Argument!\n";
    char err2[64] = "Too Many Arguments!\n";
    char err3[64] = "Input file is not exist!\n";
    char err4[64] = "Output file has problem!\n";
    char err5[64] = "Error while inserting number\n";
    char err6[64] = "Error while closing input file\n";
    char err7[64] = "Error while closing output file\n";
    char* text_line = malloc(MAX_LENGTH);

    int rd_bytes;
    char c;
    printf("text = %s\n", argv[1]);
    int txt_fd = open(argv[1], O_RDONLY);
    if (txt_fd < 0) {
        write(STDOUT_FILENO, err3, 25);
        exit(1);
    }

    printf("1st\n");

    char* result;
    int row = 0;
    char* query = "he";
    printf("2nd\n");

    printf("5th\n");
    return 0;
}

/*
int main() {
    char* buf = malloc(64);

    // int rd_bytes = read(STDIN_FILENO, buf, sizeof(buf));
    // if (rd_bytes < 0) {
    //     printf("ERROR\n");
    //     return -1;
    // }

    int rd_bytes;
    char c;
    while (0 < (rd_bytes = read(STDIN_FILENO, &c, 1))) {  // \n 없이 전부 읽고 저장하기
        if (c == '\n') continue;
        strncat(buf, &c, 1);
    }

    printf("%s - printf\n", buf);

    char append[] = " - write";
    // strncat(buf, append, sizeof(append));
    strcat(buf, append);
    printf("append is \'%s\' \n", buf);
    // printf("This is second printf: %s\n", buf);
    write(STDOUT_FILENO, buf, sizeof(buf));

    return 0;
}
*/