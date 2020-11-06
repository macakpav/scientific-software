# Variable for the selected compiler (see $ fortrancompilers)
FC=gfortran# g95 gfortran ifort nagfor 
NAME=mm_driver

# TIP: the following flags can be interesting to detect errors:
# Possible compilation flags per compiler
FFLAGS_gfortran = -O3 -g -pedantic -Wall -Wimplicit-interface -Wunderflow -fbounds-check -fimplicit-none
FFLAGS_ifort    = -g -debug full -heap-arrays -implicitnone -check -warn -free -Tf 
FFLAGS_nagfor   = -g -C=all -gline -u -info -colour -kind=byte


# Select the right flags for the current compiler
FFLAGS=$(FFLAGS_$(FC))
ext = f90
#-----------------------------------------------------------------------------------------
default:
	@ echo "Only make all, make $(NAME) and make clean are possible"

matrixop.o: ./matrixop.$(ext)
	$(FC) -c $(FFLAGS) matrixop.$(ext)

timings.o: ./timings.$(ext)
	$(FC) -c $(FFLAGS) timings.$(ext)

mm_driver.o: ./mm_driver.$(ext) ./matrixop.o ./timings.o
	$(FC) -c $(FFLAGS) mm_driver.$(ext)

mm_driver: mm_driver.o
	$(FC) -o mm_driver.exe timings.o matrixop.o mm_driver.o -lblas

all: clean mm_driver 
	./mm_driver.exe


# Read as: remove all interim files and hello_world, option -f makes sure nothing is printed when this already happened.
clean:
	@ rm -f *.exe *.o *.mod $(r)
	@ clear

# To use when you want to force compilation when `hello_world' already exists:
#.PHONY: hello_world

