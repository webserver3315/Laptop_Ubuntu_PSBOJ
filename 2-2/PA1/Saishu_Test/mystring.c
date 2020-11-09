#define MYSOURCE

#ifdef MYSOURCE

#include <fcntl.h>
// #include <stdio.h>  // string.h, stdio.h 는 나중에 필히 삭제할 것.
#include <stdlib.h>
// #include <string.h>  // string.h, stdio.h 는 나중에 필히 삭제할 것.
#include <unistd.h>

#include "mystring.h"

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
    static char* pCurrent;
    char* pDelimit;

    if (str != NULL)
        pCurrent = str;
    else
        str = pCurrent;

    if (*pCurrent == NULL) return NULL;

    //문자열 점검
    while (*pCurrent) {
        pDelimit = (char*)delimiters;

        while (*pDelimit) {
            if (*pCurrent == *pDelimit) {
                *pCurrent = NULL;
                ++pCurrent;
                return str;
            }
            ++pDelimit;
        }
        ++pCurrent;
    }
    // 더이상 자를 수 없다면 NULL반환
    return str;
}

// char* my_strtok(char* str, const char* delims) {
//     if (delims == NULL) {
//         return str;
//     }
//     char* ptr = str;
//     int flag = 0;
//     if (flag == 1) {
//         return NULL;
//     }
//     char* ptrReturn = ptr;
//     for (int j = 0; ptr != '\0'; j++) {
//         for (int i = 0; delims[i] != '\0'; i++) {
//             if (ptr[j] == '\0') {
//                 flag = 1;
//                 return ptrReturn;
//             }
//             if (ptr[j] == delims[i]) {
//                 ptr[j] = '\0';
//                 ptr += j + 1;
//                 return ptrReturn;
//             }
//         }
//     }
//     return NULL;
// }

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

void my_itoa(int n, char s[]) {
    int i, sign;
    if (n == 0) {
        s[0] = '0';
        s[1] = '\0';
        return;
    }

    if ((sign = n) < 0)
        n = -n;
    i = 0;
    do {
        s[i++] = n % 10 + '0';
    } while ((n /= 10) > 0);
    if (sign < 0)
        s[i++] = '-';
    s[i] = '\0';
    my_reverse(s);
}

void my_reverse(char s[]) {
    int i, j;
    char c;

    for (i = 0, j = my_strlen(s) - 1; i < j; i++, j--) {
        c = s[i];
        s[i] = s[j];
        s[j] = c;
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

// size_t my_strspn(const char* str1, const char* str2) {
//     size_t i, j;
//     i = 0;
//     while (*(str1 + i)) {
//         j = 0;
//         while (*(str2 + j)) {
//             if (*(str1 + i) == *(str2 + j)) {
//                 break;  //Found a match.
//             }
//             j++;
//         }
//         if (!*(str2 + j)) {
//             return i;  //No match found.
//         }
//         i++;
//     }
//     return i;
// }

// char* my_strtok(char* str, const char* delim) {
//     static char* p = 0;
//     if (str)
//         p = str;
//     else if (!p)
//         return 0;
//     str = p + my_strspn(p, delim);
//     p = str + strcspn(str, delim);
//     if (p == str)
//         return p = 0;
//     p = *p ? * p = 0, p + 1 : 0;
//     return str;
// }

// // left 와 right 문자열을 비교. 같으면 0, 다르면 1
// int is_string_diff(char* left, char* right) {
//     unsigned char a, b;
//     while (1) {
//         a = *left++;
//         b = *right++;
//         if (0 == is_char_same(a, b)) {
//             return 1;
//         }
//         if (!a) break;
//     }
//     return 0;  // two are Identical
// }

// void find_all(char* dest, char* src, int row) {
//     char* ptr = dest;
//     while ((ptr = strstr(ptr, src)) != NULL) {
//         int col = ptr - dest;
//         printf("FIND: %d:%d \'%s\'\n", row, col, src);
//         ptr++;
//     }
//     return;
// }

#endif