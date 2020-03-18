#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <unistd.h>

void error_handling(char* message){
    fputs(message, stderr);
    fputc('\n',stderr);
    exit(1);
}

int main(int argc, char* argv[]){
    if(argc!=3){
        printf("잘못된 인수입니다");
        exit(1);
    }
    int clnt_sock;
    struct sockaddr_in serv_addr;
    int message_len;
    char message[30];

    clnt_sock=socket(PF_INET, SOCK_STREAM, 0);
    if(clnt_sock==-1)
        error_handling("socket() error");
    
    memset(&serv_addr, 0, sizeof(serv_addr));
    serv_addr.sin_family=AF_INET;
    serv_addr.sin_addr.s_addr=inet_addr(argv[1]);
    serv_addr.sin_port=htons(atoi(argv[2]));

    if(connect(clnt_sock, (struct sockaddr*) &serv_addr, sizeof(serv_addr))==-1)
        error_handling("connect() error");
    
    message_len=read(clnt_sock, message, sizeof(message)-1);
    if(message_len==-1)
        error_handling("read() error");
    printf("Message from the server : %s", message);
    close(clnt_sock);
    return 0;

}