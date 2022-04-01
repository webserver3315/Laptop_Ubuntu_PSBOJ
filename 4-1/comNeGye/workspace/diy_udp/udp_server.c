
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#define MYBUF 30

void error_handling(char *message)
{
    fputs(message, stderr);
    fputc('\n', stderr);
    exit(1);
}

int main(int argc, char* argv[]){
    if(argc!=2){
        error_handling("잘못된 인수입니다");
    }
    int serv_sock;
    char message[MYBUF];
    int str_len;
    socklen_t clnt_addr_siz;
    struct sockaddr_in serv_addr, clnt_addr;
    
    serv_sock=socket(PF_INET, SOCK_DGRAM, 0);
    if(serv_sock==-1)
        error_handling("socket() error");
    memset(&serv_addr, 0, sizeof(serv_addr));
    serv_addr.sin_family=AF_INET;
    serv_addr.sin_addr.s_addr=htonl(INADDR_ANY);
    serv_addr.sin_port=htons(atoi(argv[1]));

    if(bind(serv_sock, (struct sockaddr*)&serv_addr, sizeof(serv_addr))==-1)
        error_handling("bind() error");
    
    while(1){
        clnt_addr_siz=sizeof(clnt_addr);
        str_len=recvfrom(serv_sock, message, MYBUF, 0, (struct sockaddr*)&clnt_addr, &clnt_addr_siz);
        sendto(serv_sock, message, str_len, 0, (struct sockaddr*)&clnt_addr, clnt_addr_siz);
    }
    close(serv_sock);
    return 0;
}
