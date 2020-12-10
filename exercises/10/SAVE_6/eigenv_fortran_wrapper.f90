!gfortran -c -O3 -fPIC -o eigenv_fortran_wrapper.o eigenv_fortran_wrapper.f90

subroutine f_eig(cpp_fun_ptr, mptr, matrix_size, eigvr, eigvi) bind(c, name='fortran_eig')
    use, intrinsic :: iso_c_binding, only: c_double, c_int, c_ptr, c_funptr, c_f_procpointer
    use, intrinsic :: iso_fortran_env
    implicit none 

    type(c_funptr),value :: cpp_fun_ptr
    type(c_ptr), value, intent(in) :: mptr
    integer(c_int), intent(in) :: matrix_size
    real(c_double), dimension(matrix_size), intent(out) :: eigvr, eigvi

    real(c_double), dimension(matrix_size,matrix_size) :: matrix
    integer(c_int) :: ldvl=1, ldvr=1, lwmax=10000
    real(c_double) :: temp(1), v(1), eye_vect(matrix_size)
    real(c_double), allocatable :: work(:)
    integer :: info, lwork, i

    interface ! LAPACK routine to compute eigenvalues
    subroutine dgeev (JOBVL, JOBVR, N, A, LDA, WR, WI, VL, LDVL, VR, LDVR, WORK, LWORK, INFO)
      CHARACTER          JOBVL, JOBVR
      INTEGER            INFO, LDA, LDVL, LDVR, LWORK, N
      DOUBLE PRECISION   A( LDA, * ), VL( LDVL, * ), VR( LDVR, * ), WI( * ), WORK( * ), WR( * )
    end subroutine dgeev
    end interface

    interface
    subroutine cpp_mv_interface(A, n, x, y)
      use iso_c_binding, only: c_ptr, c_int, c_double
      type(c_ptr), value, intent(in) :: A     
      integer(c_int) ::  n
      real(c_double), intent(in) :: x(*)
      real(c_double), intent(out) :: y(*)
    end subroutine cpp_mv_interface
    end interface

    procedure(cpp_mv_interface), pointer :: matvec
    call c_f_procpointer (cpp_fun_ptr, matvec)

    do i = 1, matrix_size
        eye_vect=0 ! would only suffice to put zero to i-1 th element
        eye_vect(i)=1
        call matvec(mptr,matrix_size,eye_vect,matrix(:,i))
    end do

    ! get optimal size for work array
    lwork = -1
    call dgeev('N','N', matrix_size, matrix, matrix_size, eigvr, eigvi, v, ldvl, v, ldvr, temp, lwork, info)
    if (info/=0) then
      write(error_unit,'(a,i0,a)') "Error getting the optimal size for dgeev, (", info,")."
      go to 10
    end if

    ! allocate work array
    lwork = min(lwmax,ceiling(temp(1)))
    allocate(work(lwork))

    ! actually run dgeev
    call dgeev('N','N', matrix_size, matrix, matrix_size, eigvr, eigvi, v, ldvl, v, ldvr, work, lwork, info)
    if (info/=0) then
      write(error_unit,'(a,i0,a)') "Error in dgeev, (", info,")."
      go to 10
    end if

 10   if (allocated(work)) deallocate(work)
end subroutine
