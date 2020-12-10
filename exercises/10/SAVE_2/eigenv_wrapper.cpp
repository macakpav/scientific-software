//g++ -fPIC -Wall -std=c++14 -O3 -shared -o eigenv_wrapper.so eigenv_wrapper.cpp
extern "C"
{
    int cpp_eig(double *matrix_values, int matrix_size, double *eigvr, double *eigvi);
}
int cpp_eig(double *matrix_values, int matrix_size, double *eigvr, double *eigvi){
    
    for(int i =0; i<matrix_size; i++){
        eigvr[i]=matrix_values[i];
        eigvi[i]=matrix_values[i+matrix_size];
    }

    return 0;
}