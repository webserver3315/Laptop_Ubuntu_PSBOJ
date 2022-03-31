import sys

class scanner():
    def __init__(self, code: str):
        self.code = code
        self.length = len(code)
        self.bracket = ["(", ")", "{", "}"]
        self.other_character= [",", ";"]
        self.type = ['int', 'char'] #lower_case character
        self.statement = ['IF', 'THEN', 'ELSE', 'WHILE'] #higher_case character
        self.exit = ["EXIT"] #higher_case character
        self.operator = ['>','==', '+', '*', '=']
        self.tokens = []

    def lexical(self):
        i=0

        while i<self.length:
            if self.code[i].isdigit(): # number(length >=1)
                token = self.get_digit(i)
                self.tokens.append(['number', token])
                i+= len(token)

            elif self.code[i].isalpha(): #word, type, statement(length>=1)
                token = self.get_str(i)
                if token in self.type:
                    self.tokens.append(['type : ', token])
                elif token in self.statement:
                    self.tokens.append(['statement : ', token])
                elif token in self.exit:
                    self.tokens.append(['EXIT : ', token])
                else:
                    self.tokens.append(['word : ', token])
                i+=len(token)

            elif self.code[i] == ' ' or self.code[i] == '\n' or self.code[i] == 9 or self.code[i] == '   ':
                i += 1

            else: #bracket, operator or error(length =1) (for operator '==' : length =2)
                if self.code[i] in self.bracket:
                    self.tokens.append(['bracket : ', self.code[i]])
                    i+=1
                elif self.code[i] in self.operator:
                    if self.check_equality(i):
                        self.tokens.append(['operator : ', '=='])
                        i+=2
                    else:
                        self.tokens.append(['operator : ', self.code[i]])
                        i+=1
                elif self.code[i] in self.other_character:
                    self.tokens.append(['comma, semicolon : ', self.code[i]])
                    i+=1
                else:
                    self.tokens.append(0)
                    print("Error in Lexical Analysis: wrong input {}".format(i))
                    sys.exit()

        if len(self.tokens)==0: #if there is no token, print error
                print("Compilation Error in Lexical Analysis : no tokens")
                sys.exit()##꼭 해야하는지 나중에 확인

    def check_equality(self, i):
        if i < self.length-1:
            if self.code[i:i+2]== '==':
                return True

    def get_digit(self, i):
        j=1
        while i+j < self.length:
            if self.code[i+j].isdigit():
                j+=1
            else:
                break
        return self.code[i:i+j]

    def get_str(self, i):
        j=1
        while i+j < self.length:
            if self.code[i+j].isalpha():
                j+=1
            else:
                break
        return self.code[i:i+j]
