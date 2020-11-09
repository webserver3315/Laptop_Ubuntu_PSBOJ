#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/msg.h>
#include <sys/shm.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

struct msg {
    long msgtype;
    /* implement here */
    char text[512];
};

struct msg_ack {
    long msgtype;
    /* implement here */
    time_t tt;
};

int main() {
    /* 
	 * @ int uid: user ID
	 * @ int receiver_id: receiver's ID
	 */
    int uid;
    int receiver_id;

    printf("my id is \n");
    scanf("%d", &uid);
    getchar();  // flush

    printf("who to send ? \n");
    scanf("%d", &receiver_id);
    getchar();  // flush

    /* code to get key and QID */
    /*
	 * @ insert code here from
	 * @ .
	 * @ .
	 * @ here
	 */

    key_t sender_k = ftok(".", uid);
    int qid = msgget(sender_k, IPC_CREAT | 0660);
    if (qid == -1) {
        perror("msgget error : ");
        exit(1);
    }

    key_t receiver_k = ftok(".", receiver_id);
    // struct msg* buf = malloc(sizeof(struct msg));
    // struct msg_ack* time_buf = malloc(sizeof(struct msg_ack));

    /*
    동작은 간단하다.
    상대방으로부터 메시지를 receive 한 경우, 메시지 출력후 시간을 send하면 된다.
    부모측에서 string 을 받은 경우, string 을 send 하면 된다.
    메시지가 아니라 시간을 receive 한 경우, 메시지만 출력하면 된다.
    즉 수신자에 if 가 있고 구별해서 받아야 한다.
    끝.

    부모발 메시지=부모uid+1000
    자식발 메시지=부모uid+2000
    자식발 시간=자식uid+1000
    부모발 시간=자식uid+2000(필요한가...?)
    */

    /* 자식: 리시버 */
    if (fork() == 0) {
        while (1) {
            /* get msg from queue and print out */
            ssize_t st1, st2;
            struct msg buf;
            struct msg_ack read_time;
            st1 = msgrcv(qid, &buf, sizeof(struct msg), uid, IPC_NOWAIT);
            if (st1 == -1) {
                perror("msgrsv error11111 : ");
                exit(1);
            } else if (st1 > 0) {
                printf("%d\n", receiver_id);
                printf("RECEIVED %s\n", buf.text);

                struct msg_ack t;
                t.msgtype = receiver_id + 1000;
                time(&(t.tt));
                if (msgsnd(qid, &read_time, sizeof(struct msg_ack), 0) == -1) {
                    perror("msgsnd error4444 : ");
                    exit(1);
                }
            }

            st2 = msgrcv(qid, &read_time, sizeof(struct msg_ack), uid + 1000, IPC_NOWAIT);
            if (st2 <= -1) {
                perror("msgrsv error22222 : ");
                exit(1);
            } else if (st2 > 0) {
                printf("%d read message at : %s", receiver_id, ctime(read_time.tt));  //맞나?
            }
        }
    } else { /* 부모: Sender */
        while (1) {
            /* get user input and send to the msg queue */
            struct msg buf;
            // getline(buf->text, 512, stdin);
            // scanf("%s", buf->text);

            buf.msgtype = receiver_id;
            if (msgsnd(qid, &buf, sizeof(struct msg), 0) == -1) {
                perror("msgsnd error33333 : ");
                exit(1);
            }
        }
    }

    return 0;
}
