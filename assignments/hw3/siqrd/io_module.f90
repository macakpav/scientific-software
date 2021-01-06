! Name:     io_module
! Purpose:  Handles input and output. Defines used structures.
! Author:   pavel.macak@fs.cvut.cz (@student.kuleuven.be)

module io_module
  use siqrd_settings
  implicit none
  public
  private readCommandLineArgument
 ! integer, parameter :: NO_PARAMETERS = 10 ! dT, input from file, input from command line

  type simulationParametersType
    integer :: noSteps
    real(wp) :: dT, totalTime, dBeta, targetValue
    real(wp) :: alpha, beta, gamma, delta, mu
    real(wp) :: S0, I0, initPop
  end type simulationParametersType


interface readCommandLineArgument
  module procedure readRealArgument, readIntArgument
end interface readCommandLineArgument

contains

! reads parameters neccessary for SIQRDoptimize program
subroutine readParamsOptimization(simParams, filename, info)
  implicit none
  character(*), intent(in) :: filename
  type(simulationParametersType), intent(out) :: simParams
  integer, intent(out) :: info

  call readParams(simParams, filename, info, cmdLineCount=4)
  if (info /= 0) return
  call readCommandLineArgument(3, simParams%dBeta, info)
  if (info /= 0) return
  call readCommandLineArgument(4, simParams%targetValue, info)
  info = 0
  
end subroutine readParamsOptimization

! reads parameters neccessary for SIQRDstability program
subroutine readParamsStability(simParams, filename, info)
  implicit none
  character(*), intent(in) :: filename
  type(simulationParametersType), intent(out) :: simParams
  integer, intent(out) :: info

  call readParams(simParams, filename, info, cmdLineCount=0)
  
end subroutine readParamsStability

! reads parameters neccessary for SIQRDsimulate program
subroutine readParams(simParams, filename, info, cmdLineCount)
  implicit none
  character(*), intent(in) :: filename
  type(simulationParametersType), intent(out) :: simParams
  integer, intent(out) :: info
  integer, intent(in), optional :: cmdLineCount
  real(wp),dimension(7) :: array
  integer :: noCmd
  open(7,file=filename) ! is there a way to check streamID is already occupied or just take the first free ID?
  read(7,*,IOstat=info) array(:)
  close(7)

  if ( info/=0 ) then
    write(stderr,*) "Error reading parameters from file: ", filename
    return
  end if

  call checkParams(array,info)
  if (info/=0) then
    write(stderr,*) "Wrong parameters in file: ", filename
    return
  end if

  if (present(cmdLineCount)) then 
    noCmd=cmdLineCount 
  else 
    noCmd=2
  end if 
  
  if ( command_argument_count() < noCmd ) then
    write(stderr,*) "Two command line arguments are required to run this program!"
    write(stdout,*) "Proper use is:     siqrd.exe N T"
    info = 1
    return
  end if

  if ( noCmd == 0 ) then
    simParams%noSteps=0
    simParams%totalTime=0
    simParams%dT=0
  else
    call readCommandLineArgument(1, simParams%noSteps, info)
    if (info /= 0) return
    call readCommandLineArgument(2, simParams%totalTime, info)
    if (info /= 0) return
    simParams%dT = simParams%totalTime / simParams%noSteps
  end if

  simParams%beta = array(1)
  simParams%mu = array(2)
  simParams%gamma = array(3)
  simParams%alpha = array(4)
  simParams%delta = array(5)
  simParams%S0 = array(6)
  simParams%I0 = array(7)
  simParams%initPop = simParams%I0 + simParams%S0
  if ( simParams%initPop<epsilon(0._wp) ) then
    write(stderr,*) "Dangerously low size of initial population!"
    info = 2
    return
  end if

  simParams%noSteps = simParams%noSteps+1 ! the initial condition (at 1st position) does not count as step  
  info = 0

end subroutine readParams

! checks if numbers in array are all positive
subroutine checkParams(array,  info)
  implicit none
  real(wp),dimension(:),intent(in) :: array
  integer,intent(out) ::  info
  integer :: i
  do i = 1, size(array)
    if ( array(i)<0 ) then
      write(stderr,'(a,i0,a)') "Parameter ", i, " has illegal (NEGATIVE) value. "
      info = i
      return
    end if
  end do
  info = 0

end subroutine checkParams

! reads real argument from command line on n-th position
subroutine readRealArgument(n, value, info)
  implicit none
  integer, intent(in) :: n
  real(wp), intent(out) :: value
  integer, intent(out) :: info
  character :: string*64

  call get_command_argument(n,string,status=info)
  if (info /= 0) then
    write(stderr,'(a,i0,a)') "Error parsing argument ", n, " from command line."
    return
  end if

  read (string,*,iostat=info) value
  if (info /= 0) then
    write(stderr,'(a,i0,a)') "Error converting argument ", n, " from command line to real value."
    return
  end if

  info = 0

end subroutine readRealArgument

! reads integer argument from command line on n-th position
subroutine readIntArgument(n, value, info)
  implicit none
  integer, intent(in) :: n
  integer, intent(out) :: value
  integer, intent(out) :: info
  character :: string*64

  call get_command_argument(n,string,status=info)
  if (info /= 0) then
    write(stderr,'(a,i0,a)') "Error parsing argument ", n, " from command line."
    return
  end if

  read (string,*,iostat=info) value
  if (info /= 0) then
    write(stderr,'(a,i0,a)') "Error converting argument ", n, " from command line to integer value."
    return
  end if

  info = 0

end subroutine readIntArgument

! sets outputFileName according to convention given in assignment one
! method_beta_mu_gamma_alpha_delta.out
subroutine setOutputName(outputFileName, methodName, simulationParameters)
  implicit none
  character(*), intent(in) :: methodName
  type(simulationParametersType), intent(in) :: simulationParameters
  character(*), intent(out) :: outputFileName

  write(outputFileName,"(a, '_', 4(i0,'_'), i0, a)") trim(methodName), nint(simulationParameters%beta*100), &
    nint(simulationParameters%mu*100), nint(simulationParameters%gamma*100), nint(simulationParameters%alpha*100), &
    nint(simulationParameters%delta*100), ".out"
end subroutine setOutputName

! writes time and arrayToWrite in one line to streamID
subroutine writeResults(time, arrayToWrite,  streamID)
  implicit none
  real(wp),intent(in) :: time, arrayToWrite(:)
  integer,intent(in) ::  streamID
  character(64) :: format

  write(format,'(a,i0,a)') '(', size(arrayToWrite), '(es11.4,"   "), es11.4)'
  write(streamID,format) time, arrayToWrite

end subroutine writeResults

! writes matrix column by column into streamID starting each line with timestamp. Assummed start time at 0. 
subroutine writeResultMatrix(dT, matrixToWrite,  streamID)
  implicit none
  real(wp),intent(in) :: dT, matrixToWrite(:,:)
  integer,intent(in) ::  streamID
  character(64) :: format
  integer :: j

  write(format,'(a,i0,a)') '(', size(matrixToWrite,1), '(es11.4,"   "), es11.4)'
  do j = 1, size(matrixToWrite,2)
    write(streamID,format) dT*(j-1), matrixToWrite(:,j)
  end do

end subroutine writeResultMatrix

! saves results of simulation into file
subroutine saveResults(matrix, methodName, parameters)
  implicit none
  real(wp), dimension(:,:), intent(in) :: matrix
  type(simulationParametersType), intent(in) :: parameters
  character(*), intent(in) :: methodName
  integer, parameter :: streamID = 10
  character(128) :: outputName

  call setOutputName(outputname, methodName, parameters)

  open(streamID, file=outputName)
  call writeResultmatrix(parameters%dT, matrix, streamID) ! write initial conditions
  close(streamID)
end subroutine saveResults

! prints array to screen
subroutine printArray ( arr )
  real(wp), intent(in) :: arr(:)
  character(64) :: format

  write(format,'(a,i0,a)') "(", size(arr)-1, "(es12.5,'   '),es12.5)" 

  write(stdout,format) arr

end subroutine printArray


!------------------getter functions for SIQRD--------------------!

real(wp) function getS(varsVect) result(S)
  real(wp), intent(in) :: varsVect(:)
  S = varsVect(1)
  return
end function getS

real(wp) function getI(varsVect) result(I)
  real(wp), intent(in) :: varsVect(:)
  I = varsVect(2)
  return
end function getI

real(wp) function getQ(varsVect) result(Q)
  real(wp), intent(in) :: varsVect(:)
  Q = varsVect(3)
  return
end function getQ

real(wp) function getR(varsVect) result(R)
  real(wp), intent(in) :: varsVect(:)
  R = varsVect(4)
  return
end function getR

real(wp) function getD(varsVect) result(D)
  real(wp), intent(in) :: varsVect(:)
  D = varsVect(5)
  return
end function getD

end module io_module

