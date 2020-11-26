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
    int n, cfd;
    struct hostent* h;
    struct sockaddr_in saddr;

    char* host = argv[1];
    int port = atoi(argv[2]);

    if ((cfd = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
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
    if (connect(cfd, (struct sockaddr*)&saddr, sizeof(saddr)) < 0) {
        perror("connect() failed: ");
        exit(3);
    }
    while (1) {
        // printf("NEW LOOP\n");
        char buf[MAXLINE];
        char path[50];
        char filename[50];
        scanf("%s", filename);
        strcpy(path, filename);
        // printf("path: \'%s\'\n", path);

        if (0 == strcmp("quit", path)) {
            printf("quit\n");
            n = write(cfd, path, sizeof(path));
            // close(cfd);
            exit(0);
        }

        int fdr = open(path, O_RDWR, 0644);
        if (fdr < 0) {
            perror("OPEN ERROR");
            exit(1);
        }

        // printf("here\n");

        // printf("here2\n");
        n = write(cfd, path, sizeof(path));
        memset(buf, 0, MAXLINE);
        // printf("write complete\n");

        while ((n = read(fdr, buf, MAXLINE)) > 0) {
            // printf("small loop looping\n");
            printf("TRANSMISSING: \'%s\'\n", buf);
            int nn = write(cfd, buf, n);
            if (nn < 0) {
                perror("write error: ");
            }
            printf("Send %d bytes to server.\n", n);
            printf("Send %d bytes to server.\n", nn);
            memset(buf, 0, MAXLINE);
        }
        // close(cfd);
        close(fdr);
        // printf("LOOP END\n");
    }
    // close(cfd);
}