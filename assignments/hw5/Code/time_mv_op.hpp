#ifndef tws_time_mv_op_hpp
#define tws_time_mv_op_hpp
#include "vector.hpp"
#include <chrono>
/*
Basic functionality to time the the given operation MV_OP

@param N is the size of the matrix in the matrix-vector multiplication

the given operation is called by op(x,y) with x and y vectors.

*/

namespace tws{

template<typename MV_OP,typename scalar=double>
int time_mv(MV_OP const & op, int N, int number_exp=100, int discard=5) {
  scalar elapsed_time=0.;
  scalar average_time=0.;
  scalar squared_time=0.;
  scalar time_diff=0.;

  tws::vector<scalar> y(N,1.0);
  tws::vector<scalar> x(N,1.0);

  for(int exp=0;exp<number_exp+discard;exp++){
    auto t_start = std::chrono::high_resolution_clock::now();
    op(x,y);
    auto t_end = std::chrono::high_resolution_clock::now();
    if(exp>=discard){
       elapsed_time=std::chrono::duration<double>(t_end-t_start).count(); 
       time_diff=elapsed_time-average_time;
       average_time+=time_diff/(exp-discard+1);
       squared_time+=time_diff*(elapsed_time-average_time);
    }
    y(0)+=y(0);
  }
  std::cout<<N<<" "<<average_time<<" "<<std::sqrt(squared_time/(number_exp-1))<<std::endl;
  return 0 ;
}
 
}
#endif
