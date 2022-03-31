#!/usr/bin/env python
from lexical import scanner
from parser import parser
from semantic import semantic

class code_generator():
    def __init__(self,IR):
        self.IR = IR
        self.operator = ["=","+","*","<"]
        self.cnt = 1

    def generate(self):
        self.code = []
        for x in self.IR:
            if x[1] is None:
                if x[0][:4] == "goto":
                    self.code.append("  JUMP         {}".format(x[0][5:]))
                else:
                    self.code.append(x[0])

            elif x[1]:
                self.num = 1
                binary_tree = self.get_bt(x[1])
                binary_tree.id = 1
                self.numofReg(binary_tree)
                self.code_writer(x[0], binary_tree)
        return self.code

    def code_writer(self,ir,node):  # sourcery no-metrics
        nid = "Reg#" + str(node.id)

        if node.children:
            self.code_writer_real(node, nid, ir)
        elif ir[:4] == "EXIT":
            self.code.append("  LD    rax,  -1")
        elif str(node.id).isdigit():
            self.code.append("  LD    Reg#{}, {}".format(node.id,node.data))

    def code_writer_real(self, node, nid, ir):
        left = node.children[0]
        right = node.children[1]
        lid = "Reg#" + str(left.id)
        rid = "Reg#" + str(right.id)
        if not left.children:
            if node.data != "=":
                self.code_writer("",left)
            self.code_writer("",right)

        elif not right.children:
            self.code_writer("",left)
        else:
            self.code_writer("",left)
            self.code_writer("",right)
        if node.data == "+":
            self.code.append("  ADD   {}, {}, {}".format(nid,lid,rid))
        elif node.data == "*":
            self.code.append("  MUL   {}, {}, {}".format(nid,lid,rid))
        elif node.data == "=":
            self.code.append("  ST    {}, {}".format(rid, left.data))

        else: #<
            self.code.append("  LT    {}, {}, {}".format(nid,lid,rid))
            self.code.append("  JUMPT {}, {}".format(nid, ir.split("goto")[-1][1:]))

    def get_bt(self,node):
        return node.get_binarySyntaxTree()

    def numofReg(self,node):
        if not node.children:
            return
        leftchild = node.children[0]
        rightchild = node.children[1]
        if node.data == "=":
            rightchild.id = node.id
            self.numofReg(rightchild)

        elif not rightchild.children:
            self.numofReg_sub(node, leftchild, rightchild)
            
        elif not leftchild.children:
            leftchild.id = node.id + 1
            rightchild.id = node.id
            self.cnt = max(self.cnt, leftchild.id)
            self.numofReg(rightchild)
        else:
            self.numofReg_sub(node, leftchild, rightchild)
            self.numofReg(rightchild)

    def numofReg_sub(self, node, left, right):
        left.id = node.id
        right.id = node.id+1
        self.cnt = max(self.cnt, right.id)
        self.numofReg(left)