#define MYSOURCE

#ifdef MYSOURCE
// 문자열 길이 s 반환. 널문자 비포함.
int my_strlen(const char* s);

// from 의 문자열을 to 주소에 복붙
char* my_strcpy(char* dest, char* src);

char* my_strtok(char* str, char* delims);

int my_strcmp(const char* s1, const char* s2);

void* my_memset(void* dest, int fillChar, unsigned int count);

int is_char_same(char a, char b);

void my_itoa(int n, char s[]);

void my_reverse(char s[]);

void print_int(int row, int cnt);

void print_int_int(int row, int col, int cnt);

int return_digit(int num);

int my_rewind(int fd);

// left 와 right 문자열을 비교. 같으면 0, 다르면 1
// int is_string_diff(char* left, char* right);
#endif