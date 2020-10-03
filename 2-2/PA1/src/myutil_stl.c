#include <fcntl.h>
#include <stdio.h>  // string.h, stdio.h 는 나중에 필히 삭제할 것.
#include <stdlib.h>
#include <string.h>  // string.h, stdio.h 는 나중에 필히 삭제할 것.
#include <unistd.h>

// #include "mystring.h"

#define MAX_LENGTH 128 * 1024  // 줄당 최대 128KB 가정
#define MAX_BYTE 128 * 1024

int get_string_from_fd(int fd, char* dest) {  // fd로부터 개행까지 읽어온 뒤 개행은 빼고, dest에 덮어씀
    int rd_bytes;
    char c;
    int col = 0;
    dest[0] = 0;                                //empty array
    while (0 < (rd_bytes = read(fd, &c, 1))) {  // \n 없이 전부 읽고 저장하기
        dest[col++] = c;
        if (c == '\n') {
            dest[col++] = '\0';
            break;
        }
    }
    return strlen(dest);
}

//한 단어만 받았을 때, 단어의 행과 열을 stdout에 출력
void operate_1(int txt_fd, char* text_line, char* raw_query) {
    char* result;
    int row = 0;
    while (0 < get_string_from_fd(txt_fd, text_line)) {
        // printf("%s", text_line);
        row++;
        if (text_line[0] == '\n') continue;
        result = strtok(text_line, " \t\n");
        int col = result - text_line;
        // printf("%d:%d : %s\n", row, col, result);
        while (result != NULL) {
            // printf("%d:%d : %s\n", row, col, result);
            if (0 == strcmp(result, raw_query)) {
                printf("MATCHED == %d:%d : %s\n", row, col, result);
            }
            result = strtok(NULL, " \t\n");
            if (result == NULL) break;
            col = result - text_line;
            // printf("%d:%d : %s\n", row, col, result);
        }
    }
}
//여러 단어를 받았을 때, 모든 단어가 존재하는 시작 줄번호만 stdout에 출력
int operate_2(int txt_fd, char* text_line, char* query) {
    char* result;
    int row = 0;
    int col = 0;

    /* Parse Query to query_list */
    char** query_list = malloc(MAX_BYTE);  // "" 쿼리 안의 단어 수가 설마 128KB는 안넘겠지
    int query_list_cnt = 0;
    result = strtok(query, " \t\n");
    query_list[query_list_cnt++] = result;
    // printf("query_list[%d]: %s\n", query_list_cnt - 1, query_list[query_list_cnt - 1]);
    while (result != NULL) {
        result = strtok(NULL, " \t\n");
        if (result == NULL) break;
        query_list[query_list_cnt++] = result;
        // printf("query_list[%d]: %s\n", query_list_cnt - 1, query_list[query_list_cnt - 1]);
    }
    int* visited = malloc(query_list_cnt);

    char** text_line_list = malloc(MAX_BYTE);  //한 줄에 128KB는 안넘겠지 설마
    while (0 < get_string_from_fd(txt_fd, text_line)) {
        // printf("%s", text_line);
        row++;
        if (text_line[0] == '\n') continue;
        memset(visited, 0, sizeof(visited));

        /* Parse text_line to text_line_list */
        int text_line_list_cnt = 0;
        result = strtok(text_line, " \t\n");
        text_line_list[text_line_list_cnt++] = result;
        while (result != NULL) {
            result = strtok(NULL, " \t\n");
            if (result == NULL) break;
            text_line_list[text_line_list_cnt++] = result;
        }

        for (int i = 0; i < text_line_list_cnt; i++) {
            for (int j = 0; j < query_list_cnt; j++) {
                if (0 == strcmp(text_line_list[i], query_list[j])) {
                    visited[j] = 1;
                }
            }
        }

        // for (int i = 0; i < text_line_list_cnt; i++) {
        //     col = text_line_list[i] - text_line;
        //     printf("\'%d:%d %s\' ", row, col, text_line_list[i]);
        // }
        // printf("\n");
        // for (int i = 0; i < query_list_cnt; i++) {
        //     printf("\'%s\' ", query_list[i]);
        // }
        // printf("\n\n");

        int is_matched = 1;
        for (int j = 0; j < query_list_cnt; j++) {
            if (visited[j] == 0) {
                is_matched = 0;
                break;
            }
        }
        if (is_matched)
            printf("MATCHED %d\n", row);
    }
    free(text_line_list);
    free(query_list);
    free(visited);
    return 0;
}

//"구문들"을 입력받았을 때, 구문이 존재하는 모든 행과 열을 stdout 에 출력
int operate_3(int txt_fd, char* text_line, char* raw_query) {
    char* result;
    int row = 0;
    int col = 0;

    char* query = malloc(MAX_LENGTH);
    strcpy(query, raw_query + 1);  // 첫 " 제거
    int query_length = strlen(query);
    query[query_length - 1] = '\0';  // 끄트머리 " 덮어쓰기

    /* Parse Query to query_list */
    char** query_list = malloc(MAX_BYTE);  // "" 쿼리 안의 단어 수가 설마 128KB는 안넘겠지
    int query_list_cnt = 0;
    result = strtok(query, " \t\n");
    query_list[query_list_cnt++] = result;
    // printf("query_list[%d]: %s\n", query_list_cnt - 1, query_list[query_list_cnt - 1]);
    while (result != NULL) {
        result = strtok(NULL, " \t\n");
        if (result == NULL) break;
        query_list[query_list_cnt++] = result;
        // printf("query_list[%d]: %s\n", query_list_cnt - 1, query_list[query_list_cnt - 1]);
    }

    char** text_line_list = malloc(MAX_BYTE);  //한 줄에 128KB는 안넘겠지 설마
    while (0 < get_string_from_fd(txt_fd, text_line)) {
        // printf("%s", text_line);
        row++;
        if (text_line[0] == '\n') continue;

        /* Parse text_line to text_line_list */
        int text_line_list_cnt = 0;
        result = strtok(text_line, " \t\n");
        text_line_list[text_line_list_cnt++] = result;
        while (result != NULL) {
            result = strtok(NULL, " \t\n");
            if (result == NULL) break;
            text_line_list[text_line_list_cnt++] = result;
        }

        // for (int i = 0; i < text_line_list_cnt; i++) {
        //     col = text_line_list[i] - text_line;
        //     printf("\'%d:%d %s\' ", row, col, text_line_list[i]);
        // }
        // printf("\n");
        // for (int i = 0; i < query_list_cnt; i++) {
        //     printf("\'%s\' ", query_list[i]);
        // }
        // printf("\n\n");

        int a, b;
        for (a = 0; a < text_line_list_cnt - query_list_cnt; a++) {
            for (b = 0; b < query_list_cnt; b++) {
                char* left = text_line_list[a + b];
                char* right = query_list[b];
                if (0 == strcmp(left, right)) {
                    continue;
                }
                break;
            }
            if (b == query_list_cnt) {
                col = text_line_list[a] - text_line;
                printf("MATCHED %d:%d %s\n", row, col, text_line_list[a]);
            }
        }
    }
    free(text_line_list);
    free(query);
    free(query_list);
    return 0;
}
//단어*단어로 단 두개를 입력받았을 때, 최소 1개 단어를 띄운 행을 찾음.
int operate_4(int txt_fd, char* text_line, char* raw_query) {
    char* result;
    int row = 0;
    int col = 0;

    /* Parse Query to query_list */
    char** query_list = malloc(2);
    int query_list_cnt = 0;
    result = strtok(raw_query, "*\n");
    query_list[query_list_cnt++] = result;
    // printf("query_list[%d]: %s\n", query_list_cnt - 1, query_list[query_list_cnt - 1]);
    while (result != NULL) {
        result = strtok(NULL, "*\n");
        if (result == NULL) break;
        query_list[query_list_cnt++] = result;
        // printf("query_list[%d]: %s\n", query_list_cnt - 1, query_list[query_list_cnt - 1]);
    }

    char** text_line_list = malloc(MAX_BYTE);  //한 줄에 128KB는 안넘겠지 설마
    while (0 < get_string_from_fd(txt_fd, text_line)) {
        // printf("%s", text_line);
        row++;
        if (text_line[0] == '\n') continue;

        /* Parse text_line to text_line_list */
        int text_line_list_cnt = 0;
        result = strtok(text_line, " \t\n");
        text_line_list[text_line_list_cnt++] = result;
        while (result != NULL) {
            result = strtok(NULL, " \t\n");
            if (result == NULL) break;
            text_line_list[text_line_list_cnt++] = result;
        }

        // for (int i = 0; i < text_line_list_cnt; i++) {
        //     col = text_line_list[i] - text_line;
        //     printf("\'%d:%d %s\' ", row, col, text_line_list[i]);
        // }
        // printf("\n");
        // for (int i = 0; i < query_list_cnt; i++) {
        //     printf("\'%s\' ", query_list[i]);
        // }
        // printf("\n\n");

        int a, b;
        for (a = 0; a < text_line_list_cnt - 2; a++) {
            if (0 != strcmp(text_line_list[a], query_list[0])) {
                continue;
            }
            for (b = a + 2; b < text_line_list_cnt; b++) {
                if (0 == strcmp(text_line_list[b], query_list[1])) {
                    col = text_line_list[a] - text_line;
                    printf("MATCHED %d %s\n", row, text_line_list[a]);
                } else
                    continue;
            }
        }
    }
    free(text_line_list);
    free(query_list);
    return 0;
}

int what_query_is_it(char* raw_query) {  // 실패시 -1 반환.
    int query_length = strlen(raw_query);
    int mode = -1;
    for (int i = 0; i < query_length; i++) {
        char c = raw_query[i];
        if (c == '\"') {  // 큰 따옴표 있으면 무조건 3번
            mode = 3;
            break;
        } else if (c == '*') {  // 별 있으면 무조건 4번
            mode = 4;
            break;
        } else if (c == ' ') {  // 큰 따옴표 없는데 두 개 이상의 단어면 무조건 2번
            mode = 2;
            break;
        } else if (c == '\n') {  // 평범히 개행까지 다다랐다면 1번
            mode = 1;
            break;
        } else
            continue;
    }
    // 끝 개행 삭제하기
    if (*raw_query && raw_query[query_length - 1] == '\n')
        raw_query[query_length - 1] = '\0';
    return mode;
}

int repeat_queries(int txt_fd) {
    char* raw_query = malloc(MAX_LENGTH);
    char* text_line = malloc(MAX_LENGTH);
    while (0 < get_string_from_fd(STDIN_FILENO, raw_query)) {
        printf("raw_query is %s\n", raw_query);

        int mode = what_query_is_it(raw_query);
        if (mode == 1) {
            operate_1(txt_fd, text_line, raw_query);
        } else if (mode == 2) {
            operate_2(txt_fd, text_line, raw_query);
        } else if (mode == 3) {
            operate_3(txt_fd, text_line, raw_query);
        } else if (mode == 4) {
            operate_4(txt_fd, text_line, raw_query);
        } else {
            printf("-1 mode is an ERROR\n");
        }
    }
    free(text_line);
    free(raw_query);
    return 0;
}

int solve(int txt_fd) {
    int pos = lseek(txt_fd, 0, SEEK_SET);
    if (pos != 0) {
        return -1;
    }
    repeat_queries(txt_fd);
}