#!/usr/bin/env python
from lexical import scanner
from parser import parser

class semantic():
    def __init__(self,after_parsing):
        self.cur = 0
        self.goto_index = 1
        self.after_parsing = after_parsing
        self.mainfunc = after_parsing.parse_tree.children[0].children[0].id

    def type_check(self):  
        symbols = [s[0] for s in self.after_parsing.symbol_table]
        symbol_set = {s[0]: s[1] for s in self.after_parsing.symbol_table}
        vartype = '' # variable type
        dectype = '' # declared type
        if len(symbols) != len(set(symbols)):
            print("Syntax error")
            exit()
        node = self.after_parsing.parse_tree
        while len(node.children) != 0:
            node = node.children[0]
        node = node.advance()

        while node.parent is not None:
            if node.data == "([a-z] | [A-Z])*":
                vartype = symbol_set[node.id]
            else:
                dectype = node.data
            node = node.advance()

    def get_IR(self):
        representation = [["BEGIN {0}".format(self.mainfunc), None]]
        representation += self.construct_IR(self.after_parsing.parse_tree)
        representation += [["END {0}".format(self.mainfunc), None]]
        return representation

    def construct_IR(self, node):
        self.cur = node
        ir = []
        last_leafnode = node
        while last_leafnode.children:
            last_leafnode = last_leafnode.children[-1]

        while self.cur != last_leafnode:
            if self.cur.data == "stat":
                n = self.cur.children[0]

                if n.data == "word":
                    ir.append([self.mode_WORD(n), self.cur])
                elif n.data == "EXIT":
                    ir.append([self.mode_EXIT(n),self.cur])
                elif n.data == "IF":
                    ir += self.mode_IF()

            self.cur = self.cur.search_inorder()
        return ir

    def ConditionAdder(self, cond):
        result = ''
        while cond.children:
            cond = cond.children[0]
        while cond.data != '{':
            if cond.id:
                result += ' ' + cond.id
            elif cond.data:
                result += ' ' + cond.data
            cond = cond.advance()
        return result

    def mode_IF(self):
        tempir = []
        label1 = str(self.goto_index)
        label2 = str(self.goto_index + 1)
        self.goto_index += 2

        cond = self.cur.children[1]
        cond_ir = self.cur.children[1]
        then_block = self.cur.children[3]
        else_block = self.cur.children[5]

        then_ir = self.construct_IR(then_block)
        else_ir = self.construct_IR(else_block)

        condition = self.ConditionAdder(cond)
        tempir.append(["if{} goto L{}".format(condition,label1), cond_ir])
        tempir += else_ir
        tempir.append(["goto L{}".format(label2), None])
        tempir.append(["L{}".format(label1), None])
        tempir += then_ir
        tempir.append(["L{}".format(label2), None])
        return tempir


    def mode_WORD(self,node):
        ir = node.children[0].id
        while node.data != ";":
            node = node.advance()
            ir += " " + node.id if node.id is not None else " " + node.data
        return ir[:-2]

    def mode_EXIT(self,node):
        ir = node.data
        while node.data != ";":
            node = node.advance()
            ir += " " + node.id if node.id is not None else " " + node.data
        return ir[:-2]