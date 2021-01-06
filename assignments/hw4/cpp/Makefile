# Makefile for 4th assignment
#-----------------------------------------------------------------------------------------
# Variable for the selected compiler
CC=clang++# g++ clang++

# set to false to debug, true to optimize
optimize=true

# folder system
bin_folder=
obj_folder=obj/
src_folder=src/

# Possible debug flags per compiler
CFLAGS_g++ = -std=c++17 -g -Wall -Wextra -Werror
CFLAGS_clang++ = -std=c++17 -g -Wall -Wextra -Werror -DDLVL2
# Optimization flags
CFLAGS_g++_opt = -std=c++17 -O3 -DNDEBUG
CFLAGS_clang++_opt = -std=c++17 -O3 -DNDEBUG

# Select the right flags for the current compiler
ifeq ($(optimize) , true)
	CFLAGS=$(CFLAGS_$(CC)_opt)
else
	CFLAGS=$(CFLAGS_$(CC))
endif

# Items to remove with make clean
r=$(obj_folder)*.o $(bin_folder)*.exe
#-----------------------------------------------------------------------------------------
default:
	@ echo "Only make all, make allrun, make run1,2,3,4 and make clean are possible"

all: clean simulation1 simulation2 estimation1 estimation2
allrun: all run1 run2 run3 run4
clean:
	@ rm -f $(r)
	@ clear

test: clean ./$(src_folder)test.cpp
	$(CC) -c $(CFLAGS_$(CC)) ./$(src_folder)test.cpp -o ./$(obj_folder)test.o
	$(CC) -o ./$(bin_folder)test.exe ./$(obj_folder)test.o
	./$(bin_folder)test.exe

./$(obj_folder)simulation1.o: ./$(src_folder)simulation1.cpp ./$(src_folder)debug_levels.hpp ./$(src_folder)siqrd/*.hpp ./$(src_folder)ode/*.hpp ./$(src_folder)saving/*.hpp
	$(CC) -c  $(CFLAGS) ./$(src_folder)simulation1.cpp -o ./$(obj_folder)simulation1.o

simulation1: ./$(obj_folder)simulation1.o
	$(CC) -o ./$(bin_folder)simulation1.exe ./$(obj_folder)simulation1.o

run1: simulation1
	./$(bin_folder)simulation1.exe 100 100

./$(obj_folder)simulation2.o: ./$(src_folder)simulation2.cpp ./$(src_folder)debug_levels.hpp ./$(src_folder)siqrd/*.hpp ./$(src_folder)ode/*.hpp ./$(src_folder)saving/*.hpp
	$(CC) -c  $(CFLAGS) ./$(src_folder)simulation2.cpp -o ./$(obj_folder)simulation2.o

simulation2: ./$(obj_folder)simulation2.o
	$(CC) -o ./$(bin_folder)simulation2.exe ./$(obj_folder)simulation2.o

run2: simulation2
	./$(bin_folder)simulation2.exe 50000 500

./$(obj_folder)estimation1.o: ./$(src_folder)estimation1.cpp ./$(src_folder)debug_levels.hpp ./$(src_folder)siqrd/*.hpp ./$(src_folder)ode/*.hpp ./$(src_folder)saving/*.hpp ./$(src_folder)optimization/*.hpp
	$(CC) -c  $(CFLAGS) $(src_folder)estimation1.cpp -o ./$(obj_folder)estimation1.o

estimation1: ./$(obj_folder)estimation1.o
	$(CC) -o ./$(bin_folder)estimation1.exe ./$(obj_folder)estimation1.o

run3: estimation1
	./$(bin_folder)estimation1.exe

./$(obj_folder)bench_time.o: ./$(src_folder)bench_time.cpp ./$(src_folder)debug_levels.hpp ./$(src_folder)siqrd/*.hpp ./$(src_folder)ode/*.hpp ./$(src_folder)saving/*.hpp ./$(src_folder)optimization/*.hpp
	$(CC) -c  $(CFLAGS_$(CC)_opt) -DNINFO ./$(src_folder)bench_time.cpp -o ./$(obj_folder)bench_time.o

bench_time: ./$(obj_folder)bench_time.o
	$(CC) -o ./$(bin_folder)bench_time.exe ./$(obj_folder)bench_time.o

time: clean bench_time
	./$(bin_folder)bench_time.exe


./$(obj_folder)bench_mem.o: ./$(src_folder)bench_mem.cpp ./$(src_folder)debug_levels.hpp ./$(src_folder)siqrd/*.hpp ./$(src_folder)ode/*.hpp ./$(src_folder)saving/*.hpp ./$(src_folder)optimization/*.hpp
	g++ -c -std=c++17 -Wall -ggdb3 -DNDEBUG ./$(src_folder)bench_mem.cpp -o ./$(obj_folder)bench_mem.o

bench_mem: ./$(obj_folder)bench_mem.o
	g++ -o ./$(bin_folder)bench_mem.exe ./$(obj_folder)bench_mem.o

mem: clean bench_mem
	@valgrind ./$(bin_folder)bench_mem.exe

prof: clean bench_mem
	./$(bin_folder)bench_mem.exe
	gprof bench_mem.exe > analysis.txt

./$(obj_folder)estimation2.o: ./$(src_folder)estimation2.cpp ./$(src_folder)debug_levels.hpp ./$(src_folder)siqrd/*.hpp ./$(src_folder)ode/*.hpp ./$(src_folder)saving/*.hpp ./$(src_folder)optimization/*.hpp
	$(CC) -c  $(CFLAGS) ./$(src_folder)estimation2.cpp -o ./$(obj_folder)estimation2.o

estimation2: ./$(obj_folder)estimation2.o
	$(CC) -o ./$(bin_folder)estimation2.exe ./$(obj_folder)estimation2.o

run4: estimation2
	./$(bin_folder)estimation2.exe

# pdf: plot

# plot:
# 	@ pdflatex plot.tex > /dev/null


