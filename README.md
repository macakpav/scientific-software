# Scientific Software exercise sessions
Exercises and assignments for Scientific Software course at KU Leuven winter 20/21



# Assignments description

#### SIQRD
A pandemic prediction model of 5 ODEs and 5 tweakable parameters.


#### HW1 - Fortran, SIQRD model, exponential model
Solves initial value problem of SIQRD equations. Implements 3 ddt schemes - Euler forward, Euler backward and Heun.
Exponential model demonstrates problem in binary representation of decimal numbers (0.125 - precise in binary, 0.1 - not precise).

#### HW2 - Fortran, Matrix operations
Comparison of diverent strategies of dense matrix multiplication.

#### HW3 - Fortran, SIQRD model, parameter optimisation, system stability
Optimises value of a parameter to satisfy some target function, e.g. parameter \beta (~ level of goverment restriction) and maximum number of infected people at one time.
Second program computes eigenvalues of jabian matrix of linearised SIQRD equations - enables to judge system stability (any positive eigenvalue means unstable).

#### HW4 - C++, SIQRD model, find parameters to target function
Implemets same functionality as in HW1. ODE solvers can solve a general system. Optimizes parameters of SIQRD equations against some target function - e.g. least square error of the simulation and experimental data. Optimisation methods: CG and BFGS using line search with Wolfe conditons.

#### HW5 - C++, expression templates
Demonstration of dangers and advantages of lazy evaluation and expression templates.
