#include <boost/numeric/ublas/matrix.hpp>
#include <boost/numeric/ublas/vector.hpp>
#include <boost/numeric/ublas/io.hpp>
#include <boost/numeric/ublas/lu.hpp>

namespace ublas = boost::numeric::ublas;
int main()
{
    ublas::matrix<double> A(2, 2);
    A(0, 0) = 1;
    A(0, 1) = 1;
    A(1, 0) = 1;
    A(1, 1) = -1;
    ublas::vector<double> x(2);
    x(0) = 2;
    x(1) = 0;
    ublas::permutation_matrix<int> pm(A.size1());
    ublas::lu_factorize(A, pm);
    ublas::lu_substitute(A, pm, x);
    std::cout << x << std::endl;
    std::cout << A << std::endl;
    return 0;
}