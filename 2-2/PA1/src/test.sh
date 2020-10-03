#!/bin/bash

gcc -o test test.c
./test plot.txt
# ./test $1

# diff output.txt answer.txt > result.txt;
# make clean;
