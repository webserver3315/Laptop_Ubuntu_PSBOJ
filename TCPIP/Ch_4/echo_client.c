#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <unistd.h>
#define BUF_SIZE 1024

void error_handling(char *message)
{
    fputs(message, stderr);
    fputc('\n', stderr);
    exit(1);
}

int main(int argc, char* argv[]){
    if(argc!=3){
        printf("잘못된 인수입니다");//Invalid Parameter
        exit(1);
    }

    int sock;
    struct sockaddr_in serv_addr;
    char message[BUF_SIZE];
    int str_len;

    sock=socket(PF_INET, SOCK_STREAM, 0);
    if(sock==-1)
        error_handling("socket() error");

    memset(&serv_addr,0,sizeof(serv_addr));
    serv_addr.sin_family=AF_INET;
    // serv_addr.sin_addr.s_addr=inet_addr(INADDR_ANY);
    serv_addr.sin_addr.s_addr=inet_addr(argv[1]);
    serv_addr.sin_port=htons(atoi(argv[2]));

    if(connect(sock, (struct sockaddr*)&serv_addr, sizeof(serv_addr))==-1)
        error_handling("connect() error");
    else
        puts("연결됨!");
    
    while(1){
        fputs("전송할 메시지를 입력하시오(종료하려면 Q나 q를 입력하시오) : ",stdout);
        fgets(message, BUF_SIZE, stdin);
        if(!strcmp(message,"Q\n") || !strcmp(message,"q\n"))//strcmp는 equal이면 0을 반환한다!!! >>> 만일 Q나 q가 등장한다면
            break;
        //sock에 메시지를 쓰고, write한 바이트수를 str_len에 기록한다.
        str_len=write(sock, message, BUF_SIZE-1);
        message[str_len]=0;//마지막글자에 문자열임을 표시해야하므로 NULL문자를 붙여준다. char값으로써의 0이므로 \0과 동일하다.
        printf("Message from server: %s\n",message);
    }
    close(sock);//참고로, 이렇게 close함수가 호출되면 상대소켓으로 아무것도 전송 안되는게 아니라, EOF 문자가 마지막으로 전송된다. EOF 는 연결의 끝, 파일의 마지막임을 의미한다.
    return 0;
}