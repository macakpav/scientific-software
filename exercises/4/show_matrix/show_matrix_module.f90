module show_matrix_module

    implicit none
    integer, parameter :: sp = selected_real_kind(6,37), dp = selected_real_kind(15,307), wp = dp  

    interface show_matrix
        module procedure show_matrix_dp
        module procedure show_matrix_sp
    end interface


contains
    subroutine show_matrix_dp( a )
        real(dp), intent(in) :: a(:,:)
        integer :: rows, cols, i, j
        rows=size(a,1)
        cols=size(a,2)

        print '(a,i0,a,i0,a,i0)', 'Matrix: ', rows, 'x', cols, ', kind: ', kind(a)

        do i = 1, rows
            do j = 1, cols
                write(*,fmt='(es11.4,"  ")',advance='NO') a(i,j)
            end do
            print *, ""
        end do

    end subroutine show_matrix_dp

    subroutine show_matrix_sp( a )
        real(sp), intent(in) :: a(:,:)
        integer :: rows, cols, i, j
        rows=size(a,1)
        cols=size(a,2)

        print '(a,i0,a,i0,a,i0)', 'Matrix: ', rows, 'x', cols, ', kind: ', kind(a)

        do i = 1, rows
            do j = 1, cols
                write(*,fmt='(es11.4,"  ")',advance='NO') a(i,j)
            end do
            print *, ""
        end do


    end subroutine show_matrix_sp


end module show_matrix_module
