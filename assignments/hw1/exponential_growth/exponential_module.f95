module exponential_module
  USE, INTRINSIC :: iso_fortran_env
  implicit none

public

  integer, parameter :: stdin = input_unit, stdout = output_unit, stderr = error_unit !standard output interface
  integer, parameter :: dp = selected_real_kind(15), sp = selected_real_kind(6) ! double and single precission types
  integer, parameter :: wp = sp !set working precission of real numbers
  
contains

  subroutine exponentialGrowthPrediction(r, d, I0)
    implicit none
    real(wp),intent(in) :: r, d, I0
    real(wp) :: Id

    Id=(1+r)**d * I0

    write(stdout,'(a,i3,a)') "Number of people infected after ", nint(d), " days will be:"
    write(stdout,*) int(Id)
  end subroutine exponentialGrowthPrediction

end module exponential_module

