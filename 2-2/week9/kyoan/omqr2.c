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
    int qid = msgget(k, IPC_EXCL | 0660);
    if (qid == -1) {
        perror("msgget error: ");
        exit(1);
    }
    struct msgbuf* msg = malloc(sizeof(struct msgbuf));
    if (msgrcv(qid, (void*)msg, sizeof(struct msgbuf), 1, 0) == -1) {
        perror("msgrsv error: ");
        exit(1);
    }
    printf("%s", msg->text);
    free(msg);
    return 0;
}