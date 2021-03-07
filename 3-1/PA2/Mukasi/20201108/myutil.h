#define MAXARGS 128
#define MAXLINE 256
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

int parseline(char* buf, char** argv);
int builtin_command(char** argv);

void execute(char* arg, int fd_in, int fd_out);
void pop_left_pipeline(char* left, char* cmd);
void make_tokens(char* cmd, char* arg[], char* arg2[], char* target);