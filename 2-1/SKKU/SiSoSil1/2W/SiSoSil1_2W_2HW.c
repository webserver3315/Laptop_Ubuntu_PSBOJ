#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int n;
int** dp;

int DP(int r, int c) {
	if (r<1 || c<1 || r>n || c>n)
		return 0;
	if (dp[r][c] != -1)
		return dp[r][c];
	if (c == 1 || r == c) {
		dp[r][c] = 1;
		return dp[r][c];
	}
	else if (c == 2 || r - 1 == c) {
		dp[r][c] = r - 1;
		return dp[r][c];
	}
	dp[r][c] = DP(r - 1, c - 1) + DP(r - 1, c);
	return dp[r][c];
}

int main() {
    scanf("%d",&n);

	dp = (int**)malloc(sizeof(int*) * (n + 1));
	for (int i = 0; i < n + 1; i++) {
		dp[i] = (int*)malloc(sizeof(int) * (i + 1));
		memset(dp[i], -1, sizeof(int) * (i + 1));
	}

	for (int r = 1; r <= n; r++) {
		for (int s = n - 1; s >= r; s--) {
            printf(" ");
		}
		for (int c = 1; c <= r; c++) {
            printf("%d ",DP(r,c));
		}
		printf("\n");
	}

	return 0;
}