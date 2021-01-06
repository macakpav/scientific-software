! Name:     methods_module
! Purpose:  Defines methods to simulate SIQRD.
! Author:   pavel.macak@fs.cvut.cz (@student.kuleuven.be)

module methods_module
  use siqrd_settings
  use io_module
  use solver
  ! use f90_unix_proc
  ! use ifport
  implicit none
  private 

  public :: eulerForward
  public :: eulerBackward
  public :: heunMethod

  public :: jacobianSIQRD

contains

! simulate new time layer using Euler's forward method
subroutine eulerForward(vars, parameters, info)
  implicit none
  real(wp), intent(inout) :: vars(:,:) ! matrix of variables
  type(simulationParametersType), intent(in) :: parameters ! simulation parameters, first element is delta T
  integer, intent(out) :: info

  real(wp), dimension(size(vars,1)) :: fvect ! vector of function values f1, f2 etc.
  integer :: n, nn ! n - old time layer, nn - new time layer
  ! print *, vars
  nn = ubound(vars,2); n = nn-1
  fvect = fvals(vars(:,n), parameters)

  vars(:,nn) = vars(:,n) + parameters%dT * fvect(:) ! euler explicit scheme

  info = 0

end subroutine eulerForward

! simulate new time layer using Heun's method
subroutine heunMethod(vars, parameters, info)
  implicit none
  real(wp), dimension(:,:), intent(inout) :: vars
  type(simulationParametersType), intent(in) :: parameters
  integer, intent(out) :: info

  real(wp), dimension(size(vars,1)) :: fvect
  integer :: n, nn

  nn = ubound(vars,2); n = nn-1
  fvect = fvals(vars(:,n), parameters)

  vars(:,nn) = vars(:,n) + parameters%dT * ( 0.5*fvect + 0.5*fvals( vars(:,n) &
                                            + parameters%dT*fvect, parameters ) ) 
      ! heun explicit scheme, higher order of accuracy
  info = 0
end subroutine heunMethod

! simulate new time layer using Euler's backward method
subroutine eulerBackward(vars, parameters, info)
  implicit none
  real(wp), dimension(:,:), intent(inout) :: vars ! matrix of variables
  type(simulationParametersType), intent(in) :: parameters  ! simulation parameters, first element is delta T
  integer, intent(out) :: info

  real(wp), dimension(size(vars,1)) :: temp ! holds result of inversion 
  real(wp), dimension(size(vars,1), size(vars,1)) :: jac ! jacobian matrix
  real(wp) :: res
  integer :: iter, n, nn

  n = ubound(vars,2)-1; nn = ubound(vars,2)

  vars(:,nn)=vars(:,n) ! initial estimation x^{0}_{n+1} will be x_n ( values in previous time layer)


  info = -10
  do iter = 1, MAX_ITER

    temp = G(vars(:,n), vars(:,nn), parameters)
    res = maxval(abs(temp))/real(parameters%initPop,kind=wp)        ! error of solution of G(x)

    if ( res /= res) then ! check for NaN
      write(stderr,'(a,es11.4)') "The temp vector norm is ", res
      info = -1
      return
    end if 
    
    if ( res < TOLERANCE ) then
      info = 0
      exit
    end if

    jac = jacG(vars(:,nn), parameters)                ! compute jacobian
    call solve(jac, temp)                             ! result of jacobian inversion * vector G is in temp
    vars(:,nn) = vars(:,nn) - temp                    ! new value of x_n+1
  end do

  if ( info == -10 )  then
    write(stderr,'(a,es11.4)') "Newton's method did not converge! Last norm(G): ", res
    return
  end if

  !print '(a,i0)', "Converged in: ", iter
  !print *, maxval(abs(temp))
  info = 0
  
end subroutine eulerBackward


! -------------------------------- application / equation specific functions -------------------------------- !

! evaluate SIQRD equations in variables array vars and parameters p 
function fvals(vars,p) result(retvect)
  implicit none
  type(simulationParametersType), intent(in) :: p
  real(wp), dimension(:), intent(in) :: vars
  real(wp), dimension(5) :: retvect
  real(wp) :: beta,mu,gamma,alpha,delta,S,I,Q,R
  beta=p%beta; mu=p%mu; gamma=p%gamma; alpha=p%alpha; delta=p%delta
  S=getS(vars); I=getI(vars); R=getR(vars); Q=getQ(vars)

  retvect(1)=fS(beta,mu,S,I,R)
  retvect(2)=fI(beta,gamma,delta,alpha,S,I,R)
  retvect(3)=fQ(gamma,delta,alpha,I,Q)
  retvect(4)=fR(mu,gamma,I,Q,R)
  retvect(5)=fD(alpha,I,Q)
  return
end function fvals

! evaluate xOld + dT * fvals(xNew) - xNew
function G(xOld, xNew, p) result(retvect)
  implicit none
  type(simulationParametersType), intent(in) :: p
  real(wp),dimension(:),intent(in) :: xOld, xNew
  real(wp),dimension(size(xOld)) :: retvect

  retvect = (xOld - xNew) + p%dT * fvals(xNew, p) 

end function G

! evaluate dG/dxNew - jacobian of function G with respect to xNew
function jacG(vars, p) result(J)
  implicit none
  real(wp), dimension(:), intent(in) :: vars
  type(simulationParametersType), intent(in) :: p
  real(wp), dimension(size(vars),size(vars)) :: J
  ! integer :: i
  real(wp) :: beta,mu,gamma,alpha,delta,S,I,R,dT
  beta=p%beta; mu=p%mu; gamma=p%gamma; alpha=p%alpha; delta=p%delta
  S=getS(vars); I=getI(vars); R=getR(vars)
  dT = p%dT
  
  ! J=jacobianSIQRD(vars,p) * p%dT
  ! do i = 1, size(vars)
  !   J(i,i) = J(i,i) - 1._wp
  ! end do

  J=0._wp
  J(1,1) = dT * dSdS(beta,S,I,R) - 1._wp
  J(2,1) = dT * dIdS(beta,S,I,R)

  J(1,2) = dT * dSdI(beta,S,I,R)
  J(2,2) = dT * dIdI(beta,gamma,delta,alpha,S,I,R) - 1._wp
  J(3,2) = dT * delta
  J(4,2) = dT * gamma
  J(5,2) = dT * alpha

  J(3,3) = dT * (-1._wp) * (gamma+alpha) - 1._wp
  J(4,3) = dT * gamma
  J(5,3) = dT * alpha

  J(1,4) = dT * dSdR(beta,mu,S,I,R)
  J(2,4) = dT * dIdR(beta,S,I,R)
  J(4,4) = dT * (-1._wp) * mu - 1._wp

  J(5,5) = -1._wp
  
end function jacG

! evaluate jacobian of SIQRD equations
function jacobianSIQRD(vars, p) result(J)
  implicit none
  real(wp), dimension(:), intent(in) :: vars
  type(simulationParametersType), intent(in) :: p
  real(wp), dimension(size(vars),size(vars)) :: J
  real(wp) :: beta,mu,gamma,alpha,delta,S,I,R
  beta=p%beta; mu=p%mu; gamma=p%gamma; alpha=p%alpha; delta=p%delta
  S=getS(vars); I=getI(vars); R=getR(vars)
  
  J=0._wp
  J(1,1) = dSdS(beta,S,I,R)
  J(2,1) = dIdS(beta,S,I,R)

  J(1,2) = dSdI(beta,S,I,R)
  J(2,2) = dIdI(beta,gamma,delta,alpha,S,I,R)
  J(3,2) = delta
  J(4,2) = gamma
  J(5,2) = alpha

  J(3,3) = (-1._wp) * (gamma+alpha)
  J(4,3) = gamma
  J(5,3) = alpha

  J(1,4) = dSdR(beta,mu,S,I,R)
  J(2,4) = dIdR(beta,S,I,R)
  J(4,4) = (-1._wp) * mu
  
end function jacobianSIQRD

!--------------------functions to evaluate each one of SIQRD equations separately-------------------!

real(wp) function fS(beta,mu,S,I,R)
  implicit none
  real(wp), intent(in) :: beta,mu,S,I,R
  fS = ( (-1._wp) * beta * S * ( I/(S+I+R) ) + mu*R )
  return
end function fS

real(wp) function fI(beta,gamma,delta,alpha,S,I,R)
  implicit none
  real(wp),intent(in) :: beta,gamma,delta,alpha,S,I,R
  fI = I * ( beta * (S/(S+I+R)) - gamma - delta - alpha )
  return
end function fI

real(wp) function fQ(gamma,delta,alpha,I,Q) 
  implicit none
  real(wp),intent(in) :: gamma,delta,alpha,I,Q
  fQ = delta*I - (gamma+alpha) * Q
  return
end function fQ

real(wp) function fR(mu,gamma,I,Q,R)
  implicit none
  real(wp),intent(in) :: mu,gamma,I,Q,R
  fR = gamma * (I+Q) - mu*R
  return  
end function fR

real(wp) function fD(alpha,I,Q)
  implicit none
  real(wp),intent(in) :: alpha,I,Q
  fD = alpha * (I+Q)
  return  
end function fD

!--------------------functions to evaluate each non-zero derivative of SIQRD equations separately wrt. each varable-------------------!

real(wp) function dSdS(beta,S,I,R)
  implicit none
  real(wp), intent(in) :: beta,S,I,R
  dSdS = ( (-1._wp) * beta * (I/(S+I+R)) + beta * S * I * (1._wp/(S+I+R)**2) )
  return
end function dSdS

real(wp) function dSdI(beta,S,I,R)
  implicit none
  real(wp), intent(in) :: beta,S,I,R
  dSdI = ( (-1._wp) * beta * (S/(S+I+R)) + beta * S * I * (1._wp/(S+I+R)**2) )
  return
end function dSdI

real(wp) function dSdR(beta,mu,S,I,R)
  implicit none
  real(wp), intent(in) :: beta,mu,S,I,R
  dSdR = ( mu + beta * S * I * (1._wp/(S+I+R)**2) )
  return
end function dSdR

real(wp) function dIdS(beta,S,I,R)
  implicit none
  real(wp),intent(in) :: beta,S,I,R
  dIdS = I * ( beta * (1/(S+I+R)) + beta * S * (-1._wp) * (1._wp/(S+I+R)**2) )
  return
end function dIdS

real(wp) function dIdI(beta,gamma,delta,alpha,S,I,R)
  implicit none
  real(wp),intent(in) :: beta,gamma,delta,alpha,S,I,R
  dIdI = I * ( beta * S * (-1._wp) * (1/(S+I+R)**2) ) + ( beta * (S/(S+I+R)) - gamma - delta - alpha )
  return
end function dIdI

real(wp) function dIdR(beta,S,I,R)
  implicit none
  real(wp),intent(in) :: beta,S,I,R
  dIdR = I * beta * S * (-1._wp) *(1._wp/(S+I+R)**2) 
  return
end function dIdR

end module methods_module

