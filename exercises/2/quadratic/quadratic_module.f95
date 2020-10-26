module quadratic_module
  USE, INTRINSIC :: IEEE_EXCEPTIONS
  USE, INTRINSIC :: iso_fortran_env
  implicit none

  integer, parameter :: dp = selected_real_kind(15)
  integer, parameter :: sp = selected_real_kind(6)
  
contains

function alg_2_dp(b, c) result (roots)
  real(dp), intent(in) :: b, c
  real(dp), dimension(2) :: roots
  real(dp)             :: D, x_1
  TYPE(IEEE_STATUS_TYPE) :: STATUS_VALUE
  logical :: divFlag, inexFlag
  CALL IEEE_GET_STATUS(STATUS_VALUE) ! Get the flags
  CALL IEEE_SET_FLAG(IEEE_ALL,.FALSE.) ! Set the flags quiet.
  
  D = sqrt((b/2._dp)**2 - c)
  x_1 = sign( abs(b/2._dp) + D, -b )
  roots = (/ x_1, c/x_1 /)

  CALL IEEE_GET_FLAG(IEEE_DIVIDE_BY_ZERO, divFlag)
  CALL IEEE_GET_FLAG(IEEE_INEXACT, inexFlag)
  write (error_unit,*) divFlag, inexFlag

  if ( divFlag ) then
    write (error_unit,*) "Detected division by zero"
    call abort()
  else if ( inexFlag ) then
    write (error_unit,*) "Detected inexact assignment!"
    call abort()
  end if

  CALL IEEE_SET_STATUS(STATUS_VALUE) ! Restore the flags
  
end function alg_2_dp










  function alg_1_dp(b, c) result (roots)
    real(dp), intent(in)   :: b, c
    real(dp), dimension(2) :: roots
    real(dp)               :: D

    D = sqrt((b/2._dp)**2 - c)
    roots= (/ -b/2._dp -D, -b/2._dp + D/)
  end function alg_1_dp
  
  function alg_1_sp(b, c) result (roots)
    real(sp), intent(in) :: b, c
    real(sp), dimension(2) :: roots
    real(sp)             :: D

    D = sqrt((b/2._sp)**2 - c)
    roots= (/ -b/2._sp -D, -b/2._sp + D/)
  end function alg_1_sp
  
  function alg_2_sp(b, c) result (roots)
    real(sp), intent(in) :: b, c
    real(sp), dimension(2) :: roots
    real(sp)             :: D, x_1

    D = sqrt((b/2._sp)**2 - c)
    x_1 = sign(abs(b/2._sp) + D, -b)
    roots = (/x_1, c/x_1/)
  end function alg_2_sp

end module quadratic_module

