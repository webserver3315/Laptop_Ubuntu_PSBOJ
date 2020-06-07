#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <time.h>
#include "SiSoSil1_Final_1.h"
#define NUMBER_OF_DECK 4

typedef struct myNode {
	int val;//카드종류. 4로 나눴을 때 몫은 문양, 나머지는 숫자임
	struct myNode* next;
	struct myNode* prev;
}Node;

typedef struct myHead {
	Node* first;
	Node* last;
}Head;

typedef struct myPlayer {
	Node* card;//현재 가지고 있는 패는 연결리스트로 구현
	int cur;//현재 카드합 몇 유지중인지
	int money;//보유자금 몇인지
}Player;

//idx%13이 0이면 1이므로 일단 11취급, 1이면 2, ... 9이면 10, 10이면 J, 11이면 Q, 12면 K
int deck[NUMBER_OF_DECK * 13];//spade, heart, diamond, clover, 숫자는 idx%14
int N;
int Round;
Player** Gamers;//0: 딜러, 1: 플레이어, 2,3,4...: 인공지능

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
	if (cur->val == val) {//첫원소삭제
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

void printCard(const Player* p) {//이 플레이어가 현재 가지고 있는 카드를 모두 보여줌. 연결리스트 순회

}

int playerAI(const Player* p) {//1이면 고, 0이면 스톱
	if (p->cur<14) {//14미만이면 무조건 고
		return 1;
	}
	else if (p->cur > 17) {//17초과면 무조건 스톱
		return 0;
	}
	else {//사이값이면 반반
		int go = rand() % 2;
		if (go) {
			return 1;
		}
		else {
			return 0;
		}
	}
}

int dealerAI(const Player* p) {//1이면 고, 0이면 스톱
	if (p->cur <= 16) {//현재 16점 이하면 고, 초과면 스톱
		return 1;
	}
	else {
		return 0;
	}
}

void resetDeck() {//덱 다시 다 채워넣기, 랜덤시드값 초기화
	memset(deck, 0, sizeof(deck));
	srand((unsigned int)time(NULL));
}

int isDepleted(int n) {//n번 인덱스가 고갈되었는지?
	if (deck[n] == NUMBER_OF_DECK) return 1;//yes, it is depleted
	else return 0;//no, it still exists
}

int getNum(int n) {//n번 인덱스의 숫자만 추려낸다.
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
	while (1) {//플레이어 수 관계상, 절대 모든 덱이 고갈날 일은 없다.
		card = rand();
		card %= NUMBER_OF_DECK * 13;	
		if (isDepleted) continue;
		else break;
	}
	return card;
}

void aRound() {//한 라운드. 플레이어 1,2,3,4가 결정하고, 딜러가 결정하면 한 판이 끝난다.
	/*
	1. 딜러가 각 인원에게 2장씩 나눠줌. 딜러의 1장은 비공개임.
	2. 딜러의 최초 2장이 21이면 즉시종료. 이 경우, 딜러제외 닥치고 전원패배.
	3. 최초분배 이후, 플레이어 1부터 딜러까지 고스톱 판별을 하는데, 21초과시 버스트됨이 전원에게 공개되며 패배확정
	4. 버스트 또는 스탠드(=스톱) 하면 다음플레이어로 넘어감
	5. 마지막 플레이어의 턴이 끝날 경우, 딜러가 자신의 고스톱판별을 함.
	6. 딜러가 블랙잭 띄우면, 블랙잭인 플레이어는 무승부, 아닌 플레이어는 패배확정
	7. 딜러가 21 초과(=버스트)하면, 모든 플레이어가 승리(버스트된 플레이어는??????)
	8. 딜러가 21 미만이면, 21에 더 가까운 플레이어가 승리, 아니면 패배, 거리가 같으면 무승부
	9. 10,J,K,Q는 전부 10으로 계산, A는 11로 계산하지만 카드를 더 받아 21 초과하면 1로 계산
	10. 모든 참가자가 스탠드 또는 버스트되면 결과정산
	11. 라운드 종료시, 제외된 카드를 제외된 채로 유지하여 다음라운드 시작
	12. 남은 카드가 딜러+플레이어 수의 5배보다 적으면 게임종료
	13. 플레이어는 최대 6명, 딜러포함 7명
	14. 딜러 이기면 100점, 블랙잭이면 200점, 패배하면 -100점, 음수점수 가능
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