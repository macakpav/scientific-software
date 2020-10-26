program Main
    use alloc_module

    real(wp), allocatable :: x(:)
    integer, parameter :: n=500
    
    ALLOCATE(x(n))
    
end program Main

! leak suggest 
! debugg flag in compiler helps vlagrind to identify lines of code involved
