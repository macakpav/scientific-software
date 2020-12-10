
subroutine fortran_vec_cpy(x,n,y) bind(c,name='fortran_vec_cpy')
    use, intrinsic :: iso_c_binding, only: c_double, c_int
    use, intrinsic :: iso_fortran_env
    implicit none
    integer(c_int), intent(in) :: n
    real(c_double),dimension(*), intent(in) :: x
    real(c_double),dimension(*), intent(out) :: y    
    integer(c_int) :: i

    do i=1,n
        y(i)=x(i)
    end do
end subroutine