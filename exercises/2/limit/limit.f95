program Main
    use limit_module

    implicit none
    integer,parameter :: qp = selected_real_kind(33,4931), ep = selected_real_kind(18,291), dp = selected_real_kind(15,307)
    integer,parameter :: REAL_KIND=dp
    real(kind=REAL_KIND) :: x

    print *, "Real kind of x is", kind(x)
    
    x=1
    do while (x>=epsilon(x))
        x=x/10
        print *, "Value f(x) for x =",x,"is",f(x)
        
    end do

    print *, ""
    x=1
    do while (x>=epsilon(x))
        x=x/10
        print *, "Value g(x) for x =",x,"is",g(x)
        
    end do

    print *, "Real kind of x is", kind(x)
    
end program Main
