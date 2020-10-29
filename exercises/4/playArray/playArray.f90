program Main
    use playArray_module
    use show_matrix_module

    real(wp) :: x(7,10)
    INTEGER :: v(size(x,2)), c(size(x,1))
    logical :: w
    call random_number(x)
    call play_with_array(x,v,w,c)

    call show_matrix(x)
    print '(10(i0,"    "))',v
    print *,  w
    print '(7("   ",i0,"  "))',c
    
end program Main
