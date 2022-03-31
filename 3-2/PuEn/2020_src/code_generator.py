#!/usr/bin/env python
from lexical import scanner
from LLparser import parser
from semantic import semantic

class code_generator():
    def __init__(self,IR):
        self.IR = IR
        self.operator = ["=", "+","*",">"]
        self.cnt = 1

    def generate(self):
        self.code = []
        for x in self.IR:
            if x[1] == None:
                if x[0][:4] == "goto":
                    self.code.append("  JUMP           " + x[0][5:])
                else:
                    self.code.append(x[0])

            else:
                if x[1]:
                    self.num = 1
                    binary_tree = self.get_bt(x[1])
                    binary_tree.id = 1
                    self.register_num(binary_tree)
                    self.w_code(x[0], binary_tree)
        return self.code

    def w_code(self,ir,node):
        nid = "Reg#" + str(node.id)

        if node.children:
            left = node.children[0]
            right = node.children[1]
            lid = "Reg#" + str(left.id)
            rid = "Reg#" + str(right.id)
            if not left.children:
                if node.data != "=":
                    self.w_code("",left)
                self.w_code("",right)

                if node.data == "+":
                    self.code.append("  ADD   {},   {},   {}".format(nid,lid,rid))
                elif node.data == "*":
                    self.code.append("  MUL   {},   {},   {}".format(nid,lid,rid))
                elif node.data == "=":
                    self.code.append("  ST    {},   {}".format(rid, left.data))

                else:
                    self.code.append("  LT    {},   {},   {}".format(nid,lid,rid))
                    self.code.append("  JUMPT {},   {}".format(nid, ir.split("goto")[-1][1:]))
            elif not right.children:
                self.w_code("",left)
                if node.data == "+":
                    self.code.append("  ADD   {},   {},   {}".format(nid,lid,rid))
                elif node.data == "*":
                    self.code.append("  MUL   {},   {},   {}".format(nid,lid,rid))
                elif node.data == "=":
                    self.code.append("  ST    {},   {}".format(rid, left.data))

                else:  # >
                    self.code.append("  LT    " + nid + ",   "  + rid + ",   "  + lid)
                    self.code.append("  JUMPT " + nid + ",   "  + ir.split("goto")[-1][1:])

            else:
                self.w_code("",left)
                self.w_code("",right)
                if node.data == "+":
                    self.code.append("  ADD   " + nid + ",   "  + lid + ",   "  + rid)
                elif node.data == "*":
                    self.code.append("  MUL   " + nid + ",   "  + lid + ",   "  + rid)
                elif node.data == "=":
                    self.code.append("  ST    {},   {}".format(rid, left.data))

                else:  # >
                    self.code.append("  LT    {},   {},   {}".format(nid,lid,rid))
                    self.code.append("  JUMPT {},   {}".format(nid, ir.split("goto")[-1][1:]))
        elif ir[:4] == "EXIT":
            self.code.append("  LD    rax,   -1")
        elif str(node.id).isdigit():
            self.code.append("  LD    " + "Reg#{}".format(node.id) + ",   "+node.data)

    def get_bt(self,node):
        return node.get_binarySyntaxTree()

    def register_num(self,node):
        if node.children:
            left = node.children[0]
            right = node.children[1]
            if node.data == "=":
                right.id = node.id
                self.register_num(right)
            elif not right.children:
                left.id = node.id
                right.id = node.id+1
                self.cnt = max(self.cnt, right.id)
                self.register_num(left)
            elif not left.children:
                left.id = node.id + 1
                right.id = node.id
                self.cnt = max(self.cnt, left.id)
                self.register_num(right)
            else:
                left.id = node.id
                right.id = node.id + 1
                self.cnt = max(self.cnt, right.id)
                self.register_num(left)
                self.register_num(right)