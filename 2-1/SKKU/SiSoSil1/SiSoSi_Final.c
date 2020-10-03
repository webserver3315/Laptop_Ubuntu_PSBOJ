#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define NUMBER_OF_DECK 4

typedef struct myCard {
    int val;
    struct myCard* next;
} Card;

typedef struct myHold {
    int size;
    Card* first;
    Card* last;
} Hold;

typedef struct myHuman {
    Hold hold;        //패
    int motteruCard;  //현재 라운드에서 소유중인 카드수
    int Score;
    int isDealer;  //딜러여부
} Human;

int N;             //플레이어 수. 딜러있으니 총 N+1명 참전.
int deck[4 * 13];  //0은 에이스, 1은 2, ..., 9는 10, 10은 잭, 11는 퀸, 12은 킹, 몫은 스페이드 하트 다이아 클로버순
int nokoriCardCnt = 208;
int Round;
Human player[7];  //0번은 딜러, 1번은 플레이어

Card* create_node(Card* from, int val) {
    Card* new_node = (Card*)malloc(sizeof(Card));
    new_node->val = val;
    new_node->next = NULL;
    return new_node;
}

int holdIndexAccess(Human h, int idx) {
    Card* cur = h.hold.first;
    for (int i = 0; i < idx; i++) {
        cur = cur->next;
    }
    int ret = cur->val;
    return ret;
}

void holdReset(Human h) {  //h.hold 전부 할당해제 및 크기0으로
    Card* cur = h.hold.first;
    while (cur->next != NULL) {
        Card* before = cur;
        cur = cur->next;
        free(before);
    }
    free(cur);
    h.hold.size = 0;
}

void holdAppend(Human h, int val) {
    Hold head = h.hold;
    if (head.last == NULL) {
        head.last = create_node(NULL, val);
        head.first = head.last;
    } else {
        Card* p = head.last;
        p->next = create_node(head.last, val);
        head.last = p->next;
    }
    h.hold.size++;
}

void printScore() {
    printf("------SCORE---------\n");
    for (int i = 1; i <= N; i++) {
        printf("Player %d : player[i].Score\n");
    }
    printf("---------SCORE END--------\n");
}

int getCard() {
    if (nokoriCardCnt == 0) return -1;
    int card;
    while (1) {  //플레이어 수 관계상, 절대 모든 덱이 고갈날 일은 없다.
        card = rand();
        card %= NUMBER_OF_DECK * 13;
        if (deck[card])
            break;
        else if (nokoriCardCnt == 0)
            break;
        else
            break;
    }
    nokoriCardCnt--;  //한 장 감소
    return card;
}

void PunPai() {                     //카드 초기 분배
    for (int i = 0; i <= N; i++) {  //각자에게 카드배분
        if (nokoriCardCnt) {
            int c1 = getCard();
            // player[i].hold.push_back(c1);
            holdAppend(player[i], c1);
            player[i].motteruCard++;
        }
        if (nokoriCardCnt) {
            int c2 = getCard();
            // player[i].hold.push_back(c2);
            holdAppend(player[i], c2);
            player[i].motteruCard++;
        }
    }
}

int getCardPoint(const Human h) {
    int ret = 0;
    int aceNum = 0;
    for (int i = 0; i < h.hold.size; i++) {
        int cur = holdIndexAccess(h, i);
        int pict = cur / 4;
        int num = cur % 13;
        if (num == 0) {
            aceNum++;
            ret++;
        } else if (num >= 10) {
            ret += 10;
        } else {
            ret += num + 1;
        }
    }
    while (aceNum) {          //10 a a a 일 때, 그리디하게 10 10 a a 했다가는 오버뜬다. 차라리 1씩 다 더하고 추후에 9 더하자.
        if (ret + 9 <= 21) {  //9더해도 버티면 a 하나를 10으로 뻥튀기.
            ret += 9;
            aceNum--;
        } else
            break;
    }
    return ret;
}

char* translate(int i) {
    char *pict, numch;
    if (i / 13 == 0) {
        pict = "Spade ";
    } else if (i / 13 == 1) {
        pict = "Heart ";
    } else if (i / 13 == 2) {
        pict = "Diamond ";
    } else if (i / 13 == 3) {
        pict = "Clover ";
    }

    int num = (i % 13) + 1;
    if (num == 1) {
        numch = "A";
    } else if (num == 11) {
        numch = "J";
    } else if (num == 12) {
        numch = "Q";
    } else if (num == 13) {
        numch = "K";
    } else {
        sprintf(numch, "%d", num);
    }

    char* ret = malloc(strlen(pict) + strlen(numch) + 1);
    strcat(ret, pict);
    strcat(ret, numch);
    return ret;
}

void ShowCard(int hide) {
    printf("----------SHOW CARD------------\n");
    for (int i = 0; i <= N; i++) {
        printf("Player %d's Cards : ");
        if (player[i].isDealer) {
            if (hide)
                printf("(뒤집어져 안보임), ");
            else {
                char* name = translate(holdIndexAccess(player[i], 0));
                printf("%s, ", name);
                free(name);
            }
            for (int j = 1; j < player[i].hold.size; j++) {
                char* name = translate(holdIndexAccess(player[i], j));
                printf("%s, ", name);
                free(name);
            }
        } else {
            for (int j = 0; j < player[i].hold.size; j++) {
                char* name = translate(holdIndexAccess(player[i], j));
                printf("%s, ", name);
                free(name);
            }
        }
        printf("\n");
    }
    printf("----------SHOW CARD END------------\n");
    printf("\n");
}

void DrawEveryone() {
    int hit = 1;
    int i = 1;
    while (1) {  //플레이어
        ShowCard(1);
        printf("hit 하려면 1을, stand 하려면 0을 입력하세요\n");
        scanf("%d", &hit);
        if (!hit) break;
        int cur = getCard();
        if (cur == -1) {
            printf("덱 고갈!!!\n");
            break;
        } else {
            // player[i].hold.push_back(cur);
            holdAppend(player[i], cur);
            player[i].motteruCard++;
            printf("You Drawed %d\n", translate(cur));
            if (getCardPoint(player[i]) == 21) {
                printf("BlackJack!!!\n");
                break;
            } else if (getCardPoint(player[i]) > 21) {
                printf("Bust!!!!!!!!!!\n");
                break;
            }
        }
    }
    for (i = 2; i <= N; i++) {                  //인공지능_히트? 스탠드?
        while (getCardPoint(player[i]) < 14) {  //14미만은 무조건 hit
            int cur = getCard();
            if (cur == -1) {
                printf("덱 고갈!!!\n");
                break;
            } else {
                // player[i].hold.push_back(cur);
                holdAppend(player[i], cur);
                player[i].motteruCard++;
                if (getCardPoint(player[i]) == 21) {
                    printf("Player %d BlackJack!!!\n", i);
                    break;
                } else if (getCardPoint(player[i]) > 21) {
                    printf("Player %d Bust!!!!!!!!!!\n", i);
                    break;
                } else {
                    printf("Player %d Drawed %d\n", i, cur);
                }
            }
        }
        if (getCardPoint(player[i]) <= 17) {  //14~17이면 절반확률 히트
            hit = rand() % 2;
            if (hit) {
                int cur = getCard();
                if (cur == -1) {
                    printf("덱 고갈!!!\n");
                } else {
                    // player[i].hold.push_back(cur);
                    holdAppend(player[i], cur);
                    player[i].motteruCard++;
                    if (getCardPoint(player[i]) == 21) {
                        printf("Player %d BlackJack!!!\n", i);
                    } else if (getCardPoint(player[i]) > 21) {
                        printf("Player %d Bust!!!!!!!!!!\n", i);
                    } else {
                        printf("Player %d Drawed %d\n", i, cur);
                    }
                }
            }
        } else
            continue;  //17 초과는 무조건 손절
    }
    i = 0;                                  //딜러
    while (getCardPoint(player[i]) < 17) {  //16 이하는 무조건 hit
        int cur = getCard();
        if (cur == -1) {
            printf("덱 고갈!!!\n");
            break;
        } else {
            // player[i].hold.push_back(cur);
            holdAppend(player[i], cur);
            player[i].motteruCard++;
            if (getCardPoint(player[i]) == 21) {
                printf("BlackJack!!!\n");
                break;
            } else if (getCardPoint(player[i]) > 21) {
                printf("Bust!!!!!!!!!!\n");
                break;
            } else {
                printf("Drawed %d\n", cur);
            }
        }
    }
    printf("-------이번 라운드 카드패 최종결과--------\n");
    ShowCard(0);
}

void Kaikei() {  //결산
    int kekka[7];
    for (int i = 0; i <= N; i++) {
        if (getCardPoint(player[i]) > 21)
            kekka[i] = 2;
        else if (getCardPoint(player[i]) == 21)
            kekka[i] = 1;
        else {
            kekka[i] = 0;
        }
    }
    if (getCardPoint(player[0]) > 21) {  //딜러가 버스트면
        for (int i = 1; i <= N; i++) {
            if (getCardPoint(player[i]) > 21) {
                player[i].Score -= 100;
            } else if (getCardPoint(player[i]) == 21) {
                player[i].Score += 200;
            } else {
                player[i].Score += 100;
            }
        }
    } else if (getCardPoint(player[0]) == 21) {  //딜러가 블랙잭이면
        for (int i = 1; i <= N; i++) {
            if (getCardPoint(player[i]) > 21) {
                player[i].Score -= 100;
            } else if (getCardPoint(player[i]) == 21) {  //비김
                continue;
            } else {
                player[i].Score -= 100;
            }
        }
    } else {  //딜러가 평타면
        for (int i = 1; i <= N; i++) {
            if (getCardPoint(player[i]) > 21) {
                player[i].Score -= 100;
            } else if (getCardPoint(player[i]) == 21) {
                player[i].Score += 200;
            } else {
                if (getCardPoint(player[0]) < getCardPoint(player[i])) {
                    player[i].Score += 100;
                } else if (getCardPoint(player[0]) > getCardPoint(player[i])) {
                    player[i].Score -= 100;
                }
            }
        }
    }
    printf("-------------이번라운드 결과-------------\n");
    for (int i = 1; i <= N; i++) {
        if (kekka[i] == 0) {
            printf("Player %d Stood!\n", i);
        } else if (kekka[i] == 1) {
            printf("Player %d is BlackJack!!!!!!!!\n", i);
        } else if (kekka[i] == 2) {
            printf("Player %d has been Busted...\n", i);
        }
    }
    int i = 0;
    if (kekka[i] == 0) {
        printf("Dealer Stood!\n");
    } else if (kekka[i] == 1) {
        printf("Dealer is BlackJack !!!!!!!!\n");
    } else if (kekka[i] == 2) {
        printf("Dealer has been Busted...\n");
    }
}

void endRound() {
    for (int i = 0; i <= N; i++) {
        // player[i].hold.clear();
        holdReset(player[i]);
        player[i].motteruCard = 0;
    }
}

void startRound() {
    Round++;
    printf("This Round is %d\n", Round);
    printScore();
    PunPai();
    DrawEveryone();
    Kaikei();
    endRound();
}

int main() {
    srand((unsigned int)time(NULL));
    printf("Number of Players: ");
    scanf("%d", &N);
    for (int i = 0; i < 4 * 13; i++) {
        deck[i] = NUMBER_OF_DECK;  //덱마다 52장인데, 이것들이 4장씩 있음.
    }
    for (int i = 0; i <= N; i++) {
        if (i == 0) {
            player[i].isDealer = 1;  //딜러에게 스코어는 무의미하지만..
        } else {
            player[i].isDealer = 0;
        }
        player[i].motteruCard = 0;
        player[i].Score = 500;  //500점 초기자본으로 주고 시작하자
        player[i].hold.size = 0;
        player[i].hold.first = NULL;
        player[i].hold.last = NULL;
    }

    while (nokoriCardCnt >= (N + 1) * 5) {
        startRound();
    }

    return 0;
}