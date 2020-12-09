#ifndef tws_vector_operations_hpp
#define tws_vector_operations_hpp
#include <cassert>
#include <cmath>
#include <type_traits>
#include "vector.hpp"

namespace tws {

  template <typename S,typename V>
  inline typename std::enable_if<std::is_arithmetic<S>::value && is_vector<V>::value,V>::type operator*( S const& s, V const& v ) {
      V res(v.size(),0.);
      for (typename V::size_type i=0;i<v.size();i++) res(i)=s*v(i);
      return res;
  }

  template <typename S,typename V>
  inline typename std::enable_if<std::is_arithmetic<S>::value && is_vector<V>::value,V>::type operator*( V const& v, S const& s ) {
      V res(v.size(),0.);
      for (typename V::size_type i=0;i<v.size();i++) res(i)=s*v(i);
      return res;
  }

  template <typename V1,typename V2>
  inline  decltype(auto) operator+( V1 const& v1, V2 const& v2 ) {
      assert(v1.size()==v2.size());
      V1 res(v1.size(),0.);
      for (typename V1::size_type i=0;i<v1.size();i++) res(i)=v1(i)+v2(i);
      return res;
  }

  template <typename V1,typename V2>
  inline  decltype(auto) operator-( V1 const& v1, V2 const& v2 ) {
      assert(v1.size()==v2.size());
      V1 res(v1.size(),0.);
      for (typename V1::size_type i=0;i<v1.size();i++) res(i)=v1(i)-v2(i);
      return res;
  }


}
#endif
