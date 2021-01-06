module io_module
  use siqrd_settings
  implicit none

contains

subroutine readParams(array, filename)
  implicit none
  character(*), intent(in) :: filename
  real(wp),intent(out),dimension(:) :: array
  array(1) = TIME_HORIZON / real(NO_STEPS) ! first parameter is dT
  open(7,file=filename) ! is there a way to check streamID is already occupied or just take the first free ID?
  read(7,*) array(2:)
  close(7)
end subroutine readParams

subroutine setOutputName(outputFileName, methodName, simulationParameters)
  implicit none
  character(*), intent(in) :: methodName
  real(wp), dimension(:), intent(in) :: simulationParameters
  character(*), intent(out) :: outputFileName

  write(outputFileName,"(a, '_', 4(i0,'_'), i0, a)") trim(methodName), nint(getBeta(simulationParameters)*100), &
    nint(getMu(simulationParameters)*100), nint(getGamma(simulationParameters)*100), nint(getAlpha(simulationParameters)*100), &
    nint(getDelta(simulationParameters)*100), ".out"
end subroutine setOutputName

subroutine writeResults(time, arrayToWrite,  streamID)
  implicit none
  real(wp),intent(in) :: time, arrayToWrite(:)
  integer,intent(in) ::  streamID
  character(64) :: format

  write(format,'(a,i0,a)') '(', size(arrayToWrite), '(es11.4,"   "), es11.4)'
  write(streamID,format) time, arrayToWrite

end subroutine writeResults

! getter functions for dT,beta,mu,gamma,alpha,delta,S0,I0 and SIQRD (in case the order of inputs changes again)
real(wp) function getDT(parameters) result(dT)
  implicit none
  real(wp),dimension(:) :: parameters
  dT = parameters(1)
  return  
end function getDT

real(wp) function getBeta(parameters) result(beta)
  implicit none
  real(wp),dimension(:) :: parameters
  beta = parameters(2)
  return  
end function getBeta

real(wp) function getMu(parameters) result(mu)
  implicit none
  real(wp),dimension(:) :: parameters
  mu = parameters(3)
  return  
end function getMu

real(wp) function getGamma(parameters) result(gamma)
  implicit none
  real(wp),dimension(:) :: parameters
  gamma = parameters(4)
  return  
end function getGamma

real(wp) function getAlpha(parameters) result(alpha)
  implicit none
  real(wp),dimension(:) :: parameters
  alpha = parameters(5)
  return  
end function getAlpha

real(wp) function getDelta(parameters) result(delta)
  implicit none
  real(wp),dimension(:) :: parameters
  delta = parameters(6)
  return  
end function getDelta

real(wp) function getS0(parameters) result(S0)
  implicit none
  real(wp),dimension(:) :: parameters
  S0 = parameters(7)
  return  
end function getS0

real(wp) function getI0(parameters) result(I0)
  implicit none
  real(wp),dimension(:) :: parameters
  I0 = parameters(8)
  return  
end function getI0

real(wp) function getInitPop(parameters) result(Init)
  implicit none
  real(wp),dimension(:) :: parameters
  Init = getI0(parameters) + getS0(parameters)
  return 
end function getInitPop

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

