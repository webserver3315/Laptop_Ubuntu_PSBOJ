#define MAXARGS 128
#define MAXLINE 256
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
void eval(char *cmdline);
int parseline(char *buf, char **argv);
int builtin_command(char **argv);

void cp2cpp(char *cp, char **cpp, char *target) {
    int cpp_num = 0;
    cpp[cpp_num] = strtok(cp, target);
    strcat(cpp[cpp_num++], "\0");
    while ((cpp[cpp_num] = strtok(NULL, target)) != NULL) {
        strcat(cpp[cpp_num++], "\0");
    }
    cpp[cpp_num] = NULL;
}

int cp2cppp(char *cp, char ***cppp, char *target) {
    char *cpp[256];
    cp2cpp(cp, cpp, target);
    int i;
    for (i = 0; cpp[i] != NULL; i++) {
        cp2cpp(cpp[i], cppp[i], " \t\n");
    }
    // printf("cppp[%d] became NULL\n", i);
    return i;
}

/*
void cp2cppp(char *cp, char **cpp, char ***cppp, char *target) {
    int cpp_num = 0;
    cpp[cpp_num] = strtok(cp, target);
    strcat(cpp[cpp_num++], "\0");
    while ((cpp[cpp_num] = strtok(NULL, target)) != NULL) {
        strcat(cpp[cpp_num++], "\0");
    }
    cpp[cpp_num] = NULL;

    printf("cp2cppp MIDDLE: cppnum = %d\n", cpp_num);
    for (int idx = 0; cpp[idx] != NULL; idx++) {
        printf("cpp[%d]: \'%s\'\n", idx, cpp[idx]);
    }

    for (int i = 0; i < cpp_num; i++) {
        int cppp_num = 0;
        printf("HERE\n");
        char *ptr;
        ptr = strtok(cpp[i], " \t\n");
        printf("ptr == \'%s\'\n", ptr);
        cppp[i][cppp_num] = ptr;
        printf("cppp[%d][%d] = \'%s\'\n", i, cppp_num, cppp[i][cppp_num]);
        printf("HERE2\n");
        // printf("cppp[%d][%d] = \'%s\'\n", i, cppp_num, cppp[i][cppp_num]);
        strcat(cppp[i][cppp_num++], "\0");
        while ((cppp[i][cppp_num] = strtok(NULL, " \t\n")) != NULL) {
            printf("cppp[%d][%d] = \'%s\'\n", i, cppp_num, cppp[i][cppp_num]);
            strcat(cppp[i][cppp_num++], "\0");
        }
        cppp[i][cppp_num] = NULL;
    }
    printf("cp2cppp FINISHED\n");
}
*/

void eval(char *cmdline) {
    char *argv[MAXARGS]; /* Argument list execve() */
    char buf[MAXLINE];   /* Holds modified command line */
    int bg;              /* Should the job run in bg or fg? */
    pid_t pid;           /* Process id */

    strcpy(buf, cmdline);
    bg = parseline(buf, argv);
    if (argv[0] == NULL)
        return;

    char **cpp;
    char ***cppp;
    cpp = malloc(sizeof(char *) * 256);
    cppp = malloc(sizeof(char **) * 256);
    for (int r = 0; r < 256; r++) {
        cpp[r] = malloc(sizeof(char) * 256);
        cppp[r] = malloc(sizeof(char *) * 256);
        for (int c = 0; c < 256; c++) {
            cppp[r][c] = malloc(sizeof(char) * 256);
        }
    }

    int pipeline_num = cp2cppp(cmdline, cppp, "|");
    if (pipeline_num == -1) {  //파이프라인 없으면
        printf("NO PIPELINE\n");
        if (fork() == 0) {
        } else {
        }
        return;
    }

    printf("cmd: \'%s\'\n", cmdline);
    for (int idx = 0; idx < pipeline_num; idx++) {
        for (int iidx = 0; cppp[idx][iidx] != NULL; iidx++) {
            printf("cppp[%d][%d]: \'%s\'\n", idx, iidx, cppp[idx][iidx]);
        }
    }

    if (!builtin_command(argv)) {
        /* Child runs user job */
        if ((pid = fork()) == 0) {
            if (execv(argv[0], argv) < 0) {
                fprintf(stderr, "%s: Command not found.\n", argv[0]);
                exit(0);
            }
        }

        /* Parent waits for foreground job to terminate */
        if (!bg) {
            int status;
            if (waitpid(pid, &status, 0) < 0)
                printf("waitfg: waitpid error");
        } else
            printf("%d %s", pid, cmdline);
    }
    return;
}

/* If first arg is a builtin command, run it and return true */
int builtin_command(char **argv) {
    /* Insert your code */

    return 0;
}

int parseline(char *buf, char **argv) {
    char *delim; /* Points to first space delimiter */
    int argc;    /* Number of args */
    int bg;      /* Background job? */

    buf[strlen(buf) - 1] = ' ';

    while (*buf && (*buf == ' '))
        buf++;

    argc = 0;
    while ((delim = strchr(buf, ' '))) {
        argv[argc++] = buf;
        *delim = '\0';
        buf = delim + 1;

        while (*buf && (*buf == ' '))
            buf++;
    }
    argv[argc] = NULL;

    if (argc == 0)
        return 1;

    if ((bg = (*argv[argc - 1] == '&')) != 0)
        argv[--argc] = NULL;

    return bg;
}

int main() {
    char cmdline[MAXLINE]; /* Command line */
    char *ret;

    while (1) {
        /* Read */
        printf("mini> ");
        ret = fgets(cmdline, MAXLINE, stdin);
        if (feof(stdin) || ret == NULL)
            exit(0);

        /* Evaluate */
        eval(cmdline);
    }
}
