from lexical import scanner
from LLparser import parser
from semantic import semantic
from code_generator import code_generator
import os
import sys

inputfile = sys.argv
if len(inputfile)==1:
    print("No inputfile")
file = inputfile[1]

if __name__ == "__main__":
    fname = "./{}.txt".format(file)
    with open(fname, 'r') as txt:
        code = txt.read()

    scan = scanner(code)
    scan.lexical()
    token = scan.tokens
    print("================Tokens==================")
    for i in token:
        print(i)
    print()

    parsing = parser(token, "grammar.txt")
    grammar = parsing.grammar

    print("================LL grammar==================")
    for key, value in grammar.items():
        print(key, value)
    print()

    print("================Non-terminal==================")
    print(parsing.nonterminal)
    print()

    print("================Terminal==================")
    print(parsing.terminal)
    print()

    first = parsing.first
    print("================First==================")
    for key, value in first.items():
        print(key, value)
    print()

    follow = parsing.follow
    print("================Follow==============")
    for key, value in follow.items():
        print(key, value)
    print()

    # finished getting first and follow

    table = parsing.table
    print("================Table==============")
    for row in range(parsing.num_row):
        for col in range(parsing.num_col):
            print(parsing.table[row][col], end=' ')
        print()
    print("================Table Ends==============")
    print()

    # making tokens to inputs to be used in parsing step
    input_list = parsing.tokens2input(token)
    # actual parsing using input_list and parsing table
    parse_result_tree = parsing.parsing(input_list)
    print("============Parsing tree============")
    print(parse_result_tree)
    if parse_result_tree:
        print("======Printing nodes of the syntax tree======")
        parse_result_tree.node_print()
    else:
        print("This input is rejected")
    print()

    parsing.get_symbol_table()
    semantics = semantic(parsing)
    semantics.type_check()
    ir = semantics.get_IR()
    print("=======Intermediate representation========")
    for i, r in enumerate(ir):
        print(str(i) + ". " + r[0])
    print()

    gen = code_generator(ir)
    code = gen.generate()

    with open("{}.symbol".format(file),"w") as sb_table:
        sb_table.write("Symbol Table, {}\n".format(file))
        for s in parsing.symbol_table:
            sb_table.write("name : "+s[0])
            sb_table.write("\n{\ttype : "+s[1])
            sb_table.write("\n\tscope : "+s[2][0])
            for s2 in s[2][1:]:
                sb_table.write(" -> "+s2)
            sb_table.write(" }\n\n")
    with open("{}.code".format(file),"w") as final_code:
        final_code.write("Generating codes, {}\n".format(file))
        for c in code:
            final_code.write(c+"\n")
        final_code.write("\n")
        final_code.write("Number of Used Register (except rax) :{}".format(gen.cnt))