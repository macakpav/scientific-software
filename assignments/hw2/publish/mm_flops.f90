! Name:     mm_flops
! Purpose:  Prints the size of the matrix and the number of floating point operations
!           per second (in MFLOP/s) for the fastest and slowest method with three nested loops for
!           various matrix sizes
! Author:   pavel.macak@fs.cvut.cz (@student.kuleuven.be)
! Compilation:  Makefile is provided. 
!               To compile this program use 'make mm_flops' or 'make flops' to also run after compilation.

program mm_mflops
    use matrixop
    use timings
    implicit none

    abstract interface
        subroutine mm_interface(a, b, c)
            import dp
            real(kind=dp), dimension(:,:), intent(in)  :: a, b
            real(kind=dp), dimension(:,:), intent(out) :: c
        end subroutine mm_interface
        subroutine mm_blocks_interface(a,b,c,blocksize)
            import dp
            real(kind=dp), dimension(:,:), intent(in)  :: a, b
            real(kind=dp), dimension(:,:), intent(out) :: c
            integer, intent(in) :: blocksize
        end subroutine mm_blocks_interface
    end interface

    !--------------------------------------------------------------------------
    ! Main timing program
    !--------------------------------------------------------------------------
    integer :: k,n
    character(16), parameter :: fileName="flops.dat"
    integer, parameter :: Nmax=1600, blocksize = 100, streamID=10
    integer, dimension(:), allocatable :: seed
    real(kind=dp), allocatable :: a(:,:), b(:,:), c(:,:)

    ! Make sure we use the same pseudo-random numbers each run by initializing
    ! the seed to a certain value.
    call random_seed(size=k)
    allocate(seed(k))
    seed = Nmax
    call random_seed(put=seed)

    allocate(a(Nmax,Nmax),b(Nmax,Nmax),c(Nmax,Nmax))
    call random_number(a)
    call random_number(b)
    c=0.0_dp
    c=matmul(a,b)
    deallocate(a,b,c)
    
    OPEN(streamID,file=fileName)

    do n = 10,90,10
        allocate(a(n,n),b(n,n),c(n,n))
        call random_number(a)
        call random_number(b)
        c=0.0_dp
        call time_mflops(n,mm_ikj,mm_jki)
        deallocate(a,b,c)
    end do

    do n = 100,Nmax,100
        allocate(a(n,n),b(n,n),c(n,n))
        call random_number(a)
        call random_number(b)
        call time_mflops(n,mm_ikj,mm_jki)
        deallocate(a,b,c)
    end do
    CLOSE(streamID)
    deallocate(seed)
contains

    subroutine time_mflops(matrix_n, slow, fast)
        integer, intent(in) :: matrix_n
        procedure(mm_interface), optional :: fast, slow
        real(dp) :: noOperations
        real :: elapsedTimeFast, elapsedTimeSlow
        ! multiplication, addition (is assignment also flop?) = 2 flop
        if ( mod(matrix_n,10) == 0) then
            if ( matrix_n>=100 ) then
                noOperations = 2*(matrix_n/100)**3 ! megaFLOP/second
            else 
                noOperations = 2*(matrix_n/10)**3 /1000._dp ! megaFLOP/second
            end if 
        else
            noOperations = 2*(real(matrix_n,kind=dp)/100._dp)**3 ! megaFLOP/second
        end if
        ! Do the timing
        call tic()
        call fast( a, b, c )
        call toc(elapsedTimeFast)

        call tic()
        call slow( a, b, c )
        call toc(elapsedTimeSlow)

        write(streamID,'(i0,2("  ",f12.4))') matrix_n, noOperations/elapsedTimeSlow, noOperations/elapsedTimeFast
        print "( A, i5, 2(A, f12.4))", "Matrix size: ", matrix_n, ", MFLOP/s slow: ", noOperations/elapsedTimeSlow,&
            ", MFLOP/s fast: ", noOperations/elapsedTimeFast       
        
    end subroutine time_mflops

end program mm_mflops
