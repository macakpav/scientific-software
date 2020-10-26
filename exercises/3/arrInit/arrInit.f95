program Main
    use arrInit_module


    real a(10)
    INTEGER i

    do i = 1, 10
        print *, a(i)
    end do

    print *, ""

    a = 0.0

    do i = 1, 10
        print *, a(i)
    end do

    print *, ""

    print *, a(12)
    
end program Main

