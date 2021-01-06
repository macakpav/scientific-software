#ifndef tws_vector_operations_hpp
#define tws_vector_operations_hpp
#include <cassert>
#include <cmath>
#include "vector.hpp"
#include "matrix.hpp"
namespace tws {

  template<typename S,typename V>
  inline  typename std::enable_if<is_vector<V>::value&& std::is_arithmetic<S>::value,V> ::type  operator*( S const& s, V const& v ) {
      V res(v.size(),0.);
      for (typename V::size_type i=0;i<v.size();i++) res(i)=s*v(i);
      return res;
  }

  template<typename S,typename V>
  inline typename std::enable_if<is_vector<V>::value&& std::is_arithmetic<S>::value,V> ::type operator*( V const& v, S const& s ) {
      V res(v.size(),0.);
      for (typename V::size_type i=0;i<v.size();i++) res(i)=s*v(i);
      return res;
  }

  template<typename M, typename V>
  inline typename std::enable_if< is_vector<V>::value && is_matrix<M> ::value, V >::type operator*( M const& m, V const& v ) {
      assert(m.num_columns()==v.size());
      V res(m.num_rows(),0.);
      for (typename M::size_type i=0;i<m.num_rows();i++){
        for (typename M::size_type j=0;j<m.num_columns();j++) res(i)+=m(i,j)*v(j);
      }
      return res;
  }

  template <typename V1,typename V2, typename std::enable_if< is_vector<V1>::value && is_vector<V2> ::value,int>::type = 0, typename std::enable_if<std::is_same< typename std::common_type<typename V1::value_type, typename V2::value_type>::type, typename V1::value_type >::value || (std::is_same<typename V1::value_type, typename V2::value_type>::value),bool >::type=true>
  inline  decltype(auto) operator+( V1 const& v1, V2 const& v2 ) {
      assert(v1.size()==v2.size());
      V1 res(v1.size(),0.);
      for (typename V1::size_type i=0;i<v1.size();i++) res(i)=v1(i)+v2(i);
      return res;
  }

  template <typename V1,typename V2, typename std::enable_if< is_vector<V1>::value && is_vector<V2> ::value,int>::type = 0, typename std::enable_if<std::is_same< typename std::common_type<typename V1::value_type, typename V2::value_type>::type, typename V2::value_type >::value && !(std::is_same<typename V1::value_type, typename V2::value_type>::value),bool >::type=true>
  inline  decltype(auto) operator+( V1 const& v1, V2 const& v2 ) {
      assert(v1.size()==v2.size());
      V2 res(v1.size(),0.);
      for (typename V1::size_type i=0;i<v1.size();i++) res(i)=v1(i)+v2(i);
      return res;
  }

  template <typename V1,typename V2, typename std::enable_if< is_vector<V1>::value && is_vector<V2> ::value,int>::type = 0,typename std::enable_if<std::is_same< typename std::common_type<typename V1::value_type, typename V2::value_type>::type, typename V1::value_type >::value || (std::is_same<typename V1::value_type, typename V2::value_type>::value),bool >::type=true>
  inline  decltype(auto) operator-( V1 const& v1, V2 const& v2 ) {
      assert(v1.size()==v2.size());
      V1 res(v1.size(),0.);
      for (typename V1::size_type i=0;i<v1.size();i++) res(i)=v1(i)-v2(i);
      return res;
  }

  template <typename V1,typename V2, typename std::enable_if< is_vector<V1>::value && is_vector<V2> ::value,int>::type = 0, typename std::enable_if<std::is_same< typename std::common_type<typename V1::value_type, typename V2::value_type>::type, typename V2::value_type >::value && !(std::is_same<typename V1::value_type, typename V2::value_type>::value),bool >::type=true>
  inline  decltype(auto) operator-( V1 const& v1, V2 const& v2 ) {
      assert(v1.size()==v2.size());
      V2 res(v1.size(),0.);
      for (typename V1::size_type i=0;i<v1.size();i++) res(i)=v1(i)-v2(i);
      return res;
  }




}
#endif
