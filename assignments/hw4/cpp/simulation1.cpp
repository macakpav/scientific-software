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

#include "siqrd/odeSys_siqrd.hpp"
#include "siqrd/outputFileName.hpp"
#include "ode/odeSolver.hpp"
#include "ode/eulerForward.hpp"
#include "ode/heun.hpp"
#include "ode/eulerBackward.hpp"
#include "saving/saveResults.hpp"

int main(int argc, char const *argv[])
{
#ifdef DLVL0
    std::cout << "Program started." << std::endl;
#endif
    assert(argc == 3);

#ifdef DLVL1
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

    siqrd::OdeSys_SIQRD<double> eqns("inputs/parameters.in");

    ublas::matrix<double, ublas::column_major> scratchSpace(5, N + 1);
    ode::OdeSolver<decltype(eqns), ode::EulerForward<decltype(eqns)>> eulerSolver(N, T, eqns);
    ode::OdeSolver<decltype(eqns), ode::Heun<decltype(eqns)>> heunSolver(N, T, eqns);
    ode::OdeSolver<decltype(eqns), ode::EulerBackward<decltype(eqns)>> eulerBackwardSolver(N, T, eqns);

    eqns.delta_=0.0;
    eulerSolver.solve(scratchSpace);
    saving::saveResults(T / N, scratchSpace, "outputs/fwe_no_measures.out");
    
    eqns.delta_=0.2;
    heunSolver.solve(scratchSpace);
    saving::saveResults(T / N, scratchSpace, "outputs/bwe_quarantine.out");
    
    eqns.delta_=0.9;
    eulerBackwardSolver.solve(scratchSpace);
    saving::saveResults(T / N, scratchSpace, "outputs/heun_lockdown.out");

#ifdef DLVL0
    std::cout << "Program finished." << std::endl;
#endif
    return 0;
}
