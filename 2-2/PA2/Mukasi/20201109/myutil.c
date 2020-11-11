#include "myutil.h"

/*
 * $ begin eval
 * eval - Evaluate a command line
 */

/* If first arg is a builtin command, run it and return true */
int builtin_command(char **argv) {
    /* Insert your code */

    return 0;
}

int parseline(char *buf, char **argv) {
    char *delim; /* Points to first space delimiter */
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
