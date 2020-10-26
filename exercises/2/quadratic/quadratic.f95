program Main
  use iso_fortran_env
  USE, INTRINSIC :: IEEE_EXCEPTIONS
  use quadratic_module

  implicit none

  !integer, parameter :: dp = selected_real_kind(15)
  !integer, parameter :: sp = selected_real_kind(6)

  real(dp) :: b_dp, c_dp
  real(sp) :: b_sp, c_sp
  
  print *, ""
  print *, "Error output unit:", error_unit
  print *, "Supports division by zero exception:  ", IEEE_SUPPORT_FLAG(IEEE_DIVIDE_BY_ZERO), &
    ", haltable?", IEEE_SUPPORT_HALTING(IEEE_DIVIDE_BY_ZERO)
  print *, "Supports inexact assignment exception:", IEEE_SUPPORT_FLAG(IEEE_INEXACT), &
    ", haltable?", IEEE_SUPPORT_HALTING(IEEE_INEXACT)
  print *,""

  
  !return

  print *,'Enter coeficients b and c separated by space'
  read *,b_dp,c_dp
  b_sp = b_dp
  c_sp = c_dp
  print *, ""
  !print *, "Algorithm 1, single precission gives", alg_1_sp(b_sp,c_sp)
  !print *, "Algorithm 2, single precission gives", alg_2_sp(b_sp,c_sp)
  !print *, "Algorithm 1, double precission gives", alg_1_dp(b_dp,c_dp)
  print *, "Algorithm 2, double precission gives", alg_2_dp(b_dp,c_dp)


end program Main

