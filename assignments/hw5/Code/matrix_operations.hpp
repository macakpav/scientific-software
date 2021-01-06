#ifndef tws_matrix_operations_hpp
#define tws_matrix_operations_hpp
#include <cassert>
#include <cmath>
#include "matrix.hpp"
namespace tws {

  template <typename S,typename M>
  inline  typename std::enable_if< is_matrix<M>::value && std::is_arithmetic<S> ::value,M>::type operator*( S const& s, M const& m ) {
      M res(m.num_rows(),m.num_columns(),0.);
      for (typename M::size_type i=0;i<m.num_rows();i++){
         for (typename M::size_type j=0;j<m.num_columns();j++) res(i,j)=s*m(i,j);}
      return res;
  }

  template <typename S,typename M>
  inline   typename std::enable_if< is_matrix<M>::value && std::is_arithmetic<S> ::value,M>::type  operator*( M const& m, S const& s ) {
      M res(m.num_rows(),m.num_columns(),0.);
      for (typename M::size_type i=0;i<m.num_rows();i++){
         for (typename M::size_type j=0;j<m.num_columns();j++) res(i,j)=s*m(i,j);}
      return res;
  }

  template <typename M>
  inline  typename std::enable_if< is_matrix<M>::value&& !is_matrix_expression<M>::value,M>::type transpose( M const& m ) {
      M res(m.num_columns(),m.num_rows(),0.);
      for (typename M::size_type i=0;i<m.num_rows();i++){
         for (typename M::size_type j=0;j<m.num_columns();j++) res(j,i)=m(i,j);}
      return res;
  }

  template <typename M1,typename M2, typename std::enable_if< is_matrix<M1>::value && is_matrix<M1> ::value,int>::type = 0,typename std::enable_if<std::is_same< typename std::common_type<typename M1::value_type, typename M2::value_type>::type, typename M1::value_type >::value || (std::is_same<typename M1::value_type, typename M2::value_type>::value),bool >::type=true>
  inline  decltype(auto) operator+( M1 const& m1, M2 const& m2 ) {
      assert(m1.num_rows()==m2.num_rows());
      assert(m1.num_columns()==m2.num_columns());
      M1 res(m1.num_rows(),m1.num_columns(),0.);
      for (typename M1::size_type i=0;i<m1.num_rows();i++){
         for (typename M1::size_type j=0;j<m1.num_columns();j++) res(i,j)=m1(i,j)+m2(i,j);}
      return res;
  }

  template <typename M1,typename M2, typename std::enable_if< is_matrix<M1>::value && is_matrix<M1> ::value,int>::type = 0, typename std::enable_if<std::is_same< typename std::common_type<typename M1::value_type, typename M2::value_type>::type, typename M2::value_type >::value && !(std::is_same<typename M1::value_type, typename M2::value_type>::value),bool >::type=true>
  inline  decltype(auto) operator+( M1 const& m1, M2 const& m2 ) {
      assert(m1.num_rows()==m2.num_rows());
      assert(m1.num_columns()==m2.num_columns());
      M2 res(m1.num_rows(),m1.num_columns(),0.);
      for (typename M1::size_type i=0;i<m1.num_rows();i++){
         for (typename M1::size_type j=0;j<m1.num_columns();j++) res(i,j)=m1(i,j)+m2(i,j);}
      return res;
  }

  template <typename M1,typename M2, typename std::enable_if< is_matrix<M1>::value && is_matrix<M1> ::value,int>::type = 0,typename std::enable_if<std::is_same< typename std::common_type<typename M1::value_type, typename M2::value_type>::type, typename M1::value_type >::value || (std::is_same<typename M1::value_type, typename M2::value_type>::value),bool >::type=true>
  inline  decltype(auto) operator-( M1 const& m1, M2 const& m2 ) {
      assert(m1.num_rows()==m2.num_rows());
      assert(m1.num_columns()==m2.num_columns());
      M1 res(m1.num_rows(),m1.num_columns(),0.);
      for (typename M1::size_type i=0;i<m1.num_rows();i++){
         for (typename M1::size_type j=0;j<m1.num_columns();j++) res(i,j)=m1(i,j)-m2(i,j);}
      return res;
  }

  template <typename M1,typename M2, typename std::enable_if< is_matrix<M1>::value && is_matrix<M1> ::value,int>::type = 0, typename std::enable_if<std::is_same< typename std::common_type<typename M1::value_type, typename M2::value_type>::type, typename M2::value_type >::value && !(std::is_same<typename M1::value_type, typename M2::value_type>::value),bool >::type=true>
  inline  decltype(auto) operator-( M1 const& m1, M2 const& m2 ) {
      assert(m1.num_rows()==m2.num_rows());
      assert(m1.num_columns()==m2.num_columns());
      M2 res(m1.num_rows(),m1.num_columns(),0.);
      for (typename M1::size_type i=0;i<m1.num_rows();i++){
         for (typename M1::size_type j=0;j<m1.num_columns();j++) res(i,j)=m1(i,j)-m2(i,j);}
      return res;
  }

}
#endif
