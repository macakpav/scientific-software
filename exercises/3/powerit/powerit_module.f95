module powerit_module
    implicit none

    public

    integer, parameter :: dp = selected_real_kind(15) ! double and single precission types
    integer, parameter :: wp = dp ! set working precission of real numbers

    
contains

subroutine powerIterationMrehod(A, Kmax, eps, lambda, x)
implicit none
real(wp),intent(in) :: A(:,:), eps
integer,intent(in) :: Kmax
real(wp),intent(out) :: lambda, x(size(A,1))
real(wp),dimension((size(x))) :: z,R
integer :: k
! check if A is square

call random_number(x)
x = x/norm2(x)
k = 0

do while (k<Kmax)
  z = matmul(A,x)
  lambda = dot_product(x,z)
  R = z - lambda*x
  if (norm2(R) < eps) exit
  x=z/norm2(z)
  k=k+1
end do


end subroutine powerIterationMrehod

end module powerit_module
