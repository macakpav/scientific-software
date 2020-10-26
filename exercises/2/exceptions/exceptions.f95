program Main
  use iso_fortran_env
  USE, INTRINSIC :: IEEE_EXCEPTIONS

  implicit none
  
  print *, "Error output unit:", error_unit
  print *, "Supports division by zero exception:  ", IEEE_SUPPORT_FLAG(IEEE_DIVIDE_BY_ZERO), &
    ", haltable?", IEEE_SUPPORT_HALTING(IEEE_DIVIDE_BY_ZERO)
  print *, "Supports inexact assignment exception:", IEEE_SUPPORT_FLAG(IEEE_INEXACT), &
    ", haltable?", IEEE_SUPPORT_HALTING(IEEE_INEXACT)



end program Main

