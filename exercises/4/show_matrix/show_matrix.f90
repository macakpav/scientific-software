program Main
    use show_matrix_module

    implicit none  
    real(wp), DIMENSION(3,3) :: a
    a = RESHAPE( [1,2,3,4,5,6,7,8,9], [3,3] )
    print *, a(1,3)
    call show_matrix(a)

end program Main
