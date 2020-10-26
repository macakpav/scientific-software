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
	@ echo "Only make all, make hello_world and make clean are possible"
hello_module.o: ./hello_module.f95
	if [ ${FC} = ifort ]; then \
		cp hello_module.f95 hello_module.f90; \
	fi
	$(FC) -c $(FFLAGS) hello_module.$(ext)
	if [ ${FC} = ifort ]; then \
		rm hello_module.f90; \
	fi

# Only do the compiling
hello_world.o: ./hello_world.f95 ./hello_module.o
	if [ ${FC} = ifort ]; then \
		cp hello_world.f95 hello_world.f90; \
	fi
	$(FC) -c $(FFLAGS) hello_world.$(ext)
	if [ ${FC} = ifort ]; then \
		rm hello_world.f90; \
	fi

hello_world: hello_world.o
	$(FC) -o hello_world.exe hello_module.o hello_world.o

all: hello_world
	./hello_world.exe

# Read as: remove all interim files and hello_world, option -f makes sure nothing is printed when this already happened.
clean:
	@ rm -f *.exe *.o *.mod $(r)

# To use when you want to force compilation when `hello_world' already exists:
#.PHONY: hello_world

