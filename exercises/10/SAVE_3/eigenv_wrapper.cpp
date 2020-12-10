
//g++ -fPIC -c -Wall -std=c++14 -O3 -DNDEBUG -o eigenv_wrapper.o eigenv_wrapper.cpp
//gfortran -c -O3 -fPIC -o eigenv_fortran_wrapper.o eigenv_fortran_wrapper.f90
//g++ -fPIC -shared -o eigenv_wrapper.so eigenv_fortran_wrapper.o eigenv_wrapper.o -lstdc++ -lgfortran -llapack
extern "C"
{
    int cpp_eig(double *matrix_values, int matrix_size, double *eigvr, double *eigvi);
    void fortran_eig(double *matrix_values, int &matrix_size, double *eigvr, double *eigvi);
}
int cpp_eig(double *matrix_values, int matrix_size, double *eigvr, double *eigvi){
    
    fortran_eig(matrix_values, matrix_size, eigvr, eigvi);

    return 0;
}