# Variable for the selected compiler (see $ fortrancompilers)
FC=gfortran#    nagfor    ifort    gfortran

# TIP: the following flags can be interesting to detect errors:
# Possible compilation flags per compiler
FFLAGS_gfortran = -g -pedantic -Wall -Wimplicit-interface -Wunderflow -fbounds-check -fimplicit-none
FFLAGS_ifort    = -g -debug full -implicitnone -check -warn -free -Tf
FFLAGS_nagfor   = -g -C=all -gline -u -info -colour


# Select the right flags for the current compiler
FFLAGS=$(FFLAGS_$(FC))
ext = f90

#-----------------------------------------------------------------------------------------
default:
	@ echo "Only make all, make solverTest and make clean are possible"
all: solverTest
	./solverTest.exe
clean:
	@ rm -f *.exe solverTest.o *.out $(r)	

solverTest.o: ./solverTest.$(ext)
	$(FC) -c $(FFLAGS) solverTest.$(ext)

solverTest: solverTest.o
	$(FC) -o solverTest.exe solver_$(FC).o solverTest.o 






