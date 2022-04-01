
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <unistd.h>

#define BUF_SIZE 1024

void error_handling(char* message){
    fputs(message, stderr);
    fputc('\n', stderr);
    exit(1);
}

int main(int argc, char* argv[]){
    if(argc!=2){
        puts("잘못된 인수입니다");//Invalid parameter
        exit(1);
    }
    int serv_sock, clnt_sock;
    struct sockaddr_in serv_addr, clnt_addr;
    socklen_t clnt_addr_siz;
    char message[BUF_SIZE];
    int str_len, i;

    serv_sock = socket(PF_INET, SOCK_STREAM, 0);
    if(serv_sock==-1)
        error_handling("socket() error");
    
    memset(&serv_addr, 0, sizeof(serv_addr));
    serv_addr.sin_family=AF_INET;
    serv_addr.sin_addr.s_addr=htonl(INADDR_ANY);
    // serv_addr.sin_port=htons(atoi(argv[2]));//이것때문에 갑자기 세그폴트떠서 당황했다
    serv_addr.sin_port=htons(atoi(argv[1]));

    if(bind(serv_sock, (struct sockaddr*)&serv_addr, sizeof(serv_addr))==-1)
        error_handling("bind() error");

    if(listen(serv_sock, 50)==-1)
        error_handling("listen() error");

    clnt_addr_siz=sizeof(clnt_addr);
    for(i=0;i<5;i++){//최대 5줄까지 전송가능
        //serv_sock 으로의 연결을 대기하다, 연결요청이 들어오면 clnt_sock 이라는 새로운 파일디스크립터를 연다. serv_sock이 수신한 요청자주소는 새로생길 소켓의(==clnt_sock) 파일디스크립터에 새겨지며, 그 크기는 당연히 clnt_addr의 sizeof와 동일하다.
        clnt_sock = accept(serv_sock, (struct sockaddr*)&clnt_addr, &clnt_addr_siz);
        if(clnt_sock==-1)
            error_handling("accept() error");
        else
            printf("%d 번째로 연결된 클라이언트\n", i+1);
        
        int ii=1;
        while((str_len=read(clnt_sock,message,BUF_SIZE))!=0){//read 함수는 읽은 데이터의 바이트크기를 리턴하므로, 얼마나 읽어들였는지를 str_len에 대입하면서 괄호로 감싼 뒤 0과 비교하면 한 번에 원하는 기능을 수행할 수 있다.
            // printf("str_len: %d\n",str_len);
            // printf("%d\n",ii++);
            //clnt_sock "으로" message "를" sizeof(str_len) 만큼 쓴다.
            write(clnt_sock, message, str_len);//BUF_SIZE 아니다!!!
            printf("Repeat: %s",message);
        }
        close(clnt_sock);//볼일끝났으면 닫기. accept 중복선언되면 골치아프다.
    }
    close(serv_sock);
    return 0;
}
