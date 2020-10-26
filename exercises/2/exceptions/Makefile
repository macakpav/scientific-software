# Variable for the selected compiler (see $ fortrancompilers)
FC=gfortran
NAME=exceptions

# TIP: the following flags can be interesting to detect errors:
# Possible compilation flags per compiler
FFLAGS_g95      = -g -pedantic -Wall -fbounds-check -ftrace=full
FFLAGS_gfortran = -g -pedantic -Wall -Wimplicit-interface -Wunderflow -fbounds-check -fimplicit-none
FFLAGS_ifort    = -g -debug full -implicitnone -check -warn -free -Tf
FFLAGS_nagfor   = -g -C=all -gline -u -info -colour -kind=byte


# Select the right flags for the current compiler
FFLAGS=$(FFLAGS_$(FC))

ifeq ($(FC) , ifort)
	ext = f90
else
	ext = f95
endif

#-----------------------------------------------------------------------------------------
default:
	@ echo "Only make all, make $(NAME) and make clean are possible"

# Only do the compiling
$(NAME).o: ./$(NAME).f95
	if [ ${FC} = ifort ]; then \
		cp $(NAME).f95 $(NAME).f90; \
	fi
	$(FC) -c $(FFLAGS) $(NAME).$(ext)
	if [ ${FC} = ifort ]; then \
		rm $(NAME).f90; \
	fi

$(NAME): $(NAME).o
	$(FC) -o $(NAME).exe $(NAME).o

all: clean $(NAME) 
	./$(NAME).exe

# Read as: remove all interim files and hello_world, option -f makes sure nothing is printed when this already happened.
clean:
	@ rm -f *.exe *.o *.mod $(r)
	@ clear

# To use when you want to force compilation when `hello_world' already exists:
#.PHONY: hello_world

