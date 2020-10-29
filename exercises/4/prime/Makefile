default:
	gfortran -o prime.exe -O0 prime.f95
O0:
	gfortran -o prime.exe -O0 prime.f95
	time ./prime.exe
O3:
	gfortran -o prime.exe -O3 prime.f95
	time ./prime.exe
all:
	gfortran -o prime.exe -O0 prime.f95
	time ./prime.exe
	gfortran -o prime.exe -O3 prime.f95
	time ./prime.exe


#optimizations
#-Os least memory usage
#--Og debug informations for vlagrind etc.
#--Ofast like O3 on steroids but can change functionality

