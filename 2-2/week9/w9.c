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
    key_t sender_k = ftok(".", 1);
    int qid = msgget(sender_k, IPC_CREAT | 0660);
    if (qid == -1) {
        perror("msgget error : ");
        exit(1);
    }

    /* 자식: 리시버 */
    pid_t child_pid = fork();
    int status;
    if (child_pid == 0) {
        while (1) {
            ssize_t st1, st2;
            struct msg buf;
            struct msg_ack read_time;
            st1 = msgrcv(qid, &buf, sizeof(buf) - sizeof(long), uid, IPC_NOWAIT);
            if (st1 > 0) {
                // printf("%d\n", receiver_id);
                read_time.msgtype = receiver_id + 1000;
                if (strcmp(buf.text, "quit") == 0) {
                    read_time.tt = 0;
                    msgsnd(qid, &read_time, sizeof(read_time) - sizeof(long), 0);
                    // printf("Child terminated1\n");
                    printf("quit\n");
                    exit(0);
                } else {
                    printf("RECEIVED %s\n", buf.text);
                    time(&(read_time.tt));
                    if (msgsnd(qid, &read_time, sizeof(read_time) - sizeof(long), 0) == -1) {
                        perror("msgsnd error4444 : ");
                        exit(1);
                    }
                }
            }

            st2 = msgrcv(qid, &read_time, sizeof(read_time) - sizeof(long), uid + 1000, IPC_NOWAIT);
            if (st2 > 0) {
                if (read_time.tt == 0) {
                    // printf("Child terminated2\n");
                    exit(0);
                }
                printf("%d read message at :\t%s", receiver_id, ctime(&(read_time.tt)));  //맞나?
            }
        }
    } else { /* 부모: Sender */
        while (1) {
            waitpid(child_pid, &status, WNOHANG);
            if (WIFEXITED(status)) {
                // printf("Parent terminated due to child\n");
                exit(0);
            }
            struct msg buf;
            buf.msgtype = receiver_id;
            gets(buf.text);

            if (msgsnd(qid, &buf, sizeof(buf) - sizeof(long), 0) == -1) {
                perror("msgsnd error33333 : ");
                exit(1);
            }
            if (strcmp(buf.text, "quit") == 0) {
                // wait(NULL);
                waitpid(child_pid, &status, 0);
                if (WIFEXITED(status)) {
                    // printf("Parent terminated\n");
                    exit(0);
                }
            }
        }
    }

    return 0;
}