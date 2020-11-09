#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <syslog.h>
#include <time.h>
#include <unistd.h>

int main() {
    // setlogmask(LOG_MASK(LOG_EMERG));
    // openlog("lpd", LOG_PID, LOG_LPR);
    // syslog(LOG_EMERG, "Error");
    // syslog(LOG_INFO, "Logging");
    // closelog();

    char cmd[] = "echo test test test";
    char cmd2[] = "echo test test test >> output.txt";
    execl("/bin/bash", "/bin/bash", "-c", cmd2, NULL);  // 이름이랑 pathname
    //-c 옵션 뒤에는 문자열 1개밖에 안받으므로 유의
    //즉, execl("/bin/bash", "-c", "ls", "NULL"); 처럼 쓰면 안된다는 말이다.

    return 0;
}