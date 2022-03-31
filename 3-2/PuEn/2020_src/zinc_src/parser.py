from lexical import scanner

class parser():
    def __init__(self, tokens):
        self.tokens = tokens
        self.grammar = self.get_grammar()
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

    def get_grammar(self):
        grammar = {}
        grammar["prog"] = [['word', '(', ')', 'block']]
        grammar["decl"] = [['vtype', 'word', ';']]
        grammar["vtype"] = [['int'], ['char']]
        grammar["block"] = [['{', 'decls', 'slist', '}'], ['']]
        grammar["stat"] = [['IF', 'cond', 'THEN', 'block', 'ELSE', 'block'], ['word', '=', 'expr', ';'], ['EXIT', 'expr', ';']]
        grammar["cond"] = [['expr', "cond'"]]
        grammar["cond'"] = [['<', 'expr']]
        grammar["fact"] = [['num'], ['word']]
        grammar["word"] = [['([a-z] | [A-Z])*']]
        grammar["num"] = [['[0-9]*']]
        grammar["decls"] = [["decls'"]]
        grammar["decls'"] = [['decl', "decls'"], ['']]
        grammar["slist"] = [["slist'"]]
        grammar["slist'"] = [['stat', "slist'"], ['']]
        grammar["expr"] = [['term', "expr'"]]
        grammar["expr'"] = [['+', 'term'], ['']]
        grammar["term"] = [['fact', "term'"]]
        grammar["term'"] = [['*', 'fact'], ['']]
        return grammar

    # non terminal을 얻는다.
    def get_nonterminal(self):
        nonterminal = []
        for key, value in self.grammar.items():
            nonterminal.append(key) # key가 nonterminal
        return nonterminal

    # terminal을 얻는다.
    def get_terminal(self):
        terminal = []
        for key, value in self.grammar.items(): 
            for i in range(len(value)):
                for j in value[i]:
                    if j not in self.nonterminal:
                        terminal.append(j)
        temp_set = set(terminal) 
        terminal = list(temp_set)
        return terminal 

    # first의 정의 그대로 구현됨.
    def set_first(self):
        first = {}
        keys = self.nonterminal
        for key in keys:
            temp_set = set(self.get_first(key))
            first[key] = temp_set
        return first

    # 구해놓은 first값을 불러온다.
    def get_first(self, key):
        first_list = []
        for i in range(len(self.grammar[key])):
            value = self.grammar[key][i][0]
            if value in self.terminal:
                first_list.append(value)
            else:
                first_list.extend(self.get_first(value))
        return first_list

    def set_follow(self):
        follow = {}
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
                                        if i in value[a]:
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
        temp = []
        for types, ids in tokens:
            if types == "word : ":
                temp.append("([a-z] | [A-Z])*")
                self.word_tokens.append(ids)
            elif types == "number":
                temp.append("[0-9]*")
                self.num_tokens.append(ids)
            else:
                temp.append(ids)
        return temp

    def parsing(self, input_txt):
        input_txt = self.tokens2input(input_txt)
        input_txt.append("$")
        terminal = {key : word for word, key in enumerate(self.terminal)}
        non_terminal = {key: word for word, key in enumerate(self.nonterminal)}
        stack = [self.nonterminal[0], '$']

        self.parse_tree = Node(stack[0], None, 0)
        check = False
        
        while stack:
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
                
                
                else: #Finish
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
                        self.parse_tree = self.parse_tree.advance()
                
                else: #Finished
                    check = True
                    break
        if check:
            return None
        else:
            self.parse_tree = self.parse_tree.get_root()
            return self.parse_tree

    def get_symbol_table(self):
        self.symbol_table = self.parse_tree.set_symbol_table()


class Node():
    def __init__(self, data, parent, index, id = None, scope = ["global"]):
        self.data = data
        self.children = []
        self.parent = parent
        self.index = index
        self.id = id
        self.scope = scope
    
    def __repr__(self, level = 0):
        value = self.data
        ret = "depth " + str(level) + ": " + "\t" * level + repr(value)
        ret += "\n"
        for child in self.children:
            ret += child.__repr__(level + 1)
        return ret
    
    def search_inorder(self):
        node = self
        if node.children:
            return node.children[0]
        while node.parent is not None:
            if node.index != len(node.parent.children) -1:
                return node.parent.children[node.index+1]
            node = node.parent
        return 0

    # 입력받은 데이터 리스트의 원소들을 해당 노드의 자식에 추가한다.
    # Node(data=item, parent=self, index=idx) 가 저장된다.
    def set_child(self, data):
        for idx, item in enumerate(data):
            node = Node(item,self, idx)
            self.children.append(node)
        return self.children[0]

    # parse tree에서 dfs 순서로 다음 탐색 노드를 반환한다.
    def advance(self):
        index = self.index
        node = self
        cur = self.parent

        while True:
            if cur != None :
                if len(cur.children)-1 == index:
                    index = cur.index
                    node = cur
                    cur = cur.parent
                else:
                    break
            else:
                return node
        cur = cur.children[index+1]
        while len(cur.children) != 0:
            cur = cur.children[0]
        return cur

    # 모든 노드 출력 ======Printing nodes of the syntax tree======
    # 가장 아래 오른쪽 끝의 노드부터 가장 아래 왼쪽 끝 노드까지 모든 노드를 출력한다.
    def node_print(self):
        node = self
        mem = self
        while mem.children:
            mem = mem.children[-1] # 가장 아래 오른쪽 끝의 위치를 가리킴

        while len(node.children) != 0:
            node = node.children[0] # 가장 아래 왼쪽 끝의 위치를 가리킴
        while node != mem:
            if node.data in ['[0-9]*','([a-z] | [A-Z])*']:
                print(node.id, end= ' ')
            else:
                print(node.data,end=' ')
            node = node.advance()
        print(node.data)

    # 루트를 구한다.
    def get_root(self):
        node = self
        while node.parent != None:
            node = node.parent
        return node

    # 모든 노드를 검사하면서 symbol table을 만든다.
    def set_symbol_table(self):
        node = self
        scope = ["global"]
        symbol_table = []
        while len(node.children) != 0:
            node = node.children[0] #왼쪽 맨 끝의 노드로 이동
        symbol_table.append([node.id, "function", list(scope)])
        scope.append(node.id)
        node = node.advance()
        
        while node.parent is not None:
            if node.data in ["char", "int"]:
                node_type = node.data
                node = node.advance()
                if node.data == "([a-z] | [A-Z])*":
                    symbol_table.append([node.id, node_type, list(scope)])
                    node = node.advance()
                    continue
            elif node.data in ["IF", "WHILE", "ELSE"]:
                scope.append(node.data)
            elif node.data == "}":
                scope.pop()
            node = node.advance()
        return symbol_table

    # str에 해당하는 노드들의 리스트를 반환한다.
    def get_node_with_keyword(self, str):
        set = []
        if self.data == str:
            set.append(self)

        for child in self.children:
            result = child.get_node_with_keyword(str)
            for entry in result:
                set.append(entry)
        return set

    # left 노드를 구한다
    def getleft(self):
        node = self
        while node.index == 0:
            node = node.parent
        return node.parent.children[node.index-1]

    # right 노드를 구한다.
    def getright(self):
        node = self
        while True:
            if(len(node.parent.children) > node.index + 1):
                break
            else:
                node = node.parent
        return node.parent.children[node.index+1]

    
    def get_binarySyntaxTree(self):
        operators = ["=", "+", "*", ">"]
        q = []
        root = None

        for child in self.children: # q에 현재 노드의 자식노드 추가
            q.append(child)

        # bfs를 돌린다.
        while True: 
            node = q.pop(0)
            if node.data in operators: # 데이터가 연산자라면
                if root == None: #즉, 아직 아무 노드도 할당되지 않았다면
                    if node.id:
                        root = Node(node.id, node.parent, node.index, node.id)
                    else:
                        root = Node(node.data, node.parent, node.index, node.id)

                if (len(root.children) == 0): # 루트의 자식이 존재하지 않는다면(즉, 전체 노드가 하나)
                    left = node.getleft()
                    root.children.append(left.get_binarySyntaxTree())
                    right = node.getright()
                    root.children.append(right.get_binarySyntaxTree())

            else: # 데이터가 연산자가 아니라면
                for grandchild in node.children: 
                    q.append(grandchild)

            if len(q) == 0: # q가 비어있다면
                if (root == None):
                    if node.id:
                        root = Node(node.id, node.parent, node.index, node.id)
                    else:
                        root = Node(node.data, node.parent, node.index, node.id)
                break

        return root

