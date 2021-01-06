# Makefile for third assignment
#-----------------------------------------------------------------------------------------
# Variable for the selected compiler
FC=gfortran#    nagfor    ifort    gfortran
debug=false# set to true to disable optimizaion flags

# TIP: the following flags can be interesting to detect errors:
# Possible compilation flags per compiler
FFLAGS_gfortran = -g -pedantic -Wall -Wimplicit-interface -Wunderflow -fbounds-check -fimplicit-none
FFLAGS_ifort    = -g -debug full -implicitnone -warn -free -Tf
FFLAGS_nagfor   = -g -C=all -gline -u -info -colour
FFLAGS_gfortran_opt = -O3 -flto 
FFLAGS_ifort_opt    = -O3 -ipo
FFLAGS_nagfor_opt   = -O3

# Select the right flags for the current compiler	
ifeq ($(debug) , true)
	FFLAGS=$(FFLAGS_$(FC))
else
	FFLAGS=$(FFLAGS_$(FC)_opt)
endif
# Fortran source file (usualy .f90 or .f95)
ext=f90
# Items to remove on make clean
r=*.exe *.o *.mod *.out *.csv

#-----------------------------------------------------------------------------------------
default:
	@ echo "Only make: all, simulate, optimize, stabilize, clean, SIQRDsimulate, SIQRDoptimize and SIQRDstability are possible."

all: clean simulate optimize stabilize

simulate: SIQRDsimulate
	./SIQRDsimulate.exe 1000 100.0

optimize: SIQRDoptimize
	./SIQRDoptimize.exe 1000 100.0 0.001 20000

stabilize: SIQRDstability
	./SIQRDstability.exe

clean:
	@ rm -f $(r)
	@ clear

solver.o: ./solver.$(ext)
	$(FC) -c $(FFLAGS) solver.$(ext)

siqrd_settings.o: ./siqrd_settings.$(ext)
	$(FC) -c $(FFLAGS) siqrd_settings.$(ext)

timings.o: ./timings.f90 ./siqrd_settings.o
	$(FC) -c $(FFLAGS) timings.$(ext)

io_module.o: ./io_module.$(ext) ./siqrd_settings.o
	$(FC) -c $(FFLAGS) io_module.$(ext)

methods_module.o: ./methods_module.$(ext) ./siqrd_settings.o ./io_module.o ./solver.o
	$(FC) -c $(FFLAGS) methods_module.$(ext)

simulation_module.o: ./simulation_module.$(ext) ./siqrd_settings.o ./io_module.o ./methods_module.o
	$(FC) -c $(FFLAGS) simulation_module.$(ext)

SIQRDsimulate.o: ./SIQRDsimulate.$(ext) ./siqrd_settings.o ./io_module.o ./methods_module.o ./simulation_module.o
	$(FC) -c $(FFLAGS) SIQRDsimulate.$(ext)

SIQRDsimulate: SIQRDsimulate.o
	$(FC) -o SIQRDsimulate.exe siqrd_settings.o io_module.o methods_module.o simulation_module.o SIQRDsimulate.o solver.o -llapack

optimization_module.o: ./optimization_module.$(ext) ./siqrd_settings.o ./io_module.o ./simulation_module.o ./timings.o
	$(FC) -c $(FFLAGS) optimization_module.$(ext)

SIQRDoptimize.o: ./SIQRDoptimize.$(ext) ./siqrd_settings.o ./io_module.o ./methods_module.o ./optimization_module.o
	$(FC) -c $(FFLAGS) SIQRDoptimize.$(ext)

SIQRDoptimize: SIQRDoptimize.o
	$(FC) -o SIQRDoptimize.exe siqrd_settings.o io_module.o methods_module.o optimization_module.o simulation_module.o SIQRDoptimize.o solver.o timings.o -llapack

SIQRDstability.o: ./SIQRDstability.$(ext) ./siqrd_settings.o ./io_module.o ./methods_module.o
	$(FC) -c $(FFLAGS) SIQRDstability.$(ext)

SIQRDstability: SIQRDstability.o
	$(FC) -o SIQRDstability.exe SIQRDstability.o siqrd_settings.o io_module.o methods_module.o solver.o -llapack




