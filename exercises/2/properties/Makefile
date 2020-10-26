
# TIP: the following flags can be interesting to detect errors:
# Possible compilation flags per compiler
FFLAGS_g95      = -g -pedantic -Wall -fbounds-check -ftrace=full
FFLAGS_gfortran = -g -pedantic -Wall -Wimplicit-interface -Wunderflow -fbounds-check -fimplicit-none
FFLAGS_ifort    = -g -debug full -implicitnone -check -warn -free -Tf
FFLAGS_nagfor   = -g -C=all -gline -u -info -colour -kind=byte

#-----------------------------------------------------------------------------------------
default:
	g95 $(FFLAGS_g95) -o g95.exe print_real_properties_g95.f90
	gfortran $(FFLAGS_gfortran) -o gfortran.exe print_real_properties_gfortran.f90
	ifort $(FFLAGS_ifort) print_real_properties_ifort.f90 -o ifort.exe
	nagfor $(FFLAGS_nagfor) -o nagfor.exe print_real_properties_nagfor.f90
all: default
	@ echo ""
	./g95.exe
	./gfortran.exe
	./ifort.exe
	./nagfor.exe
# Read as: remove all interim files and hello_world, option -f makes sure nothing is printed when this already happened.
clean:
	@ rm -f *.exe *.o *.mod
	@ clear

