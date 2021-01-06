module methods_module
  use siqrd_settings
  use io_module
  use solver_gfortran
  !use f90_unix_proc
  !use ifport
  implicit none
  private 

  public :: eulerForward
  public :: eulerBackward
  public :: heunMethod

contains

subroutine eulerForward(vars, parameters)
  implicit none
  real(wp), intent(inout) :: vars(:,:) ! matrix of variables
  real(wp), dimension(:), intent(in) :: parameters ! simulation parameters, first element is delta T

  real(wp), dimension(size(vars,1)) :: fvect ! vector of function values f1, f2 etc.
  real(wp) :: dT
  integer :: n, nn ! n - old time layer, nn - new time layer

  nn = ubound(vars,2); n = nn-1
  dT = parameters(1)
  fvect = fvals(vars(:,n), parameters)

  vars(:,nn) = vars(:,n) + dT * fvect(:) ! euler explicit scheme

end subroutine eulerForward

subroutine heunMethod(vars, parameters)
  implicit none
  real(wp), dimension(:,:), intent(inout) :: vars
  real(wp), dimension(:), intent(in) :: parameters

  real(wp), dimension(size(vars,1)) :: fvect
  real(wp) :: dT
  integer :: n, nn

  nn = ubound(vars,2); n = nn-1
  dT = parameters(1)
  fvect = fvals(vars(:,n), parameters)

  vars(:,nn) = vars(:,n) + dT * ( 0.5*fvect + 0.5*fvals( vars(:,n) + dT*fvect, parameters ) ) 
      ! heun explicit scheme, higher order of accuracy

end subroutine heunMethod

subroutine eulerBackward(vars, parameters)
  implicit none
  real(wp), dimension(:,:), intent(inout) :: vars ! matrix of variables
  real(wp), dimension(:), intent(in) :: parameters  ! simulation parameters, first element is delta T

  real(wp), dimension(size(vars,1)) :: temp ! holds result of inversion 
  real(wp), dimension(size(vars,1), size(vars,1)) :: jac ! jacobian matrix
  real(wp) :: dT, res
  integer :: iter, n, nn
  logical :: converged = .false.

  n = ubound(vars,2)-1; nn = ubound(vars,2)
  dT = parameters(1)

  vars(:,nn)=vars(:,n) ! initial estimation x^{0}_{n+1} will be x_n ( values in previous time layer)
  temp = G(dT, vars(:,n), vars(:,nn), parameters)

  do iter = 1, MAX_ITER

    jac = jacobian(vars(:,nn), parameters)            ! compute jacobian
    call solve(jac, temp)                             ! result of jacobian inversion * vector G is in temp
    vars(:,nn) = vars(:,nn) - temp                    ! new value of x_n+1

    temp = G(dT, vars(:,n), vars(:,nn), parameters)  
    res = maxval(abs(temp))                           ! error of solution of G(x)

    if ( res /= res) then ! check for NaN
      write(stderr,'(a,es11.4)') "The temp vector norm is ", res
      call abort()
    end if 
    
    if ( res < TOLERANCE ) then
      converged = .true.
      exit
    end if

  end do

  if ( converged ) then
    !print '(a,i0)', "Converged in: ", iter
    !print *, maxval(abs(temp))
  else
    write(stderr,'(a,es11.4)') "Newton's method did not converge! Last norm(G): ", res
    if (ABORT_CONVERGENCE) call abort()
  end if
  
end subroutine eulerBackward


! -------------------------------- application / equation specific functions -------------------------------- !

function fvals(vars,p) result(retvect) ! is it possible to make this elemental but applied per rows/cols of a matrix?
  implicit none
  real(wp), dimension(:), intent(in) :: vars, p
  real(wp), dimension(5) :: retvect ! size set explicitly on purpose
  real(wp) :: beta,mu,gamma,alpha,delta,S,I,Q,R
  beta=getBeta(p); mu=getMu(p); gamma=getGamma(p); alpha=getAlpha(p); delta=getDelta(p)
  S=getS(vars); I=getI(vars); R=getR(vars); Q=getQ(vars)

  retvect(1)=fS(beta,mu,S,I,R)
  retvect(2)=fI(beta,gamma,delta,alpha,S,I,R)
  retvect(3)=fQ(gamma,delta,alpha,I,Q)
  retvect(4)=fR(mu,gamma,I,Q,R)
  retvect(5)=fD(alpha,I,Q)
  return
end function fvals

function G(dT, xOld, xNew, p) result(retvect)
  implicit none
  real(wp),intent(in) :: dT 
  real(wp),dimension(:),intent(in) :: xOld, xNew, p
  real(wp),dimension(size(xOld)) :: retvect

  retvect = (xOld - xNew) + dT * fvals(xNew, p) 

end function G

function jacobian(vars, p) result(J)
  implicit none
  real(wp), dimension(5), intent(in) :: vars ! explicit size specification is intentional (failsafe)
  real(wp), dimension(:), intent(in) :: p
  real(wp) :: dT
  real(wp), dimension(size(vars),size(vars)) :: J
  real(wp) :: beta,mu,gamma,alpha,delta,S,I,R
  beta=getBeta(p); mu=getMu(p); gamma=getGamma(p); alpha=getAlpha(p); delta=getDelta(p)
  S=getS(vars); I=getI(vars); R=getR(vars)
  dT = getDT(p)
  
  J=0
  J(1,1) = dT * dSdS(beta,S,I,R) - 1
  J(2,1) = dT * dIdS(beta,S,I,R)

  J(1,2) = dT * dSdI(beta,S,I,R)
  J(2,2) = dT * dIdI(beta,gamma,delta,alpha,S,I,R) - 1
  J(3,2) = dT * delta
  J(4,2) = dT * gamma
  J(5,2) = dT * alpha

  J(3,3) = dT * (-1) * (gamma+alpha) - 1
  J(4,3) = dT * gamma
  J(5,3) = dT * alpha

  J(1,4) = dT * dSdR(beta,mu,S,I,R)
  J(2,4) = dT * dIdR(beta,S,I,R)
  J(4,4) = dT * (-1) * mu - 1

  J(5,5) = -1
  
end function jacobian

real(wp) function fS(beta,mu,S,I,R)
  implicit none
  real(wp), intent(in) :: beta,mu,S,I,R
  fS = ( (-1) * beta * S * ( I/(S+I+R) ) + mu*R )
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

real(wp) function dSdS(beta,S,I,R)
  implicit none
  real(wp), intent(in) :: beta,S,I,R
  dSdS = ( (-1) * beta * (I/(S+I+R)) + beta * S * I * (1/(S+I+R)**2) )
  return
end function dSdS

real(wp) function dSdI(beta,S,I,R)
  implicit none
  real(wp), intent(in) :: beta,S,I,R
  dSdI = ( (-1) * beta * (S/(S+I+R)) + beta * S * I * (1/(S+I+R)**2) )
  return
end function dSdI

real(wp) function dSdR(beta,mu,S,I,R)
  implicit none
  real(wp), intent(in) :: beta,mu,S,I,R
  dSdR = ( mu + beta * S * I * (1/(S+I+R)**2) )
  return
end function dSdR

real(wp) function dIdS(beta,S,I,R)
  implicit none
  real(wp),intent(in) :: beta,S,I,R
  dIdS = I * ( beta * (1/(S+I+R)) + beta * S * (-1) * (1/(S+I+R)**2) )
  return
end function dIdS

real(wp) function dIdI(beta,gamma,delta,alpha,S,I,R)
  implicit none
  real(wp),intent(in) :: beta,gamma,delta,alpha,S,I,R
  dIdI = I * ( beta * S * (-1) * (1/(S+I+R)**2) ) + ( beta * (S/(S+I+R)) - gamma - delta - alpha )
  return
end function dIdI

real(wp) function dIdR(beta,S,I,R)
  implicit none
  real(wp),intent(in) :: beta,S,I,R
  dIdR = I * beta * S * (-1) *(1/(S+I+R)**2) 
  return
end function dIdR

end module methods_module

