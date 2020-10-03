#define MYSOURCE

#ifdef MYSOURCE
// 문자열 길이 s 반환. 널문자 비포함.
int my_strlen(const char* s);

// from 의 문자열을 to 주소에 복붙
char* my_strcpy(char* dest, char* src);

char* my_strtok(char* str, const char* delims);

int my_strcmp(const char* s1, const char* s2);

void* my_memset(void* dest, int fillChar, unsigned int count);

// int is_char_same(char a, char b);

// left 와 right 문자열을 비교. 같으면 0, 다르면 1
// int is_string_diff(char* left, char* right);
#endif