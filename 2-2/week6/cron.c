#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <syslog.h>
#include <time.h>
#include <unistd.h>
#include <wait.h>

#define MAX_LENGTH 128 * 1024
#define MAX_WORD 128

//Simple Cron Daemon

int get_string_from_fd(int fd, char* dest) {  // fd로부터 개행까지 읽어온 뒤 개행은 빼고, dest에 덮어씀
    int rd_bytes;
    char c;
    int col = 0;
    dest[0] = 0;                                //empty array
    while (0 < (rd_bytes = read(fd, &c, 1))) {  // \n 없이 전부 읽고 저장하기
        dest[col++] = c;
        if (c == '\n') {
            dest[col++] = '\0';
            break;
        }
    }
    return strlen(dest);
}

int main(void) {
    int pid;
    int fdcron, fdin, fdout, fderr;

    if ((pid = fork()) < 0)
        exit(1);

    if (pid != 0)
        exit(0);

    if (setsid() < 0 || chdir("/") < 0)
        exit(1);

    umask(0);

    close(STDIN_FILENO);
    close(STDOUT_FILENO);
    close(STDERR_FILENO);

    fdin = open("/dev/null", O_RDWR);
    fdout = open("/dev/null", O_RDWR);
    fderr = open("/dev/null", O_RDWR);

    char* text_line = malloc(MAX_LENGTH);
    char* result = malloc(MAX_WORD);
    char* command = malloc(512);
    int cnt = 0;
    while (1) {
        // printf("\n\n\n");
        if ((fdcron = open("/etc/simplecrontab", O_RDONLY)) < 0) {
            syslog(LOG_ERR, "simplecrontab open error");
            exit(1);
        }
        cnt++;

        time_t timer = time(NULL);
        struct tm* tm = localtime(&timer);
        int cur_min = tm->tm_min;
        int cur_hour = tm->tm_hour;
        int exec_min, exec_hour;

        while (0 < get_string_from_fd(fdcron, text_line)) {
            if (text_line[0] == '\n') continue;
            int tmp;
            result = strtok(text_line, " \n");
            // printf("1st rst: \'%s\'\n", result);
            if (0 == strcmp(result, "*")) {
                exec_min = -1;
            } else {
                exec_min = atoi(result);
            }

            result = strtok(NULL, " \n");
            // printf("2nd rst: \'%s\'\n", result);
            if (0 == strcmp(result, "*")) {
                exec_hour = -1;
            } else {
                exec_hour = atoi(result);
            }

            // printf("%d %d %d %d\n", exec_min, exec_hour, cur_min, cur_hour);
            if (exec_min != -1) {
                if (exec_min != cur_min) {
                    continue;
                }
            }
            if (exec_hour != -1) {
                if (exec_hour != cur_hour) {
                    continue;
                }
            }

            int n = 0;

            command[0] = '\0';
            while (result != NULL) {
                result = strtok(NULL, " \n");
                // printf("result is %s\n", result);
                if (result != NULL) {
                    strcat(command, result);
                    // printf("command is %s\n", command);
                    strcat(command, " ");
                }
                n++;
            }
            // printf("command is %s\n", command);
            // printf("thisthis\n");

            int childpid;
            if (0 == (childpid = fork())) {
                // printf("%d Kid Process Born!\n", cnt);
                execl("/bin/bash", "/bin/bash", "-c", command, NULL);
                free(text_line);
                free(result);
                free(command);
                // close(fdcron);
                exit(0);
            } else {
                int status;
                pid_t wpid = waitpid(-1, &status, WNOHANG);
                // printf("%d Parent Process Dead!\n", cnt)
                // close(fdcron);
            }
        }

        close(fdcron);
        sleep(60);
    }
    free(text_line);
    free(result);
    free(command);
    return 0;
}