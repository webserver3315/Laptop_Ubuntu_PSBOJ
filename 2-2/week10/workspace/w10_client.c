#include <arpa/inet.h>
#include <fcntl.h>  // O_WRONLY
#include <netdb.h>
#include <stdio.h>  // printf()
#include <stdlib.h>
#include <string.h>  // strlen()
#include <sys/socket.h>
#include <sys/types.h>
#include <unistd.h>  // write(), close()
#define MAXLINE 80

int main(int argc, char* argv[]) {
    int n, sock;
    struct hostent* h;
    struct sockaddr_in saddr;
    char* host = argv[1];
    int port = atoi(argv[2]);

    while (1) {
        if ((sock = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
            printf("socket() faild.\n");
            exit(1);
        }
        if ((h = gethostbyname(host)) == NULL) {
            printf("invalid hostname %s\n", host);
            exit(2);
        }
        memset((char*)&saddr, 0, sizeof(saddr));
        saddr.sin_family = AF_INET;
        memcpy((char*)&saddr.sin_addr.s_addr, (char*)h->h_addr, h->h_length);
        saddr.sin_port = htons(port);
        if (connect(sock, (struct sockaddr*)&saddr, sizeof(saddr)) < 0) {
            perror("connect() failed: ");
            exit(3);
        }

        char buf[MAXLINE];
        char path[50];
        scanf("%s", path);
        n = write(sock, path, strlen(path));  // 이걸 strlen(path) 안하고 MAXLINE 해버려서 문제 발생한듯?

        if (0 == strcmp("quit", path)) {
            // printf("quit\n");
            close(sock);
            exit(0);
        }

        int fdr = open(path, O_RDONLY, 0644);
        if (fdr < 0) {
            perror("OPEN ERROR");
            exit(1);
        }

        while ((n = read(fdr, buf, MAXLINE)) > 0) {
            // printf("small loop looping\n");
            // printf("TRANSMISSING: \'%s\'\n", buf);
            buf[n] = 0;  // 굳이 필요는 없는듯...?
            int nn = write(sock, buf, n);
            if (nn < 0) {
                perror("write error: ");
            }
            // printf("Send %d bytes to server.\n", n);
            printf("Send %d bytes to server.\n", nn);
        }
        close(sock);
        close(fdr);
        // printf("LOOP END\n");
    }
    // close(sock);
}