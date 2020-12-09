# Variable for the selected compiler (see $ fortrancompilers)
CC=clang++# g95 gfortran ifort nagfor 
optimize=false

# Possible debug flags per compiler
CFLAGS_g++ = -std=c++17 -g -Wall -Wextra -Werror
CFLAGS_clang++ = -std=c++17 -g -Wall -Wextra -Werror
# Optimization flags
CFLAGS_g++_opt = -O3 -DNDEBUG -std=c++17
CFLAGS_clang++_opt = -O3 -DNDEBUG -std=c++17

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
	@ echo "Only make all, make run, make test_cg and make clean are possible"

# Compile and link everything from scratch
all: clean 

run: test_cg
	./test_cg.exe

question1.o: ./question1.cpp ./vector.hpp ./matrix.hpp ./matvec_expression.hpp
	$(CC) -c  $(CFLAGS) question1.cpp

q1: question1.o
	$(CC) -o question1.exe question1.o
	./question1.exe

question2.o: ./question2.cpp ./vector.hpp ./matrix.hpp ./matvec_expression.hpp
	$(CC) -c  $(CFLAGS) -DEXPR question2.cpp

q2: question2.o
	$(CC) -o question2.exe question2.o
	./question2.exe

# Read as: remove all interim files
clean:
	@ rm -f $(r)
	@ clear

