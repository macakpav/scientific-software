program Main
    use alloc2_module

    real(wp), allocatable :: a(:)

    allocate(a(10))
    print *,a(1)

    a(15)=1.0
    print *,a(12)

    deallocate(a)
    
end program Main

! leak suggest 
! debugg flag in compiler helps vlagrind to identify lines of code involved
