#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <unistd.h>
#define MYBUF 30

void error_handling(char *message)
{
    fputs(message, stderr);
    fputc('\n', stderr);
    exit(1);
}

int main(int argc, char* argv[]){
    if(argc!=3){
        error_handling("부적절한 인수입니다");
    }
    
    int sock;
    char message[MYBUF];
    int str_len;
    socklen_t addr_siz;
    struct sockaddr_in serv_addr, from_addr;

    sock=socket(PF_INET, SOCK_DGRAM, 0);
    if(sock==-1)
        error_handling("socket() error");
    memset(&serv_addr, 0, sizeof(serv_addr));
    serv_addr.sin_family=AF_INET;
    // serv_addr.sin_addr.s_addr=htonl(atoi(argv[1]));
    serv_addr.sin_addr.s_addr=inet_addr(argv[1]);
    serv_addr.sin_port=htons(atoi(argv[2]));

    while(1){
        fputs("메시지를 입력하세요(종료는 q): ", stdout);
        fgets(message, sizeof(message), stdin);
        if(!strcmp(message, "q\n")||!strcmp(message,"Q\n"))
            break;
        sendto(sock, message, strlen(message), 0, (struct sockaddr*)&serv_addr, sizeof(serv_addr));
        addr_siz=sizeof(from_addr);
        str_len=recvfrom(sock, message, sizeof(message), 0, (struct sockaddr*)&from_addr, &addr_siz);
        message[str_len]=0;
        printf("서버에서 온 메시지: %s\n",message);
    }
    close(sock);
    return 0;
}
