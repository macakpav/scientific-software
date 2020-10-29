module playArray_module
    use show_matrix_module
    implicit none
    public 
    

contains

subroutine play_with_array(x, v, w, c)
implicit none
real(wp), dimension(:,:), intent(inout) :: x
integer, dimension(:), intent(out) :: v, c
logical,intent(out) :: w

v = any(x>0.75,1)
where ( v == 1 ) 
    v = 42
elsewhere
    v = -12
endwhere

w = all(v==42)
c = count(x<0.25,2)

where (x >= 0.3 .and. x <0.65 ) x = 0.45

end subroutine play_with_array


end module playArray_module
