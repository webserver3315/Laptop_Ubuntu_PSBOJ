#include <fcntl.h>
#include <stdlib.h>
#include <unistd.h>

// #include "mystring.h"
#define MAX_LENGTH 128 * 1024 * 1024  // 줄당 최대 128MB 가정

int get_string_from_fd(int fd, char* dest);

//한 단어만 받았을 때, 단어의 행과 열을 stdout에 출력
void operate_1(int txt_fd, char* text_line, char* query);
//여러 단어를 받았을 때, 모든 단어가 존재하는 시작 줄번호만 stdout에 출력
int operate_2(int ifd, char* query);
//"구문들"을 입력받았을 때, 구문이 존재하는 행과 열을 stdout 에 출력
int operate_3(int ifd, char* query);
//단어*단어로 단 두개를 입력받았을 때, 최소 1개 단어를 띄운 행을 찾음.
int operate_4(int ifd, char* query);

int what_query_is_it(char* query);

int repeat_queries(int txt_fd);

int solve(int txt_fd);