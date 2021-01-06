# Variable for the selected compiler (see $ fortrancompilers)
FC=gfortran#    nagfor    ifort    gfortran

# TIP: the following flags can be interesting to detect errors:
# Possible compilation flags per compiler
FFLAGS_gfortran = -g -pedantic -Wall -Wimplicit-interface -Wunderflow -fbounds-check -fimplicit-none
FFLAGS_ifort    = -g -debug full -implicitnone -warn -free -Tf
FFLAGS_nagfor   = -g -C=all -gline -u -info -colour
# Select the right flags for the current compiler
FFLAGS= $(FFLAGS_$(FC))

ext=f90


#-----------------------------------------------------------------------------------------
default:
	@ echo "Only make all, make siqrd, make clean and make wipe are possible"
all: wipe siqrd
	./siqrd.exe
clean:
	@ rm -f *.exe *.o *.mod *.out $(r)
	@ cp solvers/*.mod solvers/*.o ./
wipe:
	@ rm -f *.exe *.o *.mod *.out $(r)
	clear

siqrd_settings.o: ./siqrd_settings.$(ext)
	$(FC) -c $(FFLAGS) siqrd_settings.$(ext)

io_module.o: ./io_module.$(ext) ./siqrd_settings.o
	$(FC) -c $(FFLAGS) io_module.$(ext)

methods_module.o: ./methods_module.$(ext) ./siqrd_settings.o ./io_module.o
	cp solvers/solver_$(FC).* ./
	$(FC) -c $(FFLAGS) methods_module.$(ext)

simulation_module.o: ./simulation_module.$(ext) ./siqrd_settings.o ./io_module.o ./methods_module.o
	$(FC) -c $(FFLAGS) simulation_module.$(ext)

siqrd.o: ./siqrd.$(ext) ./siqrd_settings.o ./io_module.o ./methods_module.o ./simulation_module.o
	$(FC) -c $(FFLAGS) siqrd.$(ext)

siqrd: siqrd.o
	$(FC) -o siqrd.exe siqrd_settings.o io_module.o methods_module.o simulation_module.o siqrd.o solver_$(FC).o






