#include "vector.hpp"
#include "matrix.hpp"
#include "time_mv_op.hpp"
#include <algorithm>

#ifdef EXPR
#include "vector_expressions.hpp"
#include "matrix_expressions.hpp"
#else
#include "vector_operations.hpp"
#include "matrix_operations.hpp"
#endif
		


namespace tws{

template<typename Xmat,typename Scalar>
class xtx_op1{

private:
    Xmat const& X;
    Scalar beta;

public:
    xtx_op1(Xmat const& X_, Scalar beta_):X(X_),beta(beta_){
        assert(X.num_rows()>0);
        assert(X.num_columns()>0);
    }
    
    template<typename V>
    void operator()(V const & x, V & y) const {
        assert(X.num_columns()==y.size());
        assert(X.num_columns()==x.size()); 
        y=tws::transpose(X)*(X*x)+beta*x;      
    }
};//xtx_op1

template<typename Xmat,typename Scalar>
class xtx_op2{

private:
    Xmat const& X;
    Scalar beta;

public:
    xtx_op2(Xmat const& X_, Scalar beta_):X(X_),beta(beta_){
        assert(X.num_rows()>0);
        assert(X.num_columns()>0);
    }
    
    template<typename V>
    void operator()(V const & x, V & y) const {
        assert(X.num_columns()==y.size());
        assert(X.num_columns()==x.size()); 
        auto t=X*x;
        y=tws::transpose(X)*(t)+beta*x;      
    }
};//xtx_op2

template<typename Xmat,typename Scalar>
class xtx_op3{

private:
    Xmat const& X;
    Scalar beta;

public:
    xtx_op3(Xmat const& X_, Scalar beta_):X(X_),beta(beta_){
        assert(X.num_rows()>0);
        assert(X.num_columns()>0);
    }
    
    template<typename V>
    void operator()(V const & x, V & y) const {
        assert(X.num_columns()==y.size());
        assert(X.num_columns()==x.size()); 
        tws::vector<Scalar> t=X*x;
        y=tws::transpose(X)*(t)+beta*x;      
    }
};//xtx_op3

template<typename Xmat,typename Scalar>
class xtx_op4{

private:
    Xmat const& X;
    Scalar beta;
    tws::vector<Scalar> mutable t;
public:
    xtx_op4(Xmat const& X_, Scalar beta_):X(X_),beta(beta_),t(X_.num_rows())
    {
        assert(X.num_rows()>0);
        assert(X.num_columns()>0);
    }
    
    template<typename V>
    void operator()(V const & x, V & y) const {
        assert(X.num_columns()==y.size());
        assert(X.num_columns()==x.size()); 
        t=X*x;
        y=tws::transpose(X)*(t)+beta*x;      
    }
};//xtx_op4
}//tws

/*
N is number of rows and columns of X
number_exp the number of experiments that are timed
discard the number of initial experiments that are discarded for calculating the mean of the execution time
*/
int main(int argc, char *argv[]) {
  assert(argc==4);
  int N = std::atoi(argv[1]);
  int number_exp=std::atoi(argv[2]);
  int discard=std::atoi(argv[3]);
  assert( (N>0) && (number_exp>0) && (discard>=0) && (number_exp>discard) );
 
  double beta=1.0;
  tws::matrix<double> X(N,N,1.0);
#ifndef EXPR
    tws::xtx_op1 xtx_op(X,beta);
#elif defined OP1 
    tws::xtx_op1 xtx_op(X,beta);
#elif defined OP2
    tws::xtx_op2 xtx_op(X,beta);
#elif defined OP3
    tws::xtx_op3 xtx_op(X,beta);
#elif defined OP4
    tws::xtx_op4 xtx_op(X,beta);
#else
  //OP5
  auto xtx_op=[&X,beta](auto const& x, auto & y){
     std::fill(y.begin(),y.end(),0.);
     for(decltype(X.num_rows()) i=0;i<X.num_rows();i++){
        double inner_Xix=0;
        for(decltype(X.num_columns()) j=0;j<X.num_columns();j++){
           inner_Xix+=X(i,j)*x(j);
        }
        for(decltype(X.num_columns()) j=0;j<X.num_columns();j++){
           y(j)+=X(i,j)*inner_Xix;
        }
     }
     y+=beta*x;
  };  
#endif
  tws::time_mv(xtx_op,N,number_exp,discard);
  return 0 ;
} 
