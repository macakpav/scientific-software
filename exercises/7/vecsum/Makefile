# Variable for the selected compiler (see $ fortrancompilers)
CC=g++# g95 gfortran ifort nagfor 
NAME=NAME

# TIP: the following flags can be interesting to detect errors:
# Possible compilation flags per compiler
CFLAGS_g++ = -Wall -Werror -std=c++17 -O3
#-DNDEBUG

# Select the right flags for the current compiler
CFLAGS=$(CFLAGS_$(CC))
# Extension of compieled files
ext=.cpp
# Items to remove with make clean
r=*.exe *.o
#-----------------------------------------------------------------------------------------
default:
	@ echo "Only make all, make $(NAME) and make clean are possible"

$(NAME).o: ./$(NAME).$(ext) ./$(NAME).hpp
	$(CC) -c $(CFLAGS) $(NAME).$(ext)

$(NAME): $(NAME).o
	$(CC) -o $(NAME).exe $(NAME).o

# Compile and link everything from scratch
all: clean $(NAME) 
	./$(NAME).exe


# Read as: remove all interim files
clean:
	@ rm -f $(r)
	@ clear

