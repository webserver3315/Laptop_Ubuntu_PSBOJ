#include <stdio.h>

int main() {
	int cnt = 0;
	while (1) {		
		int tmp;
		printf("Input the weight of the egg = ");
        scanf("%d",&tmp);
		if (tmp >= 300)
            printf("I have %d eggs in my eggbox!\n",++cnt);
		else
            printf("I have %d eggs in my eggbox!\n",cnt);
        if (cnt >= 30)
            break;
        else
            continue;
	}
    printf("The eggbox is full!");
	return 0;
}