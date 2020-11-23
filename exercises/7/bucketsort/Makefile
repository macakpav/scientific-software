# Additional commands used in exercise:
# for i in `seq 2 20`; do ./main.exe $((2**$i)) 100.0 100 10 ; done | tee sort.out
# for i in `seq 2 20`; do ./main.exe $((2**$i)) 100.0 100 10 ; done | tee sort_O3.out
# for i in `seq 2 20`; do ./main.exe $((2**$i)) 100.0 100 10 ; done | tee sortSTD.out
# for i in `seq 2 20`; do ./main.exe $((2**$i)) 100.0 100 10 ; done | tee sortSTD_O3.out
# pdflatex -shell-escape -interaction=nonstopmode plot.tex

# Variable for the selected compiler (see $ fortrancompilers)
CC=g++# g95 gfortran ifort nagfor 
optimize=false
mainLibName=bucket

# Possible debug flags per compiler
CFLAGS_g++ = -std=c++17 -g -Wall -Wextra -Werror
# Optimization flags
CFLAGS_g++_opt = -O3 -DNDEBUG -std=c++17

# Select the right flags for the current compiler
ifeq ($(optimize) , true)
	CFLAGS=$(CFLAGS_$(CC)_opt)
else
	CFLAGS=$(CFLAGS_$(CC))
endif

# Items to remove with make clean
r=*.exe *.o
#-----------------------------------------------------------------------------------------
default:
	@ echo "Only make all, make run, make main and make clean are possible"

# Compile and link everything from scratch
all: clean main

run: main
	./main.exe 32 100.0 100 10

bucket_sorter.o: ./bucket_sorter.cpp
	$(CC) -c $(CFLAGS) bucket_sorter.cpp

library.o: ./library.hpp ./library.cpp
	$(CC) -c $(CFLAGS) library.cpp

$(mainLibName).o: ./$(mainLibName).hpp ./$(mainLibName).cpp
	$(CC) -c $(CFLAGS) $(mainLibName).cpp

main.o: ./main.cpp ./$(mainLibName).hpp ./library.hpp
	$(CC) -c $(CFLAGS) main.cpp

main: ./main.o ./$(mainLibName).o ./library.o ./bucket_sorter.o
	$(CC) -o main.exe main.o $(mainLibName).o library.o bucket_sorter.o

pdf:
	pdflatex -shell-escape -interaction=nonstopmode plot.tex

# Read as: remove all interim files
clean:
	@ rm -f $(r)
	@ clear

