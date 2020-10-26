program Main
    use powerit_module

    real(wp) :: A(3,3), lambda, x(3)
    real(wp), parameter :: eps = 1e-12
    integer, parameter :: Kmax = 100


    open(7,file="A.in")
    read(7,*) A
    close(7)

    print *, A

    call powerIterationMrehod(A, Kmax, eps, lambda, x)
    print *, x, lambda


end program Main

