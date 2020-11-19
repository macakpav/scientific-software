#!/bin/bash

sed 's/optimize=false/optimize=true/' Makefile -i
make all
for i in `seq 1 20`; do ./question1.exe $((2**$i)) 100 5; done | tee sum_O3.out

sed 's/optimize=true/optimize=false/' Makefile -i
make all
for i in `seq 1 20`; do ./question1.exe $((2**$i)) 100 5 ; done | tee sum.out

make pdf