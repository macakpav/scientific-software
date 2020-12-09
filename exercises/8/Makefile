# Variable for the selected compiler (see $ fortrancompilers)
CC=g++# g95 gfortran ifort nagfor 
optimize=false

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
	@ echo "Only make all, make run, make test_cg and make clean are possible"

# Compile and link everything from scratch
all: clean test_cg

q5: question5
	./question5.exe

run: test_cg
	./test_cg.exe

question5.o: ./question5.cpp
	$(CC) -c  $(CFLAGS) question5.cpp

question5: question5.o
	$(CC) -o question5.exe question5.o

test_cg.o: ./test_cg.cpp
	$(CC) -c $(CFLAGS) test_cg.cpp

test_cg: ./test_cg.o
	$(CC) -o test_cg.exe test_cg.o

# Read as: remove all interim files
clean:
	@ rm -f $(r)
	@ clear

