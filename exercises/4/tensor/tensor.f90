program Main
    use tensor_module

    real(wp), allocatable :: T(:,:,:)
    character :: string*32
    integer :: n, i
    
    call get_command_argument(1,string)
    write (*,*) "Number N is ", string
    read (string,*) n

    allocate(T(n,n,n), stat=i)
    if ( i == 0 ) then
        print *, "Allocation successfull"
        T=reshape((/ (i, i=(n**3),1,-1) /), (/n,n,n/) )
        !print *, T(1,n,n)
    else
        print *, "Allocation failed!"
    end if

    print *,""
    call get_command_argument(2,string)
    call compare(T,string)

    print *,""
    print *, builtinsum(T)
    print *, blocksum(T)
    print *, smallest(T)
    print *, biggest(T)
    print *, kahan(T)
    
    if ( allocated(T) ) deallocate(T)
end program Main

