#ifndef tws_matrix_expressions_hpp
#define tws_matrix_expressions_hpp
#include"matrix.hpp"
#include<type_traits>
namespace tws{
       
 template <typename M>
  class matrix_transpose {
    public:
      typedef typename M::value_type value_type ;
      typedef typename M::size_type  size_type ;
      static_assert(is_matrix<M>::value,"M is not a matrix");

    public:
      matrix_transpose( M const& m )
      : m_( m )
      {
        assert( m_.size()>=0 ) ;
      }


      size_type size() const {
        return m_.size() ;
      }

      size_type num_rows() const {
        return m_.num_columns() ;
      }

      size_type num_columns() const {
        return m_.num_rows() ;
      }

      value_type operator()( size_type const& i,size_type const& j ) const { return m_(j,i); }

    private:
      typename std::conditional<tws::is_matrix_expression<M>::value, M const, M const & >::type m_ ;
  } ;

  template <class T>
  struct is_matrix<tws::matrix_transpose<T> > {
    static bool const value = is_matrix<T>::value;
  };

  template <class T>
  struct is_matrix_expression<tws::matrix_transpose<T> > {
    static bool const value = is_matrix<T>::value;
  };

  template <typename M1>
  typename std::enable_if<is_matrix<M1>::value, matrix_transpose<M1> >::type transpose(M1 const& m1 ) {
     return matrix_transpose<M1>(m1) ;
  }//transpose



} // namespace tws

#endif
