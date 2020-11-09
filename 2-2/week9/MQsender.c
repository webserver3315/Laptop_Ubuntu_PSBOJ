#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/msg.h>

struct msgbuf {
    long msgtype;
    char text[256];
};

int main(void) {
    key_t k = ftok(".", 'a');
    int qid = msgget(k, IPC_CREAT | 0660);
    if (qid == -1) {
        perror("msgget error : ");
        exit(1);
    }
    struct msgbuf* msg = malloc(sizeof(struct msgbuf));
    msg->msgtype = 1;
    getline(msg->text, 256, stdin);
    // strcpy(msg->text, "hello world!\n");

    if ((msgsnd(qid, (void*)msg, sizeof(struct msgbuf), 0) == -1)) {
        perror("msgsnd error: ");
        exit(1);
    }
    free(msg);
    return 0;
}