#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <time.h>
#include "SiSoSil1_Final_1.h"
#define NUMBER_OF_DECK 4

typedef struct myNode {
	int val;//ī������. 4�� ������ �� ���� ����, �������� ������
	struct myNode* next;
	struct myNode* prev;
}Node;

typedef struct myHead {
	Node* first;
	Node* last;
}Head;

typedef struct myPlayer {
	Node* card;//���� ������ �ִ� �д� ���Ḯ��Ʈ�� ����
	int cur;//���� ī���� �� ����������
	int money;//�����ڱ� ������
}Player;

//idx%13�� 0�̸� 1�̹Ƿ� �ϴ� 11���, 1�̸� 2, ... 9�̸� 10, 10�̸� J, 11�̸� Q, 12�� K
int deck[NUMBER_OF_DECK * 13];//spade, heart, diamond, clover, ���ڴ� idx%14
int N;
int Round;
Player** Gamers;//0: ����, 1: �÷��̾�, 2,3,4...: �ΰ�����

Head* create_head() {
	Head* new_head = (Head*)malloc(sizeof(Head));
	new_head->first = NULL;
	new_head->last = NULL;
	return new_head;
}
Node* create_node(int val) {
	Node* new_node = (Node*)malloc(sizeof(Node));
	new_node->val = val;
	new_node->next = NULL;
	return new_node;
}
void add(Head* head, int val) {
	if (head->last == NULL) {
		head->last = create_node(val);
		head->first = head->last;
	}
	else {
		Node* p = head->last;
		p->next = create_node(val);
		head->last = p->next;
	}
}
Node* find(Head* head, int val) {
	Node* cur = head->first;
	while (cur != NULL) {
		if (cur->val == val)
			return cur;
		else cur = cur->next;
	}
	return NULL;
}
Node* removing(Head* head, int val) {
	if (head->first == NULL){//empty
		return NULL;
	}
	Node* cur = head->first;
	if (cur->val == val) {//ù���һ���
		head->first = cur->next;
		cur->next = cur->next->next;
		free(cur);
		return NULL;
	}
	while (cur->next != NULL) {
		if (cur->next->val == val) {
			Node* nxtnxt = cur->next->next;
			free(cur->next);
			cur->next = nxtnxt;
			return NULL;
		}
		else cur = cur->next;
	}
	return NULL;
}

void printCard(const Player* p) {//�� �÷��̾ ���� ������ �ִ� ī�带 ��� ������. ���Ḯ��Ʈ ��ȸ

}

int playerAI(const Player* p) {//1�̸� ��, 0�̸� ����
	if (p->cur<14) {//14�̸��̸� ������ ��
		return 1;
	}
	else if (p->cur > 17) {//17�ʰ��� ������ ����
		return 0;
	}
	else {//���̰��̸� �ݹ�
		int go = rand() % 2;
		if (go) {
			return 1;
		}
		else {
			return 0;
		}
	}
}

int dealerAI(const Player* p) {//1�̸� ��, 0�̸� ����
	if (p->cur <= 16) {//���� 16�� ���ϸ� ��, �ʰ��� ����
		return 1;
	}
	else {
		return 0;
	}
}

void resetDeck() {//�� �ٽ� �� ä���ֱ�, �����õ尪 �ʱ�ȭ
	memset(deck, 0, sizeof(deck));
	srand((unsigned int)time(NULL));
}

int isDepleted(int n) {//n�� �ε����� ���Ǿ�����?
	if (deck[n] == NUMBER_OF_DECK) return 1;//yes, it is depleted
	else return 0;//no, it still exists
}

int getNum(int n) {//n�� �ε����� ���ڸ� �߷�����.
	n %= 13;
	if (n == 0) {
		return 11;
	}
	else if (n >= 9) {
		return 10;
	}
	else {
		return n + 1;
	}
}

int getCard() {
	int card;
	while (1) {//�÷��̾� �� �����, ���� ��� ���� ���� ���� ����.
		card = rand();
		card %= NUMBER_OF_DECK * 13;	
		if (isDepleted) continue;
		else break;
	}
	return card;
}

void aRound() {//�� ����. �÷��̾� 1,2,3,4�� �����ϰ�, ������ �����ϸ� �� ���� ������.
	/*
	1. ������ �� �ο����� 2�徿 ������. ������ 1���� �������.
	2. ������ ���� 2���� 21�̸� �������. �� ���, �������� ��ġ�� �����й�.
	3. ���ʺй� ����, �÷��̾� 1���� �������� ���� �Ǻ��� �ϴµ�, 21�ʰ��� ����Ʈ���� �������� �����Ǹ� �й�Ȯ��
	4. ����Ʈ �Ǵ� ���ĵ�(=����) �ϸ� �����÷��̾�� �Ѿ
	5. ������ �÷��̾��� ���� ���� ���, ������ �ڽ��� �����Ǻ��� ��.
	6. ������ ���� ����, ������ �÷��̾�� ���º�, �ƴ� �÷��̾�� �й�Ȯ��
	7. ������ 21 �ʰ�(=����Ʈ)�ϸ�, ��� �÷��̾ �¸�(����Ʈ�� �÷��̾��??????)
	8. ������ 21 �̸��̸�, 21�� �� ����� �÷��̾ �¸�, �ƴϸ� �й�, �Ÿ��� ������ ���º�
	9. 10,J,K,Q�� ���� 10���� ���, A�� 11�� ��������� ī�带 �� �޾� 21 �ʰ��ϸ� 1�� ���
	10. ��� �����ڰ� ���ĵ� �Ǵ� ����Ʈ�Ǹ� �������
	11. ���� �����, ���ܵ� ī�带 ���ܵ� ä�� �����Ͽ� �������� ����
	12. ���� ī�尡 ����+�÷��̾� ���� 5�躸�� ������ ��������
	13. �÷��̾�� �ִ� 6��, �������� 7��
	14. ���� �̱�� 100��, �����̸� 200��, �й��ϸ� -100��, �������� ����
	*/

}

void startPlay() {
	resetDeck();
	while (1) {
		Round++;
		printf("Round %d Starts Now\n", Round);
		aRound();
	}
}

int main() {
	printf("Number of Players: ");
	scanf("%d", &N);
	Gamers = (Player**)malloc(sizeof(Player*) * (N + 1));
	for (int i = 0; i <= N; i++) {
		Gamers[i] = (Player*)malloc(sizeof(Player));
	}



	free(Gamers);
	return 0;
}