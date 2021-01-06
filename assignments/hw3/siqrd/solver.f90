! Name:     solver
! Purpose:  Solves system of linear equations using LAPACK library.
! Author:   pavel.macak@fs.cvut.cz (@student.kuleuven.be)
! Uses: LAPACK

module solver

  implicit none
  private
  integer, parameter :: dp = selected_real_kind(15), sp = selected_real_kind(6) ! double and single precission types
  public :: solve
  interface solve
    module procedure solve_dp, solve_sp
  end interface

  interface 
  subroutine dgesv (N, NRHS, A, LDA, IPIV, B, LDB, INFO)
    INTEGER            INFO, LDA, LDB, N, NRHS
    INTEGER            IPIV( * )
    DOUBLE PRECISION   A( LDA, * ), B( LDB, * )
  end subroutine
  subroutine sgesv (N, NRHS, A, LDA, IPIV, B, LDB, INFO)
    INTEGER            INFO, LDA, LDB, N, NRHS
    INTEGER            IPIV( * )
    REAL               A( LDA, * ), B( LDB, * )
  end subroutine
  end interface
contains

subroutine solve_dp(A, bx) ! A shall not be submatrix of a bigger matrix
  implicit none
  real(dp), dimension(:,:),intent(in) :: A
  real(dp), dimension(:)  ,intent(out) :: bx
  integer :: pivot(size(bx)), info
  call dgesv(size(A,1), 1, A, size(A,1), pivot, bx, size(bx), info )
  if (info /= 0) print *, "Call for DGESV failed with errorcode ", info
end subroutine solve_dp


subroutine solve_sp(A, bx) ! A shall not be submatrix of a bigger matrix
  implicit none
  real(sp), dimension(:,:),intent(in) :: A
  real(sp), dimension(:)  ,intent(out) :: bx
  integer :: pivot(size(bx)), info
  call sgesv(size(A,1), 1, A, size(A,1), pivot, bx, size(bx), info )
  if (info /= 0) print *, "Call for SGESV failed with errorcode ", info
end subroutine solve_sp

end module solver

