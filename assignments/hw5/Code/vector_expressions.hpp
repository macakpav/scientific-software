#ifndef tws_vector_expressions_hpp
#define tws_vector_expressions_hpp
#include"vector.hpp"
#include"matrix.hpp"
#include<type_traits>
namespace tws{
       
    template <typename V1, typename V2>
    class vector_sum {
        static_assert(is_vector<V1>::value,"vector_sum requires first argument to have succesfull is_vector");
        static_assert(is_vector<V2>::value,"vector_sum requires second argument to have succesfull is_vector");
        public:
        typedef typename V1::size_type size_type ;
        typedef decltype( typename V1::value_type() + typename V2::value_type() ) value_type ;

        public:
        vector_sum( V1 const& v1, V2 const& v2 )
        : v1_( v1 )
        , v2_( v2 )
        {
            assert( v1.size()==v2.size() ) ;
        }

        size_type size() const {
            return v1_.size() ;
        }

        value_type operator()( size_type i ) const {
            assert( i>=0 ) ;
            assert( i<size() ) ;
            return v1_(i) + v2_(i) ;
        }

        private:
        typename std::conditional<tws::is_vector_expression<V1>::value, V1 const, V1 const & >::type v1_ ;
        typename std::conditional<tws::is_vector_expression<V2>::value, V2 const, V2 const & >::type v2_ ;
    } ; //vector_sum

  template <class T,class T2>
  struct is_vector<vector_sum<T,T2> > {
    static bool const value = is_vector<T>::value && is_vector<T2>::value;
  };

  template <class T,class T2>
  struct is_vector_expression<vector_sum<T,T2> > {
    static bool const value = is_vector<T>::value && is_vector<T2>::value;
  };

    template <typename V1, typename V2>
    vector_sum<V1,V2> operator+(V1 const& v1, V2 const& v2 ) {
        return vector_sum<V1,V2>(v1,v2) ;
    } //operator+


    template <typename V1, typename V2>
    class vector_minus {
        public:
         static_assert(is_vector<V1>::value,"vector_minus requires first argument to have succesfull is_vector");
         static_assert(is_vector<V2>::value,"vector_minus requires second argument to have succesfull is_vector");
        typedef typename V1::size_type size_type ;
        typedef decltype( typename V1::value_type() + typename V2::value_type() ) value_type ;

        public:
        vector_minus( V1 const& v1, V2 const& v2 )
        : v1_( v1 )
        , v2_( v2 )
        {
            assert( v1.size()==v2.size() ) ;
        }

        size_type size() const {
            return v1_.size() ;
        }
    
        value_type operator()( size_type i ) const {
            assert( i>=0 ) ;
            assert( i<size() ) ;
            return v1_(i) - v2_(i) ;
        }

        private:
        typename std::conditional<tws::is_vector_expression<V1>::value, V1 const, V1 const & >::type v1_ ;
        typename std::conditional<tws::is_vector_expression<V2>::value, V2 const, V2 const & >::type v2_ ;
    } ; //vector_minus

  template <class T,class T2>
  struct is_vector<vector_minus<T,T2> > {
    static bool const value = is_vector<T>::value && is_vector<T2>::value;
  };
  template <class T,class T2>
  struct is_vector_expression<vector_minus<T,T2> > {
    static bool const value = is_vector<T>::value && is_vector<T2>::value;
  };

    template <typename V1, typename V2>
    vector_minus<V1,V2> operator-(V1 const& v1, V2 const& v2 ) {
        return vector_minus<V1,V2>(v1,v2) ;
    }//operator-

    template <typename S1, typename V2>
    class scalar_vector_multiply {
         static_assert(std::is_arithmetic<S1>::value,"scalar_vector_multiply requires first argument to have succesfull is_arithmetic");
         static_assert(is_vector<V2>::value,"scalar_vector_multiply requires second argument to have succesfull is_vector");
        public:
        typedef typename V2::size_type size_type ;
        typedef decltype( S1() + typename V2::value_type() ) value_type ;

        public:
        scalar_vector_multiply( S1 const& s1, V2 const& v2 )
        : s1_( s1 )
        , v2_( v2 )
        {
        }

        size_type size() const {
            return v2_.size() ;
        }

        value_type operator()( size_type i ) const {
            assert( i>=0 ) ;
            assert( i<size() ) ;
            return s1_*v2_(i) ;
        }

        private:
        S1 const& s1_ ;
        typename std::conditional<tws::is_vector_expression<V2>::value, V2 const, V2 const & >::type v2_ ;
    } ; //scalar_vector_multiply

  template <class T,class T2>
  struct is_vector<scalar_vector_multiply<T,T2> > {
    static bool const value = is_vector<T2>::value && std::is_arithmetic<T>::value ;
  };

  template <class T,class T2>
  struct is_vector_expression<scalar_vector_multiply<T,T2> > {
    static bool const value = is_vector<T2>::value && std::is_arithmetic<T>::value ;
  };


    template <typename S1, typename V2>
    typename std::enable_if< is_vector<V2>::value && std::is_arithmetic<S1>::value, scalar_vector_multiply<S1,V2> >::type operator*(S1 const& s1, V2 const& v2 ) {
        return scalar_vector_multiply<S1,V2>(s1,v2) ;
    }//operator*

    template <typename S1, typename V2>
    typename std::enable_if< is_vector<V2>::value && std::is_arithmetic<S1>::value , scalar_vector_multiply<S1,V2> >::type  operator*(V2 const& v2, S1 const& s1 ) {
        return scalar_vector_multiply<S1,V2>(s1,v2) ;
    }//operator*


  template <typename M, typename V>
  class matrix_vector_product {
    public:
      typedef typename std::common_type<typename M::value_type,  typename V::value_type >::type value_type;
      typedef typename V::size_type size_type ;
      static_assert(is_matrix<M>::value,"M is not a matrix");
      static_assert(is_vector<V>::value,"V is not a vector");
    public:
      matrix_vector_product( M const& m, V const& v )
      : m_( m ),v_(v)
      {
        assert( m_.num_columns()==v_.size() ) ;
      }


      size_type size() const {
        return m_.num_rows() ;
      }

      value_type operator()( size_type const& i) const {
         assert(i>=0&&i<m_.num_rows());
         value_type res=0.;
         for(typename V::size_type j=0;j<m_.num_columns();j++){
            res+=m_(i,j)*v_(j);
         }
         return res;
      }

    private:
      typename std::conditional<tws::is_matrix_expression<M>::value, M const, M const & >::type m_ ;
      typename std::conditional<tws::is_vector_expression<V>::value, V const, V const & >::type v_ ;
  };

  template <class T,class T2>
  struct is_vector<matrix_vector_product<T,T2> > {
    static bool const value = is_vector<T2>::value && is_matrix<T>::value;
  };

  template <class T,class T2>
  struct is_vector_expression<matrix_vector_product<T,T2> > {
    static bool const value = is_vector<T2>::value && is_matrix<T>::value;
  };

    template <typename M1, typename V2>
    typename std::enable_if< is_vector<V2>::value && is_matrix<M1>::value, matrix_vector_product<M1,V2> >::type operator*(M1 const& m1, V2 const& v2 ) {
        return matrix_vector_product<M1,V2>(m1,v2) ;
    }//operator*


} // namespace tws

#endif
