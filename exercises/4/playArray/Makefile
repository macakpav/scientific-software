# Variable for the selected compiler (see $ fortrancompilers)
FC=gfortran# g95 gfortran ifort nagfor 
NAME=playArray

#optimizations
#-Os least memory usage
#--Og debug informations for vlagrind etc.
#--Ofast like O3 on steroids but can change functionality

# TIP: the following flags can be interesting to detect errors:
# Possible compilation flags per compiler
FFLAGS_g95      = -g -pedantic -Wall -fbounds-check -ftrace=full
FFLAGS_gfortran = -g -pedantic -Wall -Wimplicit-interface -Wunderflow -fbounds-check -fimplicit-none
FFLAGS_ifort    = -g -debug full -implicitnone -check -warn -free -Tf #-heap-arrays
FFLAGS_nagfor   = -g -C=all -gline -u -info -colour -kind=byte


# Select the right flags for the current compiler
FFLAGS=$(FFLAGS_$(FC))
ext = f90
#-----------------------------------------------------------------------------------------
default:
	@ echo "Only make all, make $(NAME) and make clean are possible"

show_matrix_module.o: ./show_matrix_module.$(ext)
	$(FC) -c $(FFLAGS) show_matrix_module.$(ext)

$(NAME)_module.o: ./$(NAME)_module.$(ext) ./show_matrix_module.o
	$(FC) -c $(FFLAGS) $(NAME)_module.$(ext)

# Only do the compiling
$(NAME).o: ./$(NAME).$(ext) ./$(NAME)_module.o ./show_matrix_module.o
	$(FC) -c $(FFLAGS) $(NAME).$(ext)

$(NAME): $(NAME).o
	$(FC) -o $(NAME).exe $(NAME)_module.o ./show_matrix_module.o $(NAME).o

all: clean $(NAME) 
	./$(NAME).exe
# builtinsum blocksum smallest biggest kahan

# Read as: remove all interim files and hello_world, option -f makes sure nothing is printed when this already happened.
clean:
	@ rm -f *.exe *.o *.mod $(r)
	@ clear

# To use when you want to force compilation when `hello_world' already exists:
#.PHONY: hello_world

