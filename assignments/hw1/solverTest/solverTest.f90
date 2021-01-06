program Main
  use solver_gfortran
  
  implicit none

  integer, parameter :: double = selected_real_kind(15)!, single = selected_real_kind(6) ! double and single precission types
  integer, parameter :: working = double ! set working precission of real numbers
  
  real(working), DIMENSION(3,3) :: A
  real(working), dimension(3) :: bx

  A = reshape([ 1., 0., 1., 0., 1., 1., 1., 1., 1. ], [3,3] ) ! just a random full matrix
  bx = [ 1., 2., 3. ]

  print *, bx ! vector b
  call solve(A, bx)
  print *, bx ! should now be vector x [ 1 2 0 ]
  print *, ""
  
  A = reshape([ 1., 0., 1., 0., 1., 1., 1., 1., 0. ], [3,3] )
  print *, matmul(A, bx) ! should print vector b
  
end program Main
