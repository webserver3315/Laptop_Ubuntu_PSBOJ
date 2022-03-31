#include <bits/stdc++.h>
#define pst pair<string, TokenName>
#define FOR(x,n)  for(int x=0;x<(n);x++) 
using namespace std;

// Define Token Name
enum TokenName{
    TYPE,       // 0
    CHAR,       // 1
    NUM,        // 2
    OPERATOR,   // 3
    ASSIGNMENT, // 4
    COMPARISON, // 5
    SEMICOLON,  // 6
    LBRACE,     // 7
    RBRACE,     // 8
    LPAREN,     // 9
    RPAREN,     // 10
    KEYWORD,    // 11
    WHITESPACE, // 12
    ETC,        // 13
    IDENTIFIER,        // 14
};
set<string> set_type = {"int", "char"};
set<string> set_alphabet = {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"};
set<string> set_number = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9"};
set<string> set_operator = {"+", "*"};
set<string> set_assignment = {"="};
set<string> set_comparison = {"<"};
set<string> set_semicolon = {";"};
set<string> set_lbrace = {"{"};
set<string> set_rbrace = {"}"};
set<string> set_lparen = {"("};
set<string> set_rparen = {")"};
set<string> set_keyword = {"IF", "THEN", "ELSE", "EXIT"};
set<string> set_whitespace = {" ", "\n", "\t"};
set<string> set_etc = {}; // 안쓸듯?

map<string, int> Integer_dfa;
map<string, int> Char_dfa;
map<string, int> Identifier_dfa;

string lexeme;

bool accepts(map<string, int> dfa, int starting_state, set<int> final_states, string input){

}

bool is_in_set(string& str, set<string> set_something){ // == (str in set)
    if(set_something.find(str) == set_something.end()) return false;
    else return true;
}
bool is_in_set(char& ch, set<string> set_something){ // overload
    if(set_something.find(string(1,ch)) == set_something.end()) return false;
    else return true;
}

bool lexer(string& str)
{
    FOR(i, str.length())
    {
        char ch = str[i];
        if(is_in_set(ch, set_whitespace) == false)
        { // if ch is not in whitespace
            lexeme.push_back(ch);
        }

        if(i+1 < str.length()){            
            if( is_in_set(str[i+1], set_whitespace) || 
                is_in_set(str[i+1], set_keyword) ||
                is_in_set(lexeme, set_keyword) )// keyword 완성되면 깡패다. 여부 확인사살한 뒤 무조건 넣는다. 즉, IFtmp1 같은 변수는 금지다.
            {
                TokenName a;
                set<int> integer_dfa_final_state = {2, 3};
                set<int> char_dfa_final_state = {1};
                set<int> identifier_dfa_final_state = {1};
                if(is_in_set(lexeme, set_type)) a = TYPE;
                else if(is_in_set(lexeme, set_operator)) a = OPERATOR;
                else if(is_in_set(lexeme, set_assignment)) a = ASSIGNMENT;
                else if(is_in_set(lexeme, set_comparison)) a = COMPARISON;
                else if(is_in_set(lexeme, set_semicolon)) a = SEMICOLON;
                else if(is_in_set(lexeme, set_lbrace)) a = LBRACE;
                else if(is_in_set(lexeme, set_rbrace)) a = RBRACE;
                else if(is_in_set(lexeme, set_lparen)) a = LPAREN;
                else if(is_in_set(lexeme, set_rparen)) a = RPAREN;
                else if(is_in_set(lexeme, set_keyword)) a = KEYWORD;
                else if(accepts(Integer_dfa, 0, integer_dfa_final_state, lexeme)) a = NUM;
                else if(accepts(Char_dfa, 0, char_dfa_final_state, lexeme)) a = CHAR; // 문법 수정: char 는 외글자만 허용하며, 반드시 작은 따옴표로 감싸져있음.
                else if(accepts(Identifier_dfa, 0, identifier_dfa_final_state, lexeme)) a = IDENTIFIER; 
                

            }
        }

    }
}
int main(){
    string token;
    while(cin>>token){
        lexer(token);  
    }
}