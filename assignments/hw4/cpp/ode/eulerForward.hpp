#ifndef EULERFORWARD_HPP
#define EULERFORWARD_HPP
#include <cassert>
#include <iostream>

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
    class EulerForward
    {
    private:
        typename OdeSystem::value_type dT_;

    public:
        static const char constexpr method_name[] = "eulerForward";
        static const char constexpr dim = OdeSystem::dim;

    public:
        EulerForward(){};
        EulerForward(const typename OdeSystem::size_type steps, const typename OdeSystem::value_type final_time)
            : dT_(final_time / steps){};
        ~EulerForward(){};

    public:
        template <typename operand_type>
        inline void time_step(const OdeSystem &system, const operand_type &old_time, operand_type &new_time) const
        {
            assert((decltype(dim))old_time.size() == dim);
            assert((decltype(new_time.size()))old_time.size() == new_time.size());
            #ifdef DLVL3
            std::cout << "Old time: " << old_time << std::endl;
            #endif

            new_time = old_time + dT_ * system(old_time);
            
            #ifdef DLVL3
            std::cout << "New time: " << new_time << std::endl;
            #endif
        }
    };
} // namespace ode
#endif
