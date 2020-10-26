program Main
    use matrix_module

    implicit none 

!    real, dimension(4,4) :: something_special = reshape( (/ &
!    1.0000e+00, 1.2500e-01, 1.8750e-01, 8.1250e-01, &
!    3.1250e-01, 6.8750e-01, 6.2500e-01, 5.0000e-01, &
!    5.6250e-01, 4.3750e-01, 3.7500e-01, 7.5000e-01, &
!    2.5000e-01, 8.7500e-01, 9.3750e-01, 6.2500e-02 &
!    /), (/ 4,4 /), order=(/2,1/) )

    real, dimension(-3:3,0:2) :: different_special = reshape( (/ &
    9.0909e-01,1.9091e+00,8.1818e-01,1.4545e+00,4.5455e-01, &
    1.2727e+00,1.8182e-01,2.7273e-01,3.6364e-01,6.3636e-01, &
    1.0000e+00,1.3636e+00,1.6364e+00,1.7273e+00,1.8182e+00, &
    7.2727e-01,1.5455e+00,5.4545e-01,1.1818e+00,9.0909e-02, &
    1.0909e+00 /), (/7,3/), order=(/1,2/) )

    call MatrixStats(different_special)
    

end program Main
