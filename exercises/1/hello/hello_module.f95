module Hello
    implicit none

    save
    private

    integer :: n, i
    integer, parameter :: MAX_PRINTS = 20

    public :: HelloWorld

contains

    subroutine HelloWorld
        
        read *,n

        select case (n)
        case (:-1)
            print *, 'I don''t know how un-greet the World, sorry.'
            
        case (MAX_PRINTS+1:)
            print *, 'I won''t greet the World that much.'
            
        case (0)
            print *, 'No greeting for the World then.'
            
        case default
            do i = 1, n
                print *,'Hello World!'
            enddo
        end select
    end subroutine
end module