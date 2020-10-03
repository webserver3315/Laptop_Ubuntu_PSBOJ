#define MYSOURCE

#ifdef MYSOURCE

#include <fcntl.h>
#include <stdio.h>  // string.h, stdio.h 는 나중에 필히 삭제할 것.
#include <stdlib.h>
// #include <string.h>  // string.h, stdio.h 는 나중에 필히 삭제할 것.
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
    /*
        * src 가 null byte 일때까지 dest에 한자씩 복사한 후 리턴합니다.
    */
    while ((*dest++ = *src++) != '\0')
        /* nothing */;
    return tmp;
}

char* my_strtok(char* str, const char* delims) {
    if (delims == NULL) {
        return str;
    }
    char* ptr = str;
    int flag = 0;
    if (flag == 1) {
        return NULL;
    }
    char* ptrReturn = ptr;
    for (int j = 0; ptr != '\0'; j++) {
        for (int i = 0; delims[i] != '\0'; i++) {
            if (ptr[j] == '\0') {
                flag = 1;
                return ptrReturn;
            }
            if (ptr[j] == delims[i]) {
                ptr[j] = '\0';
                ptr += j + 1;
                return ptrReturn;
            }
        }
    }
    return NULL;
}

int my_strcmp(const char* s1, const char* s2) {
    while (*s1) {
        if (*s1 != *s2) {
            char a = *s1;
            char b = *s2;
            if (a >= 97 && a <= 122) {
                a -= 32;
            }
            if (b >= 97 && b <= 122) {
                b -= 32;
            }
            if (a != b) {
                return a - b;
            } else {
                continue;
            }
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

// int is_char_same(char a, char b) {
//     if (a >= 97 && a <= 122) {
//         return a - 32;
//     }
//     if (b >= 97 && b <= 122) {
//         return b - 32;
//     }
//     if (a == b)
//         return 1;
//     else
//         return 0;
// }

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