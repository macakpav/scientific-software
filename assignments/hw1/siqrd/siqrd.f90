! Name:     siqrd
! Purpose:  Simulate the SIQRD equations.
! Author:   pavel.macak@fs.cvut.cz (@student.kuleuven.be)
! Compilation: Makefile is provided, although when changing compilers the "use solver_COMPILER" in methods_module.f90 must be edited acordingly.
!              Also nagfor requires use of f90_unix_proc module for the abort() subroutine to work (used if Newtons method fails)
!              Also ifort requires use of ifport module for the same reason.
!              Tested with nagfor, ifort and gfortran(recommended).

program SIQRD
  use siqrd_settings
  use io_module
  use simulation_module
  use methods_module

  implicit none

  integer, parameter :: inputLength  = 7 ! number of expected input arguments
  integer, parameter :: noParameters = inputLength + 1 ! input + dT
  real(wp), dimension(noParameters) :: simulationParameters !dT,beta,mu,gamma,alpha,delta,S0,I0

  call readParams(simulationParameters, INPUT_FILE) ! read input from file

  call simulateSIQRD(eulerForward, "eulerForward", simulationParameters)
  call simulateSIQRD(heunMethod, "heun", simulationParameters)
  call simulateSIQRD(eulerBackward, "eulerBackward", simulationParameters)
  
end program SIQRD

