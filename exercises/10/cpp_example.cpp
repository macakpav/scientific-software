
//g++ -fPIC -c -Wall -std=c++14 -O3 -DNDEBUG -o cpp_example.o cpp_example.cpp
//gfortran -c -O3 -fPIC -o fortran_example.o fortran_example.f90
//g++ -fPIC -shared -o cpp_example.so fortran_example.o cpp_example.o -lstdc++ -lgfortran

extern "C"
{
    void fortran_vec_cpy(double * x, int & size, double * y);
    int cpp_vec_cpy(double * x, int size, double * y);
}
int cpp_vec_cpy(double * x, int size, double * y){
    fortran_vec_cpy(x,size,y);
    return 0;
}