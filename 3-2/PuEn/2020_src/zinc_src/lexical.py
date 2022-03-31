import sys

class scanner():
    def __init__(self, code):
        self.code = code
        self.length = len(code)
        self.type = ['int', 'char']
        self.operator = ['<', '+', '*', '=']
        self.bracket = ["(", ")", "{", "}"]
        self.other_character = [",", ";"]
        self.statement = ['IF', 'THEN', 'ELSE']
        self.exit = ["EXIT"]
        self.tokens = []

    def read_full_digit(self, idx):
        ret = 0
        while idx+ret < self.length and self.code[idx+ret].isdigit():
            ret+=1
        assert ret>0
        return self.code[idx:idx+ret]

    def read_full_string(self, idx):
        ret=0
        while idx+ret<self.length and self.code[idx+ret].isalpha():
            ret+=1
        assert ret>0
        return self.code[idx:idx+ret]

    def lexical(self):
        idx=0
        while idx<self.length:
            if self.code[idx].isdigit(): # 숫자가 들어오면
                token = self.read_full_digit(idx)
                self.tokens.append(['number', token])
                idx+=len(token)
            elif self.code[idx].isalpha(): # 알파벳이 들어오면
                token = self.read_full_string(idx)
                if token in self.type:
                    self.tokens.append(['type : ', token])
                elif token in self.statement:
                    self.tokens.append(['statement : ', token])
                elif token in self.exit: 
                    self.tokens.append(['EXIT : ', token])
                else:
                    self.tokens.append(['word : ', token])
                idx+=len(token)
            elif self.code[idx] == ' ' or self.code[idx] == '\n' or self.code[idx] == '   ':
                idx+=1
            else:
                if self.code[idx] in self.bracket:
                    self.tokens.append(['bracket : ', self.code[idx]])
                    idx+=1
                elif self.code[idx] in self.operator:
                    self.tokens.append(['operator : ', self.code[idx]])
                    idx+=1
                elif self.code[idx] in self.other_character:
                    self.tokens.append(['comma, semicolon : ', self.code[idx]])
                    idx+=1
                else:
                    self.tokens.append(0)
                    print("Lexical Error: Wrong Input{}".format(idx))
                    sys.exit()
        assert len(self.tokens) > 0