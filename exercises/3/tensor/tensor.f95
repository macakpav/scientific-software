program Main
    use tensor_module

    integer(8), allocatable :: tensor(:,:,:)
    integer(8) :: n, i

    print *, "Enter number n:"
    read *, n

    allocate(tensor(n,n,n), stat=i)
    if ( i == 0 ) then
        print *, "Allocation successfull"
        tensor=reshape((/ (i, i=(n**3),1,-1) /), (/n,n,n/) )
        print *, tensor(1,n,n)
    else
        print *, "Allocation failed!"
    end if
    if ( allocated(tensor) ) deallocate(tensor)
end program Main

