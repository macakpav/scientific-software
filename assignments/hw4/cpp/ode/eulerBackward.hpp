#ifndef EULERBACKWARD_HPP
#define EULERBACKWARD_HPP
#include <cassert>
#include <iostream>

#include <boost/numeric/ublas/vector.hpp>
#include <boost/numeric/ublas/matrix.hpp>
#include <boost/numeric/ublas/lu.hpp>
namespace ublas = boost::numeric::ublas;

namespace ode
{
    /* OdeSystem 
 * member types:
 *  size_type, value_type, vector_type, matrix_type
 * member functions:
 *  vector_type operator()( vector_type )
 *  matrix_type jacobian()( vector_type )
 * 
 * */

    template <typename OdeSystem>
    class EulerBackward
    {
    private:
        typename OdeSystem::value_type dT_;
        ublas::vector<typename OdeSystem::value_type> temp_;
        ublas::matrix<typename OdeSystem::value_type> jac_;
        ublas::permutation_matrix<int> pm_;

    public:
        static const char constexpr method_name[] = "eulerBackward";
        static const char constexpr dim = OdeSystem::dim;
        static const double constexpr tolerance = std::numeric_limits<typename OdeSystem::value_type>::epsilon()*100.0;
        static const double constexpr max_iter = 1000;

    public:
        EulerBackward(){};
        EulerBackward(const typename OdeSystem::size_type steps, const typename OdeSystem::value_type final_time)
            : dT_(final_time / steps), temp_(dim), jac_(dim, dim), pm_(dim){};
        ~EulerBackward(){};

    public:
        template <typename vector>
        void time_step(const OdeSystem &system, const vector &old_time, vector &new_time)
        {
            assert((decltype(dim))old_time.size() == dim);
            assert((decltype(new_time.size()))old_time.size() == new_time.size());
#ifdef DLVL3
            // std::cout << "Old time: " << old_time << std::endl;
#endif
            double res = std::numeric_limits<double>::infinity();
            double norm = ublas::norm_1(old_time);
#ifdef DLVL3
            std::cout << "Normalizer: " << norm << std::endl;
#endif
            new_time.assign(old_time);
            for (int i = 0; i < max_iter; i++)
            {
                temp_ = (old_time - new_time) + dT_ * system(new_time);
                res = ublas::norm_inf(temp_) / norm;
                if (res < tolerance)
                {
#ifdef DLVL3
                    std::cout << "Euler backward converged in " << i + 1 << " steps." << std::endl;
#endif
                    break;
                }

                jacG(new_time, jac_, system);
                ublas::lu_factorize(jac_, pm_);
                ublas::lu_substitute(jac_, pm_, temp_);
                new_time = new_time - temp_;
            }
#ifdef DLVL3
            // std::cout << "New time: " << new_time << std::endl;
            std::cout << "Residual: " << res << std::endl;
#endif
        }

        template <typename vector, typename matrix_type>
        inline void jacG(const vector &vars, matrix_type &matrix, const OdeSystem &system) const
        {
            system.jacobian(vars, matrix);
            matrix *= dT_;
            for (size_t i = 0; i < matrix.size1(); i++)
            {
                matrix(i, i) -= 1.0;
            }
        }
    };
} // namespace ode
#endif
