#define MYSOURCE

#ifdef MYSOURCE

#include "mystring.h"

#include <fcntl.h>
#include <stdlib.h>
#include <unistd.h>

// 문자열 길이 s 반환. 널문자 비포함.
int my_strlen(const char* s) {
    int i;
    for (i = 0; s[i] != '\0'; i++)
        ;
    return i;
}

// from 의 문자열을 to 주소에 복붙
char* my_strcpy(char* dest, char* src) {
    char* tmp = dest;
    // src 가 null byte 일때까지 dest에 한자씩 복사한 후 리턴
    while ((*dest++ = *src++) != '\0')
        /* nothing */;
    return tmp;
}

// static char* temp_ptr = NULL;

char* my_strtok(char* str, char* delimiters) {
    static char* current_pointer;
    char* delimit_pointer;

    if (str != NULL)
        current_pointer = str;
    else
        str = current_pointer;

    if (*current_pointer == NULL) return NULL;

    //문자열 점검
    while (*current_pointer) {
        delimit_pointer = (char*)delimiters;
        while (*delimit_pointer) {
            if (*current_pointer == *delimit_pointer) {
                *current_pointer = NULL;
                ++current_pointer;
                return str;
            }
            ++delimit_pointer;
        }
        ++current_pointer;
    }
    // 더이상 자를 수 없다면 NULL반환
    return str;
}

int my_strcmp(const char* s1, const char* s2) {
    while (*s1) {
        char a = *s1;
        char b = *s2;
        if (!is_char_same(a, b)) {
            break;
        }
        s1++;
        s2++;
    }
    return *(const unsigned char*)s1 - *(const unsigned char*)s2;
}

void* my_memset(void* dest, int fillChar, unsigned int count) {
    for (size_t i = 0; i < count; i++)
        *((char*)dest + i) = fillChar;
    return dest;
}

int is_char_same(char a, char b) {
    if (a >= 97 && a <= 122) {
        a -= 32;
    }
    if (b >= 97 && b <= 122) {
        b -= 32;
    }
    if (a == b)
        return 1;
    else
        return 0;
}

void my_itoa(int n, char str[]) {
    int i, sign;
    if (n == 0) {
        str[0] = '0';
        str[1] = '\0';
        return;
    }
    if ((sign = n) < 0)
        n = -n;
    i = 0;
    do {
        str[i++] = n % 10 + '0';
    } while ((n /= 10) > 0);
    if (sign < 0)
        str[i++] = '-';
    str[i] = '\0';
    my_reverse(str);
}

void my_reverse(char str[]) {
    int i, j;
    char c;
    for (i = 0, j = my_strlen(str) - 1; i < j; i++, j--) {
        c = str[i];
        str[i] = str[j];
        str[j] = c;
    }
}

void print_int(int row, int cnt) {
    int row_digit = return_digit(row);
    char* row_num = malloc(row_digit + 1);
    if (cnt > 0) {
        write(STDOUT_FILENO, " ", 1);
    }
    my_itoa(row, row_num);
    write(STDOUT_FILENO, row_num, row_digit);
    free(row_num);
}

void print_int_int(int row, int col, int cnt) {
    int row_digit = return_digit(row);
    int col_digit = return_digit(col);
    if (cnt > 0) {
        write(STDOUT_FILENO, " ", 1);
    }

    char* row_num = malloc(row_digit + 1);
    char* col_num = malloc(col_digit + 1);
    my_itoa(row, row_num);
    my_itoa(col, col_num);
    // printf("%d 's Digit is %d\n", row, row_digit);
    // printf("sizeof %ld strlen %d\n", sizeof(row_num), my_strlen(row_num));
    // printf("%d 's Digit is %d\n", col, col_digit);
    // printf("%s:%s \n\n", row_num, col_num);
    write(STDOUT_FILENO, row_num, row_digit);
    write(STDOUT_FILENO, ":", 1);
    write(STDOUT_FILENO, col_num, col_digit);
    free(row_num);
    free(col_num);
}

int return_digit(int num) {
    int ret = 0;
    if (num == 0)
        return 1;
    while (num != 0) {
        num /= 10;
        ret++;
    }
    return ret;
}

int my_rewind(int fd) {  // 비정상 rewind 시 -1 반환.
    int ret = lseek(fd, 0, SEEK_SET);
    if (ret != 0) {
        return -1;
    }
    return ret;
}

#endif