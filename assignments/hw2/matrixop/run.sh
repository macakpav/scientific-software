#!/usr/bin/env bash
exe=q10noblock
valgrind --tool=cachegrind ./${exe}.exe s 25
valgrind --tool=cachegrind ./${exe}.exe s 100
valgrind --tool=cachegrind ./${exe}.exe s 500

valgrind --tool=cachegrind ./${exe}.exe f 25
valgrind --tool=cachegrind ./${exe}.exe f 100
valgrind --tool=cachegrind ./${exe}.exe f 500
