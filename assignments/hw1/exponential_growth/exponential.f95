! Name:     exponential
! Purpose:  Simulate the exponential growth of infected people in first days.
! Author:   pavel.macak@fs.cvut.cz (@student.kuleuven.be)
! Compilation: Makefile is provided.
!              Tested with nagfor, ifort and gfortran(recommended).
program Main
  use exponential_module

  implicit none

  real(wp) :: r, d, I0

  !read input
  write (stdout,*) "Please specify following data."
  write (stdout,*) "Number of initial infections:"
  read (stdin,*) I0
  write (stdout,*) "Number of days:"
  read (stdin,*) d
  write (stdout,*) "Daily infection rate:"
  read (stdin,*) r
  write (stdout,*) ""

  !predict
  call exponentialGrowthPrediction(r,d,I0)
  write (stdout,*) ""


end program Main

