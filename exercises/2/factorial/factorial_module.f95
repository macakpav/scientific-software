module factorial_module
    implicit none

    private
    integer,parameter :: INT_KIND=selected_int_kind(12)

    public :: doubleFactorial
    
contains

    recursive integer(kind=INT_KIND) function doubleFactorial(n) result(retval)
        implicit none
        integer(kind=INT_KIND), intent(in) :: n
        
        select case (n)
        case (:-2)
            retval=0
            return
        case (-1:0)
            retval=1
            return
        case default
            retval=n * doubleFactorial(n-2)
            return
        end select

        return
        
    end function doubleFactorial

end module factorial_module
