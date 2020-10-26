program Main
    use prime_module

    implicit none
    integer :: n,i,ns(2,10)
    logical :: is_prime(2,10)

    n=3
    ns=reshape((/ (i, i=3,41,2) /), (/2,10/) )
    call IsPrimeSub(ns,is_prime)
    print *, is_prime
    print *, IsPrimeFun(ns)
    
end program Main