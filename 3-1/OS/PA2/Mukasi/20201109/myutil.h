#define MAXARGS 128
#define MAXLINE 256
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

int parseline(char *buf, char **argv);
int builtin_command(char **argv);
