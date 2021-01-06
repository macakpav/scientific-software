module simulation_module
  use siqrd_settings
  use io_module
  use methods_module
  implicit none
  private

  public :: simulateSIQRD

contains

subroutine simulateSIQRD(method, methodName, simulationParameters, outputFileName)
  implicit none
  character(*), intent(in) :: methodName
  real(wp), dimension(:), intent(in) :: simulationParameters
  character(*), optional, intent(in) :: outputFileName

  interface ! definition of method interface
    subroutine method(vars, parameters)
      use siqrd_settings
      real(wp), dimension(:,:), intent(inout) :: vars
      real(wp), dimension(:), intent(in) :: parameters
    end subroutine method
  end interface

  real(wp) :: variables(5,2), time, dT, initPop 
  character(128) :: outputName
  integer, parameter :: streamID = 10, n=1, nn=2 ! n and nn refers to old and new time layer respectively
  integer :: iter

  ! initialization
  variables = 0.0
  time = 0.0
  dT = getDT(simulationParameters)
  initPop = getInitPop(simulationParameters) ! initial population count

  if ( present(outputFileName) ) then ! select name for output file
    outputName = outputFileName
  else
    call setOutputName(outputName, methodName, simulationParameters) 
  end if

  ! initial condition
  variables([1,2],nn)= [ getS0(simulationParameters), getI0(simulationParameters) ] 
      ! assign initial values (S0,I0) to the second row, because of the initial swap in iteration

  open(streamID, file=outputName)
  call writeResults(time, variables(:,nn), streamID) ! write initial conditions
  time = time + dT
  
  ! main loop
  do iter = 1, NO_STEPS
    variables(:,(/n,nn/)) = variables(:,(/nn,n/))     ! swap lines so that old time layer is on nth row
    time = time + dT                                  ! new time value
    call method(variables, simulationParameters)      ! simulate new time layer (set to last row of variables)
    call restrict(variables(:,nn), 0._wp, initPop)    ! no component should become negative or grow higher than sum of initial individuals
    call writeResults(time,variables(:,nn), streamID) ! write newly computed time layer to file
  end do

  print *, getR(variables(:,nn))

  close(streamID)
end subroutine simulateSIQRD

elemental subroutine restrict(num, lower, upper) ! restricts the value between lower and upper bound
  implicit none
  real(wp),intent(inout) :: num
  real(wp),intent(in) :: lower, upper
  num = max(min(num,upper),lower)
end subroutine restrict

end module simulation_module

