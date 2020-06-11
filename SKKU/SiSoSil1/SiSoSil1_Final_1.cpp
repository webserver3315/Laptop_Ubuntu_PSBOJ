#include <bits/stdc++.h>
#define NUMBER_OF_DECK 4
using namespace std;

typedef struct myCard {
    int val;
    struct myCard* next;
    struct myCard* prev;
} Card;

typedef struct myHuman {
    vector<int> deck;
    int motteruCard;  //���� ���忡�� �������� ī���
    int Score;
    bool isDealer;  //��������
} Human;

int N;             //�÷��̾� ��. ���������� �� N+1�� ����.
int deck[4 * 13];  //0�� ���̽�, 1�� 2, ..., 9�� 10, 10�� ��, 11�� ��, 12�� ŷ, ���� �����̵� ��Ʈ ���̾� Ŭ�ι���
int nokoriCardCnt = 208;
int Round;
Human player[7];  //0���� ����, 1���� �÷��̾�

int getCard() {
    if (nokoriCardCnt == 0) return -1;
    int card;
    while (1) {  //�÷��̾� �� �����, ���� ��� ���� ���� ���� ����.
        card = rand();
        card %= NUMBER_OF_DECK * 13;
        if (deck[card])
            break;
        else if (nokoriCardCnt == 0)
            break;
        else
            break;
    }
    nokoriCardCnt--;  //�� �� ����
    return card;
}

void PunPai() {                     //ī�� �ʱ� �й�
    for (int i = 0; i <= N; i++) {  //���ڿ��� ī����
        if (nokoriCardCnt) {
            int c1 = getCard();
            player[i].deck.push_back(c1);
            player[i].motteruCard++;
        }
        if (nokoriCardCnt) {
            int c2 = getCard();
            player[i].deck.push_back(c2);
            player[i].motteruCard++;
        }
    }
}

int getCardPoint(const Human& h) {
    int ret = 0;
    int aceNum = 0;
    for (int i = 0; i < h.deck.size(); i++) {
        int cur = h.deck[i];
        int pict = cur / 4;
        int num = cur % 14;
        if (num == 0) {
            aceNum++;
            ret++;
        } else if (num >= 10) {
            ret += 10;
        } else {
            ret += num + 1;
        }
    }
    while (aceNum) {          //10 a a a �� ��, �׸����ϰ� 10 10 a a �ߴٰ��� �������. ���� 1�� �� ���ϰ� ���Ŀ� 9 ������.
        if (ret + 9 <= 21) {  //9���ص� ��Ƽ�� a �ϳ��� 10���� ��Ƣ��.
            ret += 9;
            aceNum--;
        } else
            break;
    }
    return ret;
}

string translate(int i) {
    string ret;
    if (i / 4 == 0) {
        ret += "Spade ";
    } else if (i / 4 == 1) {
        ret += "Heart ";
    } else if (i / 4 == 2) {
        ret += "Diamond ";
    } else if (i / 4 == 3) {
        ret += "Clover ";
    }
    ret += to_string(i % 13);
    cout << ret;
}

void ShowCard() {
    for (int i = 0; i <= N; i++) {
        cout << i << " �� �÷��̾��� �и� ��ڽ��ϴ�~" << endl;
        if (player[i].isDealer) {
            cout << "[����Ư��: ù°ī�� Censored]" << endl;
            for (int j = 1; j < player[i].deck.size(); j++) {
                //cout << player[i].deck[j] << endl;
                cout << translate(player[i].deck[j]) << endl;
            }
        } else {
            for (int j = 0; j < player[i].deck.size(); j++) {
                //cout << player[i].deck[j] << endl;
                cout << translate(player[i].deck[j]) << endl;
            }
        }
    }
    cout << endl;
}

void DrawEveryone() {
    int hit = 1;
    int i = 1;
    while (1) {  //�÷��̾�
        cout << "hit �Ϸ��� 1��, stand �Ϸ��� 0�� �Է��ϼ���" << endl;
        cin >> hit;
        if (!hit) break;
        int cur = getCard();
        if (cur == -1) {
            cout << "�� ��!!!" << endl;
            break;
        } else {
            player[i].deck.push_back(cur);
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
    for (i = 2; i <= N; i++) {                  //�ΰ�����_��Ʈ? ���ĵ�?
        while (getCardPoint(player[i]) < 14) {  //14�̸��� ������ hit
            int cur = getCard();
            if (cur == -1) {
                cout << "�� ��!!!" << endl;
                break;
            } else {
                player[i].deck.push_back(cur);
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
        if (getCardPoint(player[i]) <= 17) {  //14~17�̸� ����Ȯ�� ��Ʈ
            hit = rand() % 2;
            if (hit) {
                int cur = getCard();
                if (cur == -1) {
                    cout << "�� ��!!!" << endl;
                } else {
                    player[i].deck.push_back(cur);
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
            continue;  //17 �ʰ��� ������ ����
    }
    i = 0;                                  //����
    while (getCardPoint(player[i]) < 17) {  //16 ���ϴ� ������ hit
        int cur = getCard();
        if (cur == -1) {
            cout << "�� ��!!!" << endl;
            break;
        } else {
            player[i].deck.push_back(cur);
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
}

void Kaikei() {                          //���
    if (getCardPoint(player[0]) > 21) {  //������ ����Ʈ��
        for (int i = 1; i <= N; i++) {
            if (getCardPoint(player[i]) > 21) {
                player[i].Score -= 100;
            } else if (getCardPoint(player[i]) == 21) {
                player[i].Score += 200;
            } else {
                player[i].Score += 100;
            }
        }
    } else if (getCardPoint(player[0]) == 21) {  //������ �����̸�
        for (int i = 1; i <= N; i++) {
            if (getCardPoint(player[i]) > 21) {
                player[i].Score -= 100;
            } else if (getCardPoint(player[i]) == 21) {  //���
                continue;
            } else {
                player[i].Score -= 100;
            }
        }
    } else {  //������ ��Ÿ��
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
}

void startRound() {
    Round++;
    cout << "This Round is" << Round << endl;
    PunPai();
    ShowCard();
    DrawEveryone();
    Kaikei();
}

void endRound() {
    for (int i = 0; i <= N; i++) {
        player[i].deck.clear();
        player[i].motteruCard = 0;
    }
}

int main() {
    cout << "Number of Players: " << endl;
    cin >> N;
    for (int i = 0; i < 4 * 14; i++) {
        deck[i] = NUMBER_OF_DECK;  //������ 52���ε�, �̰͵��� 4�徿 ����.
    }
    for (int i = 0; i <= N; i++) {
        if (i == 0) {
            player[i].isDealer = true;
            //�������� ���ھ�� ���ǹ�������..
        } else {
            player[i].isDealer = false;
        }
        player[i].motteruCard = 0;
        player[i].Score = 500;  //500�� �ʱ��ں����� �ְ� ��������
    }

    while (nokoriCardCnt >= (N + 1) * 5) {
        startRound();
    }

    return 0;
}