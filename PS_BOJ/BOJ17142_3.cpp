#include <iostream>
#include <string>
#include <string.h>
#include <utility>
#include <algorithm>
#include <deque>
#include <vector>
#define pii pair<int,int>
#define ff first
#define ss second
#define mp(a,b) make_pair(a,b)
#define MAX (int)55
#define endl '\n'
using namespace std;

//int t;
int N, M;
int OriginalField[MAX][MAX];
int field[MAX][MAX];//0:공간, 1:벽, 2:비활성, 3~: 활성, 그리고 초각인
int aidacnt;//빈공간 개수
int dr[4] = { 0,0,1,-1 };
int dc[4] = { 1,-1,0,0 };
vector<pii> HikatsuseiVirus;//최초 비활성바이러스위치
vector<pii> KatsuseiVirus;//최초 활성바이러스위치
deque<pii> KatsuseichuVirus;//활성중인 바이러스 큐
int kotae = 987654321;

void printfield() {
	for (int r = 0; r < N; r++) {
		for (int c = 0; c < N; c++) {
			cout << field[r][c] << ' ';
		}
		cout << endl;
	}
	return;
}

void fieldReset() {
	for (int r = 0; r < N; r++) {
		for (int c = 0; c < N; c++) {
			field[r][c] = OriginalField[r][c];
		}
	}
	return;
}

bool InBound(int r, int c) {
	if (r < 0 || c < 0 || r >= N || c >= N)
		return false;
	return true;
}

int BakuHatsu() {
	int spreaded = 0;
	int sec = 0;
	/*for (pii stvir : KatsuseiVirus) {
		KatsuseichuVirus.push_back(stvir);
		int rr = stvir.ff; int cc = stvir.ss;
		field[rr][cc] = 3;
	}*/
	for (int i = 0; i < KatsuseiVirus.size(); i++) {
		pii stvir = KatsuseiVirus[i];
		KatsuseichuVirus.push_back(stvir);
		int rr = stvir.ff; int cc = stvir.ss;
		field[rr][cc] = 3;
	}
	while (!KatsuseichuVirus.empty() && spreaded != aidacnt) {//활성화바이러스에 찍히는 숫자는 시간+3이다.
		/*cout << sec << " 초 째: " << endl;
		printfield();*/
		sec++;
		int cnt = KatsuseichuVirus.size();
		while (cnt--) {
			pii virus = KatsuseichuVirus.front();
			KatsuseichuVirus.pop_front();
			int rr = virus.ff; int cc = virus.ss;
			for (int i = 0; i < 4; i++) {
				int rrr = rr + dr[i]; int ccc = cc + dc[i];
				if (field[rrr][ccc] == 0 && InBound(rrr, ccc)) {
					KatsuseichuVirus.push_back(mp(rrr, ccc));
					field[rrr][ccc] = sec + 3;
					spreaded++;
				}
				else if (field[rrr][ccc] == 2 && InBound(rrr, ccc)) {
					KatsuseichuVirus.push_back(mp(rrr, ccc));
					field[rrr][ccc] = sec + 3;
				}
			}
		}
	}
	if (spreaded == aidacnt)
		return sec;
	else
		return -1;
}

int DFS(int start) {
	if (KatsuseiVirus.size() == M) {//활성바이러스 위치 M 개 확정했으면
		int ans;
		KatsuseichuVirus.clear();
		ans = BakuHatsu();
		//cout << "최초숙주: ";
		/*for (pii firstvir : KatsuseiVirus) {
			int rr = firstvir.ff; int cc = firstvir.ss;
			cout << rr << "," << cc << endl;
		}*/
		if (ans != -1) {
			if (kotae > ans) {
				//cout << "최소 초 경신 : " << ans << endl;
				kotae = ans;
			}
		}
		/*printfield();
		cout << endl;*/

		fieldReset();
		return ans;
	}
	else {
		for (int i = start; i < HikatsuseiVirus.size(); i++) {
			pii now = HikatsuseiVirus[i];
			KatsuseiVirus.push_back(now);
			DFS(i + 1);
			KatsuseiVirus.pop_back();
		}
	}
}

int main() {
	/*ios::sync_with_stdio(false);
	cin.tie(NULL);*/
	//cin >> t;
	//t = 1;
	
	cin >> N >> M;
	aidacnt = 0;

	// cout << "wrong!" << endl;

	for (int r = 0; r < N; r++) {
		for (int c = 0; c < N; c++) {
			cin >> field[r][c];
			OriginalField[r][c] = field[r][c];
			if (field[r][c] == 2) {
				HikatsuseiVirus.push_back(mp(r, c));
			}
			else if (field[r][c] == 0) {
				aidacnt++;
			}
		}
	}
	DFS(0);
	if (kotae != 987654321)
		cout << kotae << endl;
	else
		cout << -1 << endl;
	return 0;
}

/*
답은 전부 다 제대로 나오는데, 런타임에러가 뜬다.
어디서 떴을까.
*/