program Main
    use factorial_module

    implicit none
    integer,parameter :: INT_KIND=selected_int_kind(12)
    integer(kind=INT_KIND) :: n

    print *, "Interger kind of n is", kind(n)

    do n = -1, 49
        print *, "Double factorial of", n, "is",doubleFactorial(n)
    end do

    print *, "Interger kind of n is", kind(n)
    
end program Main
