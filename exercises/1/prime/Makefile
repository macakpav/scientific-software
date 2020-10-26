# Variable for the selected compiler (see $ fortrancompilers)
FC=gfortran

# TIP: the following flags can be interesting to detect errors:
# Possible compilation flags per compiler
FFLAGS_g95      = -g -pedantic -Wall -fbounds-check -ftrace=full
FFLAGS_gfortran = -g -pedantic -Wall -Wimplicit-interface -Wunderflow -fbounds-check -fimplicit-none
FFLAGS_ifort    = -g -debug full -implicitnone -check -warn -free -Tf
FFLAGS_nagfor   = -g -C=all -gline -u -info -colour


# Select the right flags for the current compiler
FFLAGS=$(FFLAGS_$(FC))

ifeq ($(FC) , ifort)
	ext = f90
else
	ext = f95
endif

#-----------------------------------------------------------------------------------------
default:
	@ echo "Only make all, make prime and make clean are possible"
prime_module.o: ./prime_module.f95
	if [ ${FC} = ifort ]; then \
		cp prime_module.f95 prime_module.f90; \
	fi
	$(FC) -c $(FFLAGS) prime_module.$(ext)
	if [ ${FC} = ifort ]; then \
		rm prime_module.f90; \
	fi

# Only do the compiling
prime.o: ./prime.f95 ./prime_module.o
	if [ ${FC} = ifort ]; then \
		cp prime.f95 prime.f90; \
	fi
	$(FC) -c $(FFLAGS) prime.$(ext)
	if [ ${FC} = ifort ]; then \
		rm prime.f90; \
	fi

prime: prime.o
	$(FC) -o prime.exe prime_module.o prime.o

all: prime
	./prime.exe

# Read as: remove all interim files and hello_world, option -f makes sure nothing is printed when this already happened.
clean:
	@ rm -f *.exe *.o *.mod $(r)

# To use when you want to force compilation when `hello_world' already exists:
#.PHONY: hello_world

