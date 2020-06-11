#include <bits/stdc++.h>
#define NUMBER_OF_DECK 4
using namespace std;

typedef struct myCard {
    int val;
    struct myCard* next;
    struct myCard* prev;
} Card;

typedef struct myHuman {
    vector<int> hold;
    int motteruCard;  //현재 라운드에서 소유중인 카드수
    int Score;
    bool isDealer;  //딜러여부
} Human;

int N;             //플레이어 수. 딜러있으니 총 N+1명 참전.
int deck[4 * 13];  //0은 에이스, 1은 2, ..., 9는 10, 10은 잭, 11는 퀸, 12은 킹, 몫은 스페이드 하트 다이아 클로버순
int nokoriCardCnt = 208;
int Round;
Human player[7];  //0번은 딜러, 1번은 플레이어

void printScore() {
    cout << "------SCORE---------" << endl;
    for (int i = 1; i <= N; i++) {
        cout << "Player " << i << " : " << player[i].Score << endl;
    }
    cout << "---------SCORE END--------" << endl;
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
            player[i].hold.push_back(c1);
            player[i].motteruCard++;
        }
        if (nokoriCardCnt) {
            int c2 = getCard();
            player[i].hold.push_back(c2);
            player[i].motteruCard++;
        }
    }
}

int getCardPoint(const Human& h) {
    int ret = 0;
    int aceNum = 0;
    for (int i = 0; i < h.hold.size(); i++) {
        int cur = h.hold[i];
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

string translate(int i) {
    string ret = "";
    if (i / 13 == 0) {
        ret += "Spade ";
    } else if (i / 13 == 1) {
        ret += "Heart ";
    } else if (i / 13 == 2) {
        ret += "Diamond ";
    } else if (i / 13 == 3) {
        ret += "Clover ";
    }

    int num = (i % 13) + 1;
    if (num == 1) {
        ret += "A";
    } else if (num == 11) {
        ret += "J";
    } else if (num == 12) {
        ret += "Q";
    } else if (num == 13) {
        ret += "K";
    } else {
        ret += to_string((i % 13) + 1);
    }
    // cout << ret;
    return ret;
}

void ShowCard(int hide) {
    cout << "----------SHOW CARD------------" << endl;
    for (int i = 0; i <= N; i++) {
        cout << "Player " << i << "'s Cards : ";
        if (player[i].isDealer) {
            if (hide)
                cout << "(뒤집어져 안보임), ";
            else
                cout << translate(player[i].hold[0]) << ", ";
            for (int j = 1; j < player[i].hold.size(); j++) {
                cout << translate(player[i].hold[j]) << ", ";
            }
        } else {
            for (int j = 0; j < player[i].hold.size(); j++) {
                cout << translate(player[i].hold[j]) << ", ";
            }
        }
        cout << endl;
    }
    cout << "----------SHOW CARD END------------" << endl;
    cout << endl;
}

void DrawEveryone() {
    int hit = 1;
    int i = 1;
    while (1) {  //플레이어
        ShowCard(1);
        cout << "hit 하려면 1을, stand 하려면 0을 입력하세요" << endl;
        cin >> hit;
        if (!hit) break;
        int cur = getCard();
        if (cur == -1) {
            cout << "덱 고갈!!!" << endl;
            break;
        } else {
            player[i].hold.push_back(cur);
            player[i].motteruCard++;
            cout << "Drawed " << translate(cur) << endl;
            if (getCardPoint(player[i]) == 21) {
                cout << "BlackJack!!!" << endl;
                break;
            } else if (getCardPoint(player[i]) > 21) {
                cout << "Bust!!!!!!!!!!" << endl;
                break;
            }
        }
    }
    for (i = 2; i <= N; i++) {                  //인공지능_히트? 스탠드?
        while (getCardPoint(player[i]) < 14) {  //14미만은 무조건 hit
            int cur = getCard();
            if (cur == -1) {
                cout << "덱 고갈!!!" << endl;
                break;
            } else {
                player[i].hold.push_back(cur);
                player[i].motteruCard++;
                if (getCardPoint(player[i]) == 21) {
                    cout << "BlackJack!!!" << endl;
                    break;
                } else if (getCardPoint(player[i]) > 21) {
                    cout << "Bust!!!!!!!!!!" << endl;
                    break;
                } else {
                    cout << "Drawed " << cur << endl;
                }
            }
        }
        if (getCardPoint(player[i]) <= 17) {  //14~17이면 절반확률 히트
            hit = rand() % 2;
            if (hit) {
                int cur = getCard();
                if (cur == -1) {
                    cout << "덱 고갈!!!" << endl;
                } else {
                    player[i].hold.push_back(cur);
                    player[i].motteruCard++;
                    if (getCardPoint(player[i]) == 21) {
                        cout << "BlackJack!!!" << endl;
                    } else if (getCardPoint(player[i]) > 21) {
                        cout << "Bust!!!!!!!!!!" << endl;
                    } else {
                        cout << "Drawed " << cur << endl;
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
            cout << "덱 고갈!!!" << endl;
            break;
        } else {
            player[i].hold.push_back(cur);
            player[i].motteruCard++;
            if (getCardPoint(player[i]) == 21) {
                cout << "BlackJack!!!" << endl;
                break;
            } else if (getCardPoint(player[i]) > 21) {
                cout << "Bust!!!!!!!!!!" << endl;
                break;
            } else {
                cout << "Drawed " << cur << endl;
            }
        }
    }
    cout << "-------이번 라운드 카드패 최종결과--------" << endl;
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
    cout << "-------------이번라운드 결과-------------" << endl;
    for (int i = 1; i <= N; i++) {
        if (kekka[i] == 0) {
            cout << "Player " << i << " Stood!" << endl;
        } else if (kekka[i] == 1) {
            cout << "Player " << i << " is BlackJack!!!!!!!!" << endl;
        } else if (kekka[i] == 2) {
            cout << "Player " << i << " has been Busted..." << endl;
        }
    }
    int i = 0;
    if (kekka[i] == 0) {
        cout << "Dealer "
             << "Stood!" << endl;
    } else if (kekka[i] == 1) {
        cout << "Dealer "
             << " is BlackJack !!!!!!!!" << endl;
    } else if (kekka[i] == 2) {
        cout << "Dealer " << i << " has been Busted..." << endl;
    }
}

void endRound() {
    for (int i = 0; i <= N; i++) {
        player[i].hold.clear();
        player[i].motteruCard = 0;
    }
}

void startRound() {
    Round++;
    cout << "This Round is " << Round << endl;
    printScore();
    PunPai();
    DrawEveryone();
    Kaikei();
    endRound();
}

int main() {
    srand((unsigned int)time(NULL));
    cout << "Number of Players: " << endl;
    cin >> N;
    for (int i = 0; i < 4 * 13; i++) {
        deck[i] = NUMBER_OF_DECK;  //덱마다 52장인데, 이것들이 4장씩 있음.
    }
    for (int i = 0; i <= N; i++) {
        if (i == 0) {
            player[i].isDealer = true;  //딜러에게 스코어는 무의미하지만..
        } else {
            player[i].isDealer = false;
        }
        player[i].motteruCard = 0;
        player[i].Score = 500;  //500점 초기자본으로 주고 시작하자
    }

    while (nokoriCardCnt >= (N + 1) * 5) {
        startRound();
    }

    return 0;
}