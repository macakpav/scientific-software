#ifndef HEUN_HPP
#define HEUN_HPP
#include <cassert>
#include <iostream>

#include <boost/numeric/ublas/vector.hpp>
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
    class Heun
    {
    private:
        typename OdeSystem::value_type dT_;
        ublas::vector<typename OdeSystem::value_type> temp_;

    public:
        static const char constexpr method_name[] = "heun";
        static const char constexpr dim = OdeSystem::dim;

    public:
        Heun(){};
        Heun(const typename OdeSystem::size_type steps, const typename OdeSystem::value_type final_time)
            : dT_(final_time / steps), temp_(dim){};
        ~Heun(){};

    public:
        template <typename operand_type>
        inline void time_step(const OdeSystem &system, const operand_type &old_time, operand_type &new_time)
        {
            assert((decltype(dim))old_time.size() == dim);
            assert((decltype(new_time.size()))old_time.size() == new_time.size());
            #ifdef DLVL3
            std::cout << "Old time: " << old_time << std::endl;
            #endif
            
            system(old_time, temp_);
            new_time = old_time + dT_ * (0.5 * temp_ + 0.5 * system(old_time + dT_ * temp_));

            #ifdef DLVL3
            std::cout << "New time: " << new_time << std::endl;
            #endif
        }
    };
} // namespace ode
#endif
