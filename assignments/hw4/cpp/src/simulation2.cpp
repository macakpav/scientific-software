/*
    Name:     simulation2
    Purpose:  Test ODE solver on the ODE system from assignment.
    Author:   pavel.macak@fs.cvut.cz (@student.kuleuven.be)
    Compilation: Makefile is provided - make run2 to run after compilation, make simulation2 to only compile
*/
#include "debug_levels.hpp"

#include <cassert>
#include <iostream>
#include <iomanip>
#include <string>

#include <boost/numeric/ublas/matrix.hpp>
#include <boost/numeric/ublas/vector.hpp>
#include <boost/numeric/ublas/io.hpp>
#include <boost/numeric/ublas/assignment.hpp>

namespace ublas = boost::numeric::ublas;

#include "ode/odeSys_sim2.hpp"
#include "ode/odeSolver.hpp"
#include "ode/eulerForward.hpp"
#include "ode/heun.hpp"
#include "ode/eulerBackward.hpp"
#include "saving/saveResults.hpp"

int main(int argc, char const *argv[])
{
    typedef double working_precision;

#ifndef NINFO
    std::cout << "Program started." << std::endl
              << std::endl;
#endif
    assert(argc == 3);

#ifdef DLVL0
    std::cout << "Command line arguments: " << std::endl;
    for (int i = 1; i < argc; i++)
    {
        std::cout << argv[i] << std::endl;
    }
    std::cout << std::endl;
#endif
    int N = atoi(argv[1]);
    double T = atof(argv[2]);

    assert(N > 0);
    assert(T > 0);

    auto eqns = ode::OdeSys_sim2<working_precision>();
    auto analytic = eqns.analytic_solution(T);
    typedef typename ode::EulerForward<decltype(eqns)> fwe;
    typedef typename ode::EulerBackward<decltype(eqns)> bwe;
    typedef typename ode::Heun<decltype(eqns)> heun;

    ublas::matrix<working_precision, ublas::column_major> scratch_space(decltype(eqns)::dim, N + 1);
    ode::OdeSolver<fwe> fwe_solver(N, T);
    ode::OdeSolver<bwe> bwe_solver(N, T);
    ode::OdeSolver<heun> heun_solver(N, T);

    fwe_solver.solve(eqns, scratch_space);
#ifndef NINFO
    std::cout << "fwe: Relative error at time " << T << ": " << ublas::norm_2(ublas::column(scratch_space, N) - analytic) / ublas::norm_2(analytic) << std::endl
              << std::endl;
#endif
    // saving::saveResults(T / N, scratch_space, "outputs/fwe_sim2.out");

    bwe_solver.solve(eqns, scratch_space);
#ifndef NINFO
    std::cout << "bwe: Relative error at time " << T << ": " << ublas::norm_2(ublas::column(scratch_space, N) - analytic) / ublas::norm_2(analytic) << std::endl
              << std::endl;
#endif
    // saving::saveResults(T / N, scratch_space, "outputs/bwe_sim2.out");

    heun_solver.solve(eqns, scratch_space);
#ifndef NINFO
    std::cout << "heun: Relative error at time " << T << ": " << ublas::norm_2(ublas::column(scratch_space, N) - analytic) / ublas::norm_2(analytic) << std::endl
              << std::endl;
#endif
    // saving::saveResults(T / N, scratch_space, "outputs/heun_sim2.out");

#ifndef NINFO
    std::cout << "Program finished." << std::endl;
#endif
    return 0;
}
