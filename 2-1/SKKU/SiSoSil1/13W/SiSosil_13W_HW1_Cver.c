#include <stdio.h>
#include <stdlib.h>

/*
오픈링크 연결리스트 해시
*/

typedef struct node_struct {
	int data;
	struct node_struct* next;
} Node;

typedef struct head_struct {
	Node* first;
	Node* last;
} Head;

int n, m;

Node* create_node(int data) {
	Node* new_node = (Node*)malloc(sizeof(Node));
	new_node->data = data;
	new_node->next = NULL;
	return new_node;
}

Head* create_head() {
	Head* new_head = (Head*)malloc(sizeof(Head));
	new_head->first = NULL;
	new_head->last = NULL;
	return new_head;
}

void add(Head* head, int data) {
	if (head->last == NULL) {
		head->last = create_node(data);
		head->first = head->last;
	}
	else {
		Node* p = head->last;
		p->next = create_node(data);
		head->last = p->next;
	}
}

int hash_func(int num) {
	return num % 10;
}

void print_hash_list(Head** bucket) {
	int i;
	for (i = 0; i < 10; i++) {
		Node* tmp = bucket[i]->first;
		printf("%d: ", i);
		while (tmp != NULL) {
			printf("%d ", tmp->data);
			tmp = tmp->next;
		}
		printf("\n");
	}
}

int main() {
	int i;

	Head* list[10];
	for (i = 0; i < 10; i++) {
		list[i] = create_head();
	}

	for (i = 0; i < 10; i++) {
		int val;
		scanf("%d", &val);
		int key = hash_func(val);
		add(list[key], val);
	}

	print_hash_list(list);

	return 0;
}