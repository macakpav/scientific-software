#include <iostream>
#include "vector.hpp"
#include "matrix.hpp"
#include "matvec_expression.hpp"

int main()
{
    tws::matrix<double> A(3,3,0.);
    tws::vector<double> x(3,1.);
    A(0,0) = 1; A(0,1) = 2; A(0,2) = 3;
    A(1,0) = 1; A(1,1) = -1; A(1,2) = 0;
    A(2,0) = 18; A(2,1) = 22; A(2,2) = 2;
    x = A*x;
    std::cout<<x<<std::endl;
    return 0;
}
