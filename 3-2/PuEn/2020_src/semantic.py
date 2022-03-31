#!/usr/bin/env python
from lexical import scanner
from LLparser import parser

class semantic():
    def __init__(self,after_parsing):
        self.after_parsing = after_parsing
        self.goto_index = 1
        self.cur = 0
        self.mainfunc = after_parsing.parse_tree.children[0].children[0].id

    def type_check(self):
        symbols = [s[0] for s in self.after_parsing.symbol_table]
        symbol_set = {s[0]: s[1] for s in self.after_parsing.symbol_table}
        if len(symbols) != len(set(symbols)):
            print("Syntax error - same variable cannot be declared multiple times")
            exit()
        node = self.after_parsing.parse_tree
        while len(node.children) != 0:
            node = node.children[0]
        node = node.advance()

        variable_type = ''
        declared_type = ''
        while node.parent is not None:
            if node.data == "([a-z] | [A-Z])*":
                try:
                    variable_type = symbol_set[node.id]
                except KeyError:
                    print("Undeclared variable -", node.id, "is not declared")
                    exit()
                if declared_type in ["char", "int"] and variable_type != declared_type:
                    print("Type error - type mismatching")
                    exit()
            elif node.data in ["int", "char"]:
                declared_type = node.data
            else:
                declared_type = ''
            node = node.advance()

    def get_IR(self):
        ir = [["BEGIN " + self.mainfunc, None]]
        ir += self.construct_IR(self.after_parsing.parse_tree)
        ir += [["END " + self.mainfunc, None]]
        return ir

    def construct_IR(self, node):
        self.cur = node
        ir = []
        last_leafnode = node
        while last_leafnode.children:
            last_leafnode = last_leafnode.children[-1]

        while self.cur != last_leafnode:
            if self.cur.data == "stat":
                n = self.cur.children[0]

                if n.data in ["word", "EXIT"]:
                    ir.append([self.WORD_or_EXIT(n), self.cur])
                elif n.data == "WHILE":
                    if self.cur.children[2].children:
                        ir += self.WHILEcode()
                else:
                    ir += self.IFcode()
            self.cur = self.cur.search_inorder()
        return ir

    def IFcode(self):
        ir = []
        label1 = str(self.goto_index)
        label2 = str(self.goto_index + 1)
        self.goto_index += 2

        cond = self.cur.children[1]
        cond_ir = self.cur.children[1]
        then_block = self.cur.children[3]
        else_block = self.cur.children[5]

        then_ir = self.construct_IR(then_block)
        else_ir = self.construct_IR(else_block)

        condition = ""
        while cond.children:
            cond = cond.children[0]
        while cond.data != "{":
            if cond.id:
                condition += " " + cond.id
            elif cond.data:
                condition += " " + cond.data
            cond = cond.advance()

        ir.append(["if" + condition + " goto L" + label1, cond_ir])
        ir += else_ir
        ir.append(["goto L" + label2, None])
        ir.append(["L" + label1, None])
        ir += then_ir
        ir.append(["L"+label2, None])
        return ir

    def WHILEcode(self):
        ir = []
        label1 = str(self.goto_index)
        label2 = str(self.goto_index + 1)
        ir.append(["goto L" + label2, None])
        ir.append(["L" + label1, None])
        self.goto_index += 2

        cond = self.cur.children[1]
        cond_ir = self.cur.children[1]
        block = self.cur.children[2]
        ir += self.construct_IR(block)

        condition = ""
        while cond.children:
            cond = cond.children[0]
        while cond.data != "{":
            if cond.id:
                condition += " " + cond.id
            elif cond.data:
                condition += " " + cond.data
            cond = cond.advance()
        ir.append(["L" + label2, None])
        ir.append(["if" + condition + " goto L" + label1, cond_ir])
        return ir

    def WORD_or_EXIT(self,node):
        if node.data == "EXIT":
            ir = node.data
        else:
            ir = node.children[0].id
        while node.data != ";":
            node = node.advance()
            if node.id is not None:
                ir += " " + node.id
            else:
                ir += " " + node.data
        return ir[:-2]
