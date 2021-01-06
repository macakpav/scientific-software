/*
    Name:     bench_time
    Purpose:  To be used with valgrind.
    Author:   pavel.macak@fs.cvut.cz (@student.kuleuven.be)
    Compilation: Makefile is provided - make mem to run with valgrind after compilation, make bench_time to only compile
*/

#include "debug_levels.hpp"

#include <iostream>
#include <string>
#include <chrono>

#include <boost/numeric/ublas/matrix.hpp>
#include <boost/numeric/ublas/vector.hpp>
namespace ublas = boost::numeric::ublas;

#include "ode/eulerForward.hpp"
#include "ode/heun.hpp"
#include "ode/eulerBackward.hpp"

#include "siqrd/runParamSearch.hpp"
#include "siqrd/odeSys_siqrd.hpp"

int main()
{
    typedef double working_precision;
    // typedef typename ode::EulerForward<siqrd::OdeSys_SIQRD<working_precision>> fwe;
    // typedef typename ode::EulerBackward<siqrd::OdeSys_SIQRD<working_precision>> bwe;
    typedef typename ode::Heun<siqrd::OdeSys_SIQRD<working_precision>> heun;

#ifndef NINFO
    std::cout << "Program started." << std::endl
              << std::endl;
#endif

    const working_precision tol = 1e-7;
    const std::string observations = "observations1",
                      starting_guess = "parameters_" + observations;

    siqrd::runCGM<heun>(observations, starting_guess, tol);
    // siqrd::runBFGS<heun>(observations, starting_guess, tol);

#ifndef NINFO
    std::cout << "Program finished." << std::endl;
#endif
    return 0;
}
