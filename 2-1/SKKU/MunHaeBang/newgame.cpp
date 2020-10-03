#include <curses.h>
#include <stdlib.h>

#include "bits/stdc++.h"
using namespace std;

#define EMPTY ' '
#define LANDMINE '.'
#define WALL1 '8'
#define PLAYER '*'
#define MONSTER 'M'
#define MONSTER_NUM 1
#define R 23
#define C 74
#define pii pair<int, int>
#define ff first
#define ss second
#define mp(a, b) make_pair(a, b)

deque<pii> fireDQ;

bool can_go_monster(int r, int c) {
    int testch;
    testch = mvinch(r, c);
    return ((testch == EMPTY));
}

bool can_go_player(int r, int c) {
    int testch;
    testch = mvinch(r, c);
    return (testch == EMPTY);
}

bool monster_move(int& mr, int& mc, int doko) {  //상 하 좌 우로 이동
    if (doko == 0) {                             //상
        if ((mr > 0) && can_go_monster(mr - 1, mc)) {
            mvaddch(mr, mc, LANDMINE);
            mr--;
            return true;
        }
    } else if (doko == 1) {  //하
        if ((mr < LINES - 1) && can_go_monster(mr + 1, mc)) {
            mvaddch(mr, mc, LANDMINE);
            mr++;
            return true;
        }
    } else if (doko == 2) {  //좌
        if ((mc > 0) && can_go_monster(mr, mc - 1)) {
            mvaddch(mr, mc, LANDMINE);
            mc--;
            return true;
        }
    } else if (doko == 3) {  //우
        if ((mc < COLS - 1) && can_go_monster(mr, mc + 1)) {
            mvaddch(mr, mc, LANDMINE);
            mc++;
            return true;
        }
    }
    return false;
}

void BFS() {
    int cnt = fireDQ.size();
    while (cnt--) {
        int rr = fireDQ.front().ff;
        int cc = fireDQ.front().ss;
        fireDQ.pop_front();
        for (int i = 0; i < 4; i++) {
            int rrr = rr;
            int ccc = cc;
            if (monster_move(rrr, ccc, i)) {
                fireDQ.push_back(mp(rrr, ccc));
            }
        }
    }
}

bool is_player_okay(int r, int c, int mr, int mc) {
    if (abs(r - mr) > 1 && abs(c - mc) > 2)  //r, c 모두 1, 2 이상 이격되어있어야 생존가능
        return true;
    else
        return false;
}

void player_move(int& r, int& c, char ch) {
    switch (ch) {  //플레이어 이동
        case 'w':
        case 'W':
            if ((r > 0) && can_go_player(r - 1, c)) {
                mvaddch(r, c, LANDMINE);
                r = r - 1;
            }
            break;
        case 's':
        case 'S':
            if ((r < LINES - 1) && can_go_player(r + 1, c)) {
                mvaddch(r, c, LANDMINE);
                r = r + 1;
            }
            break;
        case 'a':
        case 'A':
            if ((c > 0) && can_go_player(r, c - 1)) {
                mvaddch(r, c, LANDMINE);
                c = c - 1;
            }
            break;
        case 'd':
        case 'D':
            if ((c < COLS - 1) && can_go_player(r, c + 1)) {
                mvaddch(r, c, LANDMINE);
                c = c + 1;
            }
            break;
    }
}

void draw_maze() {  //empty로의 초기화작업이 필요한가?
    int r, c;
    string maze[23];
    maze[0] = "8888888888888888888888888888888888888888888888888888888888888888888888 88";
    maze[1] = "8   8               8               8           8                   8   8";
    maze[2] = "8   8   888888888   8   88888   888888888   88888   88888   88888   8   8";
    maze[3] = "8               8       8   8           8           8   8   8       8   8";
    maze[4] = "888888888   8   888888888   888888888   88888   8   8   8   888888888   8";
    maze[5] = "8       8   8               8           8   8   8   8   8           8   8";
    maze[6] = "8   8   8888888888888   8   8   888888888   88888   8   888888888   8   8";
    maze[7] = "8   8               8   8   8       8           8           8       8   8";
    maze[8] = "8   8888888888888   88888   88888   8   88888   888888888   8   88888   8";
    maze[9] = "8           8       8   8       8   8       8           8   8           8";
    maze[10] = "8   88888   88888   8   88888   8   888888888   8   8   8   8888888888888";
    maze[11] = "8       8       8   8   8       8       8       8   8   8       8       8";
    maze[12] = "8888888888888   8   8   8   888888888   8   88888   8   88888   88888   8";
    maze[13] = "8           8   8           8       8   8       8   8       8           8";
    maze[14] = "8   88888   8   888888888   88888   8   88888   88888   8888888888888   8";
    maze[15] = "8   8       8           8           8       8   8   8               8   8";
    maze[16] = "8   8   888888888   8   88888   888888888   8   8   8888888888888   8   8";
    maze[17] = "8   8           8   8   8   8   8           8               8   8       8";
    maze[18] = "8   888888888   8   8   8   88888   888888888   888888888   8   888888888";
    maze[19] = "8   8       8   8   8           8           8   8       8               8";
    maze[20] = "8   8   88888   88888   88888   888888888   88888   8   888888888   8   8";
    maze[21] = "8   8                   8                           8               8   8";
    maze[22] = "8   888888888888888888888888888888888888888888888888888888888888888888888";
    for (int r = 0; r < 23; r++) {
        mvaddstr(r, 1, maze[r].c_str());
    }
}

int main(void) {
    int r, c;                              //플레이어 위치. 커서의 위치이기도 함.
    int mr[MONSTER_NUM], mc[MONSTER_NUM];  //몬스터 위치
    int ch;
    srand((unsigned int)time(NULL));

    initscr();
    keypad(stdscr, TRUE);
    cbreak();
    noecho();
    clear();

    draw_maze();

    mr[0] = 2;
    mc[0] = 2;
    fireDQ.push_back(mp(mr[0], mc[0]));
    r = R - 1;
    c = 3;
    int second = 0;
    bool clear = false;
    do {
        if (r == 0) {
            clear = true;
            break;
        }
        second++;
        mvaddch(r, c, PLAYER);
        for (int i = 0; i < MONSTER_NUM; i++) {
            mvaddch(mr[i], mc[i], MONSTER);
        }
        move(r, c);
        refresh();
        ch = getch();
        player_move(r, c, ch);
        // for (int i = 0; i < MONSTER_NUM; i++) {
        //     for (int cnt = 0; cnt < 10; cnt++) {
        //         int doko = rand() % 4;
        //         if (monster_move(mr[i], mc[i], doko))
        //             break;
        //         else
        //             continue;
        //     }
        // }
        // if (second % 2) BFS();
    } while ((ch != 'q') && (ch != 'Q'));

    if (clear) {
        printw("Congratulation! Game Clear!!!");
        refresh();
    } else {
        printw("You're Barbequed. Game Over.");
        refresh();
    }
    endwin();
    exit(0);
}
//g++ newgame.cpp -lncurses -o gm