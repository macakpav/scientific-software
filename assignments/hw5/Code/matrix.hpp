#ifndef tws_matrix_hpp
#define tws_matrix_hpp
#include <algorithm>
#include <random>
#include <chrono>
#include <iostream>
#include <cassert>

namespace tws{

template<typename T>
class matrix {
  public:
    typedef T value_type ;
    typedef int    size_type ;

  public:
    matrix( size_type n, size_type m )
    : num_rows_( n )
    , num_columns_( m )
    , data_( new value_type[num_rows_*num_columns_] )
    {}

    ~matrix() {
      delete [] data_ ;
    }

    inline matrix( size_type n, size_type m, value_type val )
    :num_rows_( n ),num_columns_( m ),data_( new value_type[num_rows_*num_columns_] ) 
    {
        std::fill_n(data_, num_columns_*num_rows_, val); 
    }

    // Copy constructor
    matrix( matrix const& that )
    : num_rows_( that.num_rows_ )
    , num_columns_( that.num_columns_ )
    , data_( new value_type[num_rows_*num_columns_] )
    {
        (*this) = that ;
    }


    // Assignment operator
    void operator=( matrix const& that ) {
      assert( that.num_rows_ == num_rows_ ) ;
      assert( that.num_columns_ == num_columns_ ) ;
      std::copy( that.data_, that.data_+num_columns_*num_rows_, data_ ) ;
      //for (size_type i=0; i<num_columns_*num_rows_; ++i) data_[i] = that.data_[i] ;
    }

    size_type num_rows() const {
      return num_rows_ ;
    }

    size_type num_columns() const {
      return num_columns_ ;
    }

    size_type size() const {
      return num_columns_*num_rows_ ;
    }

    value_type operator() (size_type i, size_type j) const {
      assert(i<num_rows());
      assert(j<num_columns());
      return data_[ i*num_columns_ + j ] ;
    }

    value_type& operator() (size_type i, size_type j) {
      assert(i<num_rows());
      assert(j<num_columns());
      return data_[ i*num_columns_ + j ] ;
    }
    template <typename Matrix>
    inline void operator=(Matrix const& m ) {
       assert(this->num_rows()==m.num_rows());
       assert(this->num_columns()==m.num_columns());
       for (size_type i=0; i<num_rows(); ++i) { 
         for (size_type j=0; j<num_columns(); ++j) {
            data_[ i*num_columns_ + j ] = m(i,j) ;
         } 
      }
    }
      template <typename Matrix>
      inline matrix& operator-=(Matrix const& m ) {
         assert(this->num_rows()==m.num_rows());
         assert(this->num_columns()==m.num_columns());
         for (size_type i=0; i<num_rows(); ++i) { 
           for (size_type j=0; j<num_columns(); ++j) {data_[ i*num_columns_ + j ]= data_[ i*num_columns_ + j ]-m(i,j) ; }}
        return *this;
      }

      template <typename Matrix>
      inline matrix& operator+=(Matrix const& m ) { 
         assert(this->num_rows()==m.num_rows());
         assert(this->num_columns()==m.num_columns());
         for (size_type i=0; i<num_rows(); ++i) { 
           for (size_type j=0; j<num_columns(); ++j) {data_[ i*num_columns_ + j ] = data_[ i*num_columns_ + j ]+m(i,j) ; }}
        return *this;
      }

      void randomize(value_type min, value_type max, int seed=1){
         #ifdef NDEBUG
            seed = std::chrono::system_clock::now().time_since_epoch().count();
         #endif
         auto engine = std::default_random_engine(seed);
         std::uniform_real_distribution<value_type> distribution(min,max);
         for (size_type i=0; i<size(); ++i) { data_[i] =distribution(engine) ; }
      }      



  private:
    size_type   num_rows_ ;
    size_type   num_columns_ ;
    value_type* data_ ;
} ;

template <typename T>
std::ostream& operator<<( std::ostream& ostr, matrix<T> const& m ) {
    ostr << "(" << m.num_rows() <<","<<m.num_columns()<< ")[" <<std::endl;
    for (int i=0; i<m.num_rows(); ++i) {
      ostr << "[" ;
      for (int j=0; j<m.num_columns()-1; ++j) {
            ostr << m(i,j) << "," ;
      }
      ostr << m(i,m.num_columns()-1)<< "]"<<std::endl ;
    }
    ostr << "]" ;
    return ostr ;
}


  template <class T>
  struct is_matrix : public std::false_type{};

  template <class T>
  struct is_matrix_expression : public std::false_type{};

  template <class T>
  struct is_matrix<tws::matrix<T> > : public std::true_type{};

}//namespace
#endif

