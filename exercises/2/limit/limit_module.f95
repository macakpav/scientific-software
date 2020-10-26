module limit_module
    implicit none

    private
    integer,parameter :: qp = selected_real_kind(33,4931), ep = selected_real_kind(18,291), dp = selected_real_kind(15,307)
    integer,parameter :: REAL_KIND=dp

    public :: f, g
    
contains

    real(kind=REAL_KIND) function f(x) result(retval)
        implicit none
        real(kind=REAL_KIND), intent(in) :: x

        retval = (1 - cos(x))/x**2
        return
        
    end function f

    real(kind=REAL_KIND) function g(x) result(retval)
    implicit none
    real(kind=REAL_KIND), intent(in) :: x

    retval = 2 * sin(x/2)**2 / x**2
    return
    
end function g

end module limit_module
