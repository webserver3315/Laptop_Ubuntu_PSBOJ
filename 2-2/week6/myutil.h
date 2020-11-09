#include <fcntl.h>
#include <stdlib.h>
#include <unistd.h>

// #include "mystring.h"
#define MAX_LENGTH 128 * 1024 * 1024  // 줄당 최대 128MB 가정

int get_string_from_fd(int fd, char* dest);

int what_query_is_it(char* query);

int repeat_queries(int txt_fd);

int solve(int txt_fd);