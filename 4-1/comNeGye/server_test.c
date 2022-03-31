#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/socket.h>
void error_handling(char *message);


/*
소켓을 생성하는 과정
>>>#include <sys/socket.h>
1. 전화기 장만 - socket 함수 호출: 소켓 생성
>>>int socket(int domain, int type, int protocol);//성공시 파일 디스크립터를, 실패시 -1 반환
2. 전화번호 부여 - bind 함수 호출: IP 주소 및 PORT 번호 할당
>>>int bind(int sockfd, struct sockaddr *myaddr, socklen_t addrlen);//성공시 0, 실패시 -1 반환
3. 모뎀선 연결 - listen 함수 호출: 연결요청 수신가능상태로 변경
>>>int listen(int sockfd, int backlog); // 성공시 0, 실패시 -1 반환
4. 벨 울리면 수화기 들기 - accept 함수 호출: 연결요청에 대한 수락
>>>int accept(int sockfd, struct sockaddr *addr, socklen_t *addrlen);//성공시 파일디스크립터를, 실패시 -1 반환
*/


/*
참고_리눅스에서의 sockaddr_in 구조체
struct sockaddr_in{
    //short sin_family;
    sa_family_t sin_family;
    unsigned short sin_port;
    struct in_addr sin_addr;
    char sin_zero[c];
}
*/
int main(int argc, char *argv[]){
    int serv_sock;
    int clnt_sock;

    struct sockaddr_in serv_addr;
    struct sockaddr_in clnt_addr;
    socklen_t clnt_addr_size;

    char message[] = "Hello World!";

    if(argc!=2){
        printf("Usage: %s <port>\n",argv[0]);
        exit(1);
    }
    
    serv_sock=socket(PF_INET, SOCK_STREAM, 0);//socket 함수 호출을 통해 소켓을 생성하고 있다.
    if(serv_sock==-1)
        error_handling("socket() error");
    
    memset(&serv_addr, 0, sizeof(serv_addr));
    serv_addr.sin_family=AF_INET;
    serv_addr.sin_addr.s_addr=htonl(INADDR_ANY);
    serv_addr.sin_port=htons(atoi(argv[1]));

    if(bind(serv_sock,(struct sockaddr*) &serv_addr, sizeof(serv_addr))==-1)//bind 함수 호출을 통해서 IP주소와 PORT번호를 할당함과 동시에 에러체크를 병행하고 있다.
        error_handling("bind() error");
    if(listen(serv_sock,5)==-1)//listen 함수 호출을 통해 소켓을 연결요청수신대기상태로 만듦과 동시에 에러체크를 병행하고 있다.
        error_handling("listen() error");
    
    clnt_addr_size=sizeof(clnt_addr);
    clnt_sock=accept(serv_sock, (struct sockaddr*)&clnt_addr, &clnt_addr_size);//연결요청수락을 위해 accept 함수를 호출하고 있다. 연결요청이 없는데 이 함수가 호출되면, 연결요청이 있을 때까지 반환을 하지 않는다.
    if(clnt_sock==-1)//반환 ﻿값을 체크해준다.
        error_handling("accept() error");
    
    write(clnt_sock, message, sizeof(message));//write 함수는 데이터를 전송하는 기능의 함수인데, 이 함수까지 왔다는 것은 연결요청이 실제로 있었다는 뜻이다.
    close(clnt_sock);
    close(serv_sock);
    return 0;
}

void error_handling(char *message){
    fputs(message, stderr);
    fputc('\n',stderr);
    exit(1);
}
