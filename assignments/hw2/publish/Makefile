# Makefile for second assignment
#-----------------------------------------------------------------------------------------
# Variable for the selected compiler
FC=gfortran# gfortran ifort nagfor
debug=false# set to true to disable optimizaion flags

# Possible compilation flags per compiler
FFLAGS_gfortran = -g -pedantic -Wall -Wimplicit-interface -Wunderflow -fbounds-check -fimplicit-none
FFLAGS_ifort    = -g -debug full -heap-arrays -implicitnone -check -warn -free -Tf 
FFLAGS_nagfor   = -g -C=all -gline -u -info -colour -kind=byte
FFLAGS_gfortran_opt = -O3 -funroll-loops
FFLAGS_ifort_opt    = -O3 -heap-arrays 0
FFLAGS_nagfor_opt   = -O3

# Select the right flags for the current compiler	
ifeq ($(debug) , true)
	FFLAGS=$(FFLAGS_$(FC))
else
	FFLAGS=$(FFLAGS_$(FC)_opt)
endif
# Source files extension
ext = f90
#-----------------------------------------------------------------------------------------
default:
	@ echo "Only make clean, make mm_driver, make bench, make mm_flops, make flops, conquer and blas_divide_and_conquer are possible"

matrixop.o: ./matrixop.$(ext)
	$(FC) -c $(FFLAGS) matrixop.$(ext)

timings.o: ./timings.$(ext)
	$(FC) -c $(FFLAGS) timings.$(ext)

mm_driver.o: ./mm_driver.$(ext) ./matrixop.o ./timings.o
	$(FC) -c $(FFLAGS) mm_driver.$(ext)

mm_driver: mm_driver.o
	$(FC) -o mm_driver_$(FC).exe timings.o matrixop.o mm_driver.o -lblas

bench: clean mm_driver
	./mm_driver_$(FC).exe

mm_flops.o: ./mm_flops.$(ext) ./matrixop.o ./timings.o
	$(FC) -c $(FFLAGS) mm_flops.$(ext)

mm_flops: clean mm_flops.o
	$(FC) -o mm_flops.exe timings.o matrixop.o mm_flops.o -lblas

flops: clean mm_flops
	./mm_flops.exe

blas_divide_and_conquer.o: ./blas_divide_and_conquer.$(ext)
	$(FC) -c $(FFLAGS) blas_divide_and_conquer.$(ext)

blas_divide_and_conquer: clean blas_divide_and_conquer.o
	$(FC) -o blas_divide_and_conquer.exe blas_divide_and_conquer.o -lblas

conquer: clean blas_divide_and_conquer
	./blas_divide_and_conquer.exe

# Read as: remove all interim and executable files
clean:
	@ rm -f *.exe *.o *.mod $(r)
	@ clear

