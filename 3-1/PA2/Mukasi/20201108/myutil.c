#include "myutil.h"

void execute(char* arg, int fd_in, int fd_out) {
    char* cmd = malloc(512);
    sprintf(cmd, "/bin/%s", arg[0]);

    execv(cmd, arg);
    free(cmd);
}

/* If first arg is a builtin command, run it and return true */
int builtin_command(char** argv) {
    /* Insert your code */
    if (strcmp("exit", argv[0]) == 0) {
        printf("exit\n");
        exit(0);
    } else if (strcmp("cd", argv[0]) == 0) {
        return 1;
    } else {
    }

    return 0;
}
/* $end eval */

/* 
 *  $ begin parseline
 *  parseline - Parse the command line and build the argv array
 */
int parseline(char* buf, char** argv) {
    char* delim; /* Points to first space delimiter */
    int argc;    /* Number of args */
    int bg;      /* Background job? */

    buf[strlen(buf) - 1] = ' '; /* Replace trailing '\n' with space */

    /* Ignore leading spaces */
    while (*buf && (*buf == ' '))
        buf++;

    /* Build the argv list */
    argc = 0;
    while ((delim = strchr(buf, ' '))) {
        argv[argc++] = buf;
        *delim = '\0';
        buf = delim + 1;

        /* Ignore spaces */
        while (*buf && (*buf == ' '))
            buf++;
    }
    argv[argc] = NULL;

    /* Ignore blank line */
    if (argc == 0)
        return 1;

    /* Should the job run in the background? */
    if ((bg = (*argv[argc - 1] == '&')) != 0)
        argv[--argc] = NULL;

    return bg;
}
/* $end parseline */

void pop_left_pipeline(char* left, char* cmd) {
    cmd = strtok(NULL, "|");
}

void make_tokens(char* cmd, char* arg[], char* arg2[], char* target) {
    char *left, *right, *ptr;
    int num = 0;

    left = strtok(cmd, target);  // malloc 으로 메모리 할당 안하고 넣는건데 이거 ㄱㅊ?
    strcat(left, "\0");
    right = strtok(NULL, target);
    strcat(right, "\0");

    ptr = strtok(left, " ");
    while (ptr != NULL) {
        arg[num++] = ptr;
        // printf("arg[%d]=%s\n", num - 1, arg[num - 1]);
        ptr = strtok(NULL, " ");
    }
    arg[num] = NULL;

    num = 0;
    ptr = strtok(right, " ");
    while (ptr != NULL) {
        arg2[num++] = ptr;
        // printf("arg2[%d]=%s\n", num - 1, arg2[num - 1]);
        ptr = strtok(NULL, " ");
    }
    arg2[num] = NULL;

    return;
}