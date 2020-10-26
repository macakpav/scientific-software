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
	@ echo "Only make all, make matrix_stats and make clean are possible"
matrix_module.o: ./matrix_module.f95
	if [ ${FC} = ifort ]; then \
		cp matrix_module.f95 matrix_module.f90; \
	fi
	$(FC) -c $(FFLAGS) matrix_module.$(ext)
	if [ ${FC} = ifort ]; then \
		rm matrix_module.f90; \
	fi

# Only do the compiling
matrix_stats.o: ./matrix_stats.f95 ./matrix_module.o
	if [ ${FC} = ifort ]; then \
		cp matrix_stats.f95 matrix_stats.f90; \
	fi
	$(FC) -c $(FFLAGS) matrix_stats.$(ext)
	if [ ${FC} = ifort ]; then \
		rm matrix_stats.f90; \
	fi

matrix_stats: matrix_stats.o
	$(FC) -o matrix_stats.exe matrix_module.o matrix_stats.o

all: matrix_stats
	./matrix_stats.exe

# Read as: remove all interim files and hello_world, option -f makes sure nothing is printed when this already happened.
clean:
	@ rm -f *.exe *.o *.mod $(r)

# To use when you want to force compilation when `hello_world' already exists:
#.PHONY: hello_world

