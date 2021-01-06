#ifndef ODESOLVERS_HPP
#define ODESOLVERS_HPP
#include <cassert>
#include <iostream>

#include <boost/numeric/ublas/matrix.hpp>
#include <boost/numeric/ublas/vector.hpp>
#include <boost/numeric/ublas/io.hpp>
#include <boost/numeric/ublas/assignment.hpp>
#include <boost/numeric/ublas/matrix_proxy.hpp>
#include <algorithm>
namespace ublas = boost::numeric::ublas;
namespace ode
{
    /* Contracts:
 *
 * OdeSystem 
 * member types:
 *  size_type, value_type
 * static value:
 *  dim
 * member functions:
 *  vector operator()( vector )
 *  void operator()( vector, results_vector )
 *  void jacobian()( vectro, matrix )
 *  vector initial_condition()
 * 
 * SchemeType
 * 
 * */

    template <typename OdeSystem, typename SchemeType>
    class OdeSolver
    {
    public:
        typedef SchemeType method;

    private:
        typedef typename OdeSystem::value_type value_type;
        int N_;
        value_type T_;
        method method_;
        OdeSystem &system_;

    public:
        //basic constructor
        OdeSolver(const int noSteps, const value_type maxTime, OdeSystem &system)
            : N_(noSteps), T_(maxTime), method_(N_, T_), system_(system){};

        // solve system_ using method_, put results to matrix, first column is assigned initial condition
        template <typename matrix_type> //should be column major
        void solve(matrix_type &matrix)
        {
#ifdef DLVL2
            std::cout << "Solving ODE system using " << SchemeType::method_name << std::endl;
#endif
            assert(OdeSystem::dim == matrix.size1());
            assert((int)matrix.size2() == N_ + 1);
#ifndef NDEBUG
            for (decltype(matrix.size1()) i = 0; i < matrix.size1(); i++)
                for (decltype(matrix.size2()) j = 0; j < matrix.size2(); j++)
                    matrix(i, j) = std::numeric_limits<value_type>::quiet_NaN();
#endif

            ublas::matrix_column<matrix_type> init(matrix, 0);
            init = system_.initial_condition();

            for (int step = 0; step < N_; step++)
            {
                ublas::matrix_column<matrix_type> oldTime(matrix, step);
                ublas::matrix_column<matrix_type> newTime(matrix, step + 1);
                method_.time_step(system_, oldTime, newTime);
#ifdef DLVL3
                if (step % (N_ / 10) == N_ / 10 - 1)
                    std::cout << "Done " << step + 1 << " steps." << std::endl;
#endif
            }
#ifdef DLVL2
            std::cout << "Last values: " << std::endl
                      << "Suspicable:  " << matrix(0, N_) << std::endl
                      << "Infected:    " << matrix(1, N_) << std::endl
                      << "Quarantined: " << matrix(2, N_) << std::endl
                      << "Recovered:   " << matrix(3, N_) << std::endl
                      << "Dead:        " << matrix(4, N_) << std::endl
                      << std::endl;
#endif
        };
    };
} // namespace ode
#endif
