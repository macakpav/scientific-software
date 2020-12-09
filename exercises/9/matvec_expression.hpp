#ifndef TWS_MATVEC_EXPRESSION_HPP
#define TWS_MATVEC_EXPRESSION_HPP 0
#include "vector.hpp"
#include "matrix.hpp"
#include <type_traits>

namespace tws
{
    template <typename M, typename V>
    class matvec
    {
        static_assert(is_matrix<M>::value, "First argument of matvec should be is_matrix.");
        static_assert(is_vector<V>::value, "Second argument of matvec should be is vector");

    public:
        typedef decltype(typename M::value_type() * typename V::value_type()) value_type;
        typedef typename M::size_type size_type;

    private:
        M const &Mat_;
        V const &v_;

    public:
        matvec(M const &Mat, V const &v)
            : Mat_(Mat), v_(v)
        {
            assert(Mat_.num_columns() == v_.size());
        }
        ~matvec() {}
        size_type size() const
        {
            return Mat_.num_rows();
        }
        value_type operator()(size_type i) const
        {
            assert(i >= 0 && i < size());
            value_type retvalue;
            retvalue(0.0);
            for (decltype(v_.size()) j = 0; j < v_.size(); j++)
            {
                std::cout<<Mat_(i,j)<<"x"<<v_(j)<<std::endl;
                retvalue += Mat_(i, j) * v_(j);
            }
            return retvalue;
        }
    };

    template <class T, class T2>
    struct is_vector<matvec<T, T2>>
    {
        static bool const value = is_matrix<T>::value && is_vector<T2>::value;
    };

    template <typename M, typename V>
    typename std::enable_if<is_matrix<M>::value && is_vector<V>::value, matvec<M, V>>::type operator*(M const &Mat, V const &v)
    {
        return matvec<M, V>(Mat, v);
    } //operator*

} // namespace tws

#endif