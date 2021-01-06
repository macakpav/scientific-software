! Name:     simulation_module
! Purpose:  Run simulation of SIQRD using different methods.
! Author:   pavel.macak@fs.cvut.cz (@student.kuleuven.be)

module simulation_module
  use siqrd_settings
  use io_module
  use methods_module
  implicit none
  private

  public :: simulateSIQRD

contains

! Simulates SIQRD equations using provided method for solving intial value problems.
! Uses simulationParameters to evaluate SIQRD equations.
! Stores results in scratchArray if provided, otherwise provides no actual output.
subroutine simulateSIQRD(method, simulationParameters, scratchArray)
  implicit none
  type(simulationParametersType), intent(in) :: simulationParameters
  real(wp), dimension(:,:), target, optional, intent(out) :: scratchArray
  ! external method
interface ! definition of method interface
  subroutine method(vars, parameters, info)
    use siqrd_settings
    use io_module
    real(wp), dimension(:,:), intent(inout) :: vars
    type(simulationParametersType), intent(in) :: parameters
    integer, intent(out) :: info
  end subroutine method
end interface

  real(wp), pointer :: variables(:,:)
  real(wp) :: initPop
  integer :: step, status = 0

  ! possible allocation
  if (present(scratchArray)) then
    ! check dimensions of scratch space
    if (size(scratchArray,1) /= 5 .or. size(scratchArray,2) /= simulationParameters%noSteps) then
      write(stderr, fmt='(3(a,i0),a)') "Wrong size of scratch array given to simulateSIQRD. Has to be 5x",&
      simulationParameters%noSteps,". Is:",size(scratchArray,1),"x",size(scratchArray,2),"."
      status = -3
      return 
    end if
    variables => scratchArray
  else
    ! allocate space to hold variables
    write(stdout, fmt='(a)', advance="no") "No scratch array given to simulateSIQRD, allocating now...  "
    allocate( variables(5,simulationParameters%noSteps), stat=status)
    if (status/=0) then
      write(stderr, fmt='(a)') "Error allocating variables matrix inside simulateSIQRD procedure!"
      return 
    end if 
    write(stdout, fmt='(a)') "allocated."
  end if 

  ! initialization
  variables = 0.0
  initPop = simulationParameters%initPop ! initial population count

  ! initial condition
  variables([1,2],1)= [ simulationParameters%S0, simulationParameters%I0 ] 
      ! assign initial values (S0,I0)
  
  ! main loop
  do step = 2, simulationParameters%noSteps
    call method(variables(:,step-1:step), simulationParameters, status)! simulate new time layer (set to last row of variables)
    
    if (status /= 0) then 
      write(stderr,'(a,a,a,i0)') "simulateSIQRD: Error during call of method in interation number ", step 
      exit
    end if

    call restrict(variables(:,step), 0._wp, initPop)    ! no component should become negative or grow higher than initial population
  end do
  ! write(stdout, *) getR(variables(:,step-1))

  if (.not. present(scratchArray)) deallocate(variables)
  
end subroutine simulateSIQRD

! keeps num between lower and upper bound
elemental subroutine restrict(num, lower, upper)
  implicit none
  real(wp),intent(inout) :: num
  real(wp),intent(in) :: lower, upper
  num = max(min(num,upper),lower)
end subroutine restrict

end module simulation_module

