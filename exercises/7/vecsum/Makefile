# Additional commands used in exercise:
# for i in `seq 1 20`; do ./question1.exe $((2**$i)) 100 5 ; done | tee sum.out
# for i in `seq 1 20`; do ./question1.exe $((2**$i)) 100 5; done | tee sum_O3.out
# pdflatex -shell-escape -interaction=nonstopmode plot.tex

# Variable for the selected compiler (see $ fortrancompilers)
CC=g++# g95 gfortran ifort nagfor 
NAME=question1
optimize=true

# Possible debug flags per compiler
CFLAGS_g++ = -g -Wall -Werror -std=c++17

# Optimization flags
CFLAGS_g++_opt = -O3 -DNDEBUG -std=c++17

# Select the right flags for the current compiler
ifeq ($(optimize) , true)
	CFLAGS=$(CFLAGS_$(CC)_opt)
else
	CFLAGS=$(CFLAGS_$(CC))
endif
# Extension of compieled files
ext=cpp
# Items to remove with make clean
r=*.exe *.o
#-----------------------------------------------------------------------------------------
default:
	@ echo "Only make all, make $(NAME) and make clean are possible"

run: $(NAME)
	./$(NAME).exe 10 10 2
library.o: ./library.hpp ./library.cpp
	$(CC) -c $(CFLAGS) library.cpp

$(NAME).o: ./$(NAME).$(ext) ./library.hpp
	$(CC) -c $(CFLAGS) $(NAME).$(ext)

$(NAME): $(NAME).o library.o
	$(CC) -o $(NAME).exe $(NAME).o library.o

# Compile and link everything from scratch
all: clean $(NAME) 
	./$(NAME).exe 10 10 2

pdf: ./sum.out ./sum_O3.out
	@pdflatex -shell-escape -interaction=nonstopmode plot.tex


# Read as: remove all interim files
clean:
	@ rm -f $(r)
	@ clear

