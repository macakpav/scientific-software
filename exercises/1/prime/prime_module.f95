module prime_module
    implicit none

    private

    public :: IsPrimeFun
    public :: IsPrimeSub
    
contains
    elemental subroutine IsPrimeSub(n, is_prime)
        implicit none
        integer,intent(in) :: n
        logical,intent(out) :: is_prime
        integer :: i
        
        if ( (n==1) .or. (n==0) ) then
            is_prime=.false.
            return
        else if ( n==2 .or. n==3 ) then
            is_prime=.true.
            return
        end if

        is_prime=.true.
        do i = 2, ceiling(sqrt(real(n)))+1
            if ( mod(n,i)==0 ) then
                is_prime=.false.
                return
            end if
        end do

        return
    
    end subroutine IsPrimeSub

    elemental logical function IsPrimeFun(n)
        implicit none
        integer, intent(in) :: n
        integer :: i
        
        if ( (n==1) .or. (n==0) ) then
            IsPrimeFun=.false.
            return
        else if ( n==2 .or. n==3 ) then
            IsPrimeFun=.true.
            return
        end if

        IsPrimeFun=.true.
        do i = 2, ceiling(sqrt(real(n)))+1
            if ( mod(n,i)==0 ) then
                IsPrimeFun=.false.
                return
            end if
        end do

        return
        
    end function IsPrimeFun

end module prime_module