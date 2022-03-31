from lexical import scanner
from parse_tree import Node


class parser():
    def __init__(self, tokens, grammar_path):
        self.tokens = tokens
        self.grammar_path = grammar_path
        self.grammar = self.make_LLgrammar()
        self.nonterminal = self.get_nonterminal()
        self.terminal = self.get_terminal()
        self.first = self.set_first()
        self.follow = self.set_follow()
        self.num_row = len(self.nonterminal) + 1
        self.num_col = len(self.terminal) + 1
        self.table = self.parsing_table()
        self.word_tokens = []
        self.num_tokens = []
        self.symbol_table = []

    def make_LLgrammar(self):
        pre_grammar = self.read_from_grammar_path()
        grammar_without_lr = self.resolve_left_recursion(pre_grammar)
        LLgrammar = self.resolve_left_factoring(grammar_without_lr)
        for key, value in LLgrammar.items():
            idx = 0
            while idx < len(value):
                for idx2 in range(len(value[idx])):
                    value[idx][idx2] = value[idx][idx2].strip("\"")
                idx += 1
        return LLgrammar

    def read_from_grammar_path(self):
        grammar = dict()
        with open(self.grammar_path, 'r') as g:
            pre_grammar = g.read()
        pre_grammar_list = pre_grammar.strip().split(';\n')
        for i in pre_grammar_list:
            LHS = i.split('->')[0].strip()
            RHS = i.split('->')[1].strip()
            RHS_list = []
            if '|' in RHS and RHS.startswith('(') is False:
                RHS = RHS.split('|')
                for j in range(len(RHS)):
                    RHS[j] = RHS[j].strip()
                for j in RHS:
                    j = j.split(' ')
                    for k in range(len(j)):
                        j[k] = j[k].strip()
                    RHS_list.append(j)
            else:
                if RHS.startswith('(') is False:
                    RHS = RHS.split(' ')
                    for j in range(len(RHS)):
                        RHS[j] = RHS[j].strip()
                else:
                    temp = RHS
                    RHS = []
                    RHS.append(temp)
                RHS_list.append(RHS)
            grammar[LHS] = RHS_list
        return grammar

    def resolve_left_recursion(self, grammar):
        lr_removed_grammar = grammar.copy()
        for key, value in grammar.items():
            leftmost = []
            if len(value) > 1:
                for j in value:
                    leftmost.append(j[0])
            else:
                leftmost.append(value[0])

            for k in leftmost:
                if key == k:
                    temp = dict()
                    temp[key] = lr_removed_grammar[key]
                    del lr_removed_grammar[key]
                    if temp[key][1] != ['']:
                        lr_removed_grammar[key] = [[temp[key][1][0], k+'\'']]
                    else:
                        lr_removed_grammar[key] = [[k + '\'']]
                    new_value_list = [[temp[key][0][1], k + '\''], ['']]
                    lr_removed_grammar[k + '\''] = new_value_list

        grammar = lr_removed_grammar.copy()
        return grammar

    def resolve_left_factoring(self, grammar):
        lf_removed_grammar = grammar.copy()
        for key, value in grammar.items():
            if len(value) > 1:
                lf_index = 0
                leftmost = value[0][0]
                for j in value:
                    if j[0] == leftmost:
                        continue
                    else:
                        lf_index = 1
                        break;
                if lf_index == 0:
                    temp = dict()
                    temp[key] = lf_removed_grammar[key]
                    del lf_removed_grammar[key]
                    lf_removed_grammar[key] = [[leftmost, key + '\'']]
                    if len(temp[key][0][1:]) == 0:
                        new_value_list = [temp[key][1][1:], ['']]
                    else:
                        new_value_list = [temp[key][0][1:], temp[key][1][1:]]
                    lf_removed_grammar[key + '\''] = new_value_list

        grammar = lf_removed_grammar.copy()
        return grammar

    def get_nonterminal(self):
        nonterminal = []
        for key, value in self.grammar.items():
            nonterminal.append(key)
        return nonterminal

    def get_terminal(self):
        terminal = []
        for key, value in self.grammar.items():
            if len(value) == 1:
                for i in value[0]:
                    if i not in self.nonterminal:
                        terminal.append(i)
            else:
                for i in range(len(value)):
                    for j in value[i]:
                        if j not in self.nonterminal:
                            terminal.append(j)
        temp_set = set(terminal)
        terminal = list(temp_set)
        return terminal

    def set_first(self):
        first = dict()
        keys = self.nonterminal
        for key in keys:
            temp_set = set(self.get_first(key))
            first[key] = temp_set
        return first

    def get_first(self, key):
        first_list = []
        if len(self.grammar[key]) == 1:
            value = self.grammar[key][0]
            if value[0] in self.terminal:
                first_list.append(value[0])
            else:
                first_list.extend(self.get_first(value[0]))
        else:
            for i in range(len(self.grammar[key])):
                value = self.grammar[key][i][0]
                if value in self.terminal:
                    first_list.append(value)
                else:
                    first_list.extend(self.get_first(value))
        return first_list

    def set_follow(self):
        follow = dict()
        keys = self.nonterminal
        for key in keys:
            temp_set = set(self.get_follow(key))
            follow[key] = temp_set
        return follow

    def get_follow(self, target_key):
        follow_list = []
        if target_key == 'prog':
            follow_list.append('$')

        for key, value in self.grammar.items():
            if len(value) == 1:
                if target_key in value[0]:
                    index = value[0].index(target_key)
                    # not the last position
                    if index != len(value[0]) - 1:
                        if value[0][index+1] in self.terminal:
                            follow_list.append(value[0][index+1])
                        else:
                            temp_first = self.first[value[0][index+1]].copy()
                            if '' not in temp_first:
                                follow_list.extend(temp_first)
                            else:
                                temp_first.remove('')
                                follow_list.extend(temp_first)
                                follow_list.extend(self.get_follow(key))
                    # the last position
                    else:
                        if target_key != key:
                            follow_list.extend(self.get_follow(key))
                        else:
                            continue
                else:
                    continue
            else:
                for i in range(len(value)):
                    if target_key in value[i]:
                        index = value[i].index(target_key)
                        # not the last position
                        if index != len(value[i]) - 1:
                            if value[i][index + 1] in self.terminal:
                                follow_list.append(value[i][index + 1])
                            else:
                                temp_first = self.first[value[i][index + 1]].copy()
                                if '' not in temp_first:
                                    follow_list.extend(temp_first)
                                else:
                                    temp_first.remove('')
                                    follow_list.extend(temp_first)
                                    follow_list.extend(self.get_follow(key))
                        # the last position
                        else:
                            if target_key != key:
                                follow_list.extend(self.get_follow(key))
                            else:
                                continue
                    else:
                        continue
        return follow_list


    def preprocess_parsing(self, input_txt):
        input_txt.append("$")
        terminal = {key : word for word, key in enumerate(self.terminal)}
        non_terminal = {key: word for word, key in enumerate(self.nonterminal)}
        stack = list()
        stack.append(self.nonterminal[0])
        stack.append('$')
        
        return input_txt, terminal, non_terminal, stack

    def parsing(self, input_txt):
        #Get preprocessed data of input_txt(list), terminal&non_terminal(dict), stack(list)
        input_txt, terminal, non_terminal, stack = self.preprocess_parsing(input_txt)
        
        self.parse_tree = Node(stack[0], None, 0)
        
        check = False
        #when stack length equals 1, $ is only left.
        while len(stack) > 1:
            comp = stack.pop(0)
            symbol = input_txt[0]

            
            if comp in terminal:
                if symbol == comp.strip("\""):
                    input_txt.pop(0)

                    if symbol == '([a-z] | [A-Z])*':
                        self.parse_tree.id = self.word_tokens.pop(0)
                        
                    elif symbol == '[0-9]*':
                        self.parse_tree.id = self.num_tokens.pop(0)
                    
                    self.parse_tree = self.parse_tree.advance()
                
                #Finished.
                else:
                    check = True
                    break
            
            if comp not in terminal:
                row = 0
                col = self.table[0].index(symbol)

                for idx in range(len(self.nonterminal)):
                    if self.nonterminal[idx] == comp:
                        row = idx + 1
                        break
                
                push = self.table[row][col]
                if type(push) == str:
                    push = [push]

                if push != 0:
                    if push != ['']:
                        stack = push + stack
                        #set push
                        self.parse_tree.set_child(push)
                        #Move cur
                        self.parse_tree = self.parse_tree.children[0]
                    else:
                        #Child goes to e
                        self.parse_tree.set_child([''])
                        #
                        self.parse_tree = self.parse_tree.advance()
                
                #Finished
                else:
                    check = True
                    break
        if check:
            return None
        else:
            self.parse_tree = self.parse_tree.get_root()
            return self.parse_tree

    def parsing_table(self):
        self.terminal.remove('')
        self.terminal.append('$')
        table = [[0 for col in range(self.num_col)] for row in range(self.num_row)]
        for idx in range(1, self.num_col):
            table[0][idx] = self.terminal[idx-1]
        for idx in range(1, self.num_row):
            table[idx][0] = self.nonterminal[idx-1]

        for row in range(1, self.num_row):
            transition = dict()
            transition[table[row][0]] = self.grammar[table[row][0]]
            for key, value in transition.items():
                for i in self.first[key]:
                    if i == '':
                        for j in self.follow[key]:
                            for col in range(1, self.num_col):
                                if j == table[0][col]:
                                    table[row][col] = ['']
                                    break

                    else:
                        for col in range(1, self.num_col):
                            if i == table[0][col]:
                                if len(value) == 1:
                                    table[row][col] = value[0]
                                else:
                                    for a in range(len(value)):
                                        if i in value[a]: # or i == self.first[value[a][0]]:
                                            table[row][col] = value[a]
                                            break
                                        elif value[a][0] in self.nonterminal:
                                            if i in self.first[value[a][0]]:
                                                table[row][col] = value[a]
                                                break
                                        else:
                                            continue

        return table

    def tokens2input(self, tokens):
        temp_list = []
        #Some token needs to be replaced.
        # word : ([a-z] | [A-Z])*
        # number : [0-9]*
        # else : append directly to token.
        for types, ids in tokens:
            if types == "word : ":
                temp_list.append("([a-z] | [A-Z])*")
                self.word_tokens.append(ids)
            elif types == "number":
                temp_list.append("[0-9]*")
                self.num_tokens.append(ids)
            else:
                temp_list.append(ids)
        return temp_list

    def get_symbol_table(self):
        self.symbol_table = self.parse_tree.set_symbol_table()
