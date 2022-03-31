#!/usr/bin/env python
class Node():
    def __init__(self,data, parent, index, id = None, scope = ["global"]):
        self.data = data
        self.children = []
        self.parent = parent
        self.index = index
        self.id = id
        self.scope = scope
    
    def __repr__(self, level = 0):
        value = self.data
        ret = str(level) + "|" + "\t" * level + repr(value)
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

    def set_child(self, data):
        for idx, item in enumerate(data):
            node = Node(item,self, idx)
            self.children.append(node)
        return self.children[0]

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

    def node_print(self):
        node = self
        mem = self
        while mem.children:
            mem = mem.children[-1]

        while len(node.children) != 0:
            node = node.children[0]
        while node != mem:
            if node.data in ['[0-9]*','([a-z] | [A-Z])*']:
                print(node.id, end= ' ')
            else:
                print(node.data,end=' ')
            node = node.advance()
        print(node.data)

    def get_root(self):
        node = self
        while node.parent != None:
            node = node.parent
        return node

    def set_symbol_table(self):
        node = self
        scope = ["global"]
        symbol_table = []
        while len(node.children) != 0:
            node = node.children[0]
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

    def get_node_with_keyword(self, str):
        set = []
        if self.data == str:
            set.append(self)

        for child in self.children:
            result = child.get_node_with_keyword(str)
            for entry in result:
                set.append(entry)
        return set

    def getleft(self):
        node = self
        while node.index == 0:
            node = node.parent
        return node.parent.children[node.index-1]

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

        for child in self.children:
            q.append(child)

        while True:
            node = q.pop(0)
            if node.data in operators:
                if root == None:
                    if node.id:
                        root = Node(node.id, node.parent, node.index, node.id)
                    else:
                        root = Node(node.data, node.parent, node.index, node.id)

                if (len(root.children) == 0):
                    left = node.getleft()
                    root.children.append(left.get_binarySyntaxTree())
                    right = node.getright()
                    root.children.append(right.get_binarySyntaxTree())

            else:
                for grandchild in node.children:
                    q.append(grandchild)

            if len(q) == 0:
                if (root == None):
                    if node.id:
                        root = Node(node.id, node.parent, node.index, node.id)
                    else:
                        root = Node(node.data, node.parent, node.index, node.id)
                break

        return root


