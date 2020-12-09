#include "vector.hpp"
#include "cg.hpp"
#include "matrixop.hpp"
#include <iostream>
#include <typeinfo>
#include <type_traits>
#include <algorithm>
#include <cmath>
void matvec(tws::vector<double> const &x, tws::vector<double> &y)
{
  assert(x.size() == y.size());

  for (int i = 0; i < x.size(); ++i)
  {
    y(i) = x(i) / (i + 1);
  }
}

double test_function(double x){
  double sigma = 2;
  return std::exp(x*x/sigma);
}

int main()
{
  int n = 10;
  tws::vector<double> b(n);
  tws::vector<double> sol(n);
  tws::vector<double> x(n);
  tws::vector<double> b_ex(n);
  // tws::matvec3<decltype(x),decltype(x),int> functor(3);
  tws::matvec4<decltype(x), decltype(x)> functor;
  int m = 3;
  // auto lambda = [&functor, m](tws::vector<double> const &x, tws::vector<double> &y) { functor(x, y, m); };
  auto generic_lambda = [&functor, m](auto const &x, auto &y) { functor(x, y, m); };

  //x random between 0 and 1
  x.randomize(0, 1);

  generic_lambda(x, b);

  b_ex = b;

  //x zero vector
  std::fill(x.begin(), x.end(), 0.);
  tws::cg(generic_lambda, x, b, 1.e-10, n);
  generic_lambda(x, sol);

  std::cout << "relative error: " << tws::norm_2(sol - b_ex) / tws::norm_2(b_ex) << std::endl;

  std::cout<<x<<std::endl;
  // tws::element_apply(test_function, x);
  std::transform(x.begin(),x.end(),x.begin(),test_function);
  std::cout<<x<<std::endl;

  return 0;
}
