! Name:     siqrd_settings
! Purpose:  Sets global variables used in siqrd program.
! Author:   pavel.macak@fs.cvut.cz (@student.kuleuven.be)

module siqrd_settings
  use, intrinsic :: iso_fortran_env
  implicit none
public

! editable settings
  integer, parameter :: dp = selected_real_kind(15), sp = selected_real_kind(6) ! double and single precission types
  integer, parameter :: wp = dp                                                 ! set working precission of real numbers

  character(*), parameter   :: INPUT_FILE     = "parameters.in"          ! name of input file

! Newton's method settings (only applies for backward Euler)
  integer, parameter        :: MAX_ITER      = 1000                       ! maximum number of iterations for Newton's method
  real(wp), parameter       :: TOLERANCE     = 10._wp**(-precision(0._wp)+1) ! tolerance in Newton's method

! global setting for convinience
  integer, parameter :: stdin = input_unit, stdout = output_unit, stderr = error_unit ! standard output interface
end module siqrd_settings

