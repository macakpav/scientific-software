#include "vector.hpp"
#include <chrono>

/*
Use the option -DEXPR during compilation to use expression templates
*/
#ifdef EXPR
#include "vector_expressions.hpp"
#else
#include "vector_operations.hpp"
#endif
		

int main() {
  int n=50000;
  int number_exp=200;
  int discard=5;

  tws::vector<double> b_0(n,0.) ;
  tws::vector<double> b_1(n,0.) ;
  tws::vector<double> b_2(n,0.) ;
  tws::vector<double> b_3(n,0.) ;
  b_1.randomize(0.,1.);
  b_2.randomize(0.,1.);
  b_3.randomize(0.,1.);
  double elapsed_time=0.;
  double average_time=0.;
  double squared_time=0.;
  double time_diff=0.;

  for(int exp=0;exp<number_exp+discard;exp++){
    auto t_start = std::chrono::high_resolution_clock::now();
    b_0=b_3+b_1+b_2+2.0*(b_1+b_2+b_3)-b_3+b_2+(b_1+b_2)*3.0-b_2+b_3+3.0*b_1;
    auto t_end = std::chrono::high_resolution_clock::now();
    if(exp>=discard){
       elapsed_time=std::chrono::duration<double>(t_end-t_start).count(); 
       time_diff=elapsed_time-average_time;
       average_time+=time_diff/(exp-discard+1);
       squared_time+=time_diff*(elapsed_time-average_time);
    }
    b_0(0)+=b_0(0);
  }
  std::cout<<"Time(s): "<<average_time<<" "<<std::sqrt(squared_time/(number_exp-1))<<std::endl;
  return 0 ;
} 