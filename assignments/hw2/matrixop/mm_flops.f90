program mm_mflops
    use matrixop
    use timings
    implicit none
    
  
    !--------------------------------------------------------------------------
    ! Abstract interfaces
    !
    ! NOTE: this simplifies the timings.
    !--------------------------------------------------------------------------
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
    integer, parameter :: Nmax=1600, blocksize = 100
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
    deallocate(a,b,c,seed)
    
    OPEN(10,file="flops.dat")

    do n = 100,1600,100
        call random_seed(size=k)
        allocate(seed(k))
        seed = n
        call random_seed(put=seed)
        allocate(a(n,n),b(n,n),c(n,n))
        call random_number(a)
        call random_number(b)
        c=0.0_dp
        call time_mflops_block(n,mm_blocks_a)
        deallocate(a,b,c,seed)
    end do

    ! do n = 10,90,10
    !     call random_seed(size=k)
    !     allocate(seed(k))
    !     seed = n
    !     call random_seed(put=seed)
    !     allocate(a(n,n),b(n,n),c(n,n))
    !     call random_number(a)
    !     call random_number(b)
    !     c=0.0_dp
    !     call time_mflops(n,mm_ikj,mm_jki)
    !     deallocate(a,b,c,seed)
    ! end do

    ! do n = 100,Nmax,100
    !     call random_seed(size=k)
    !     allocate(seed(k))
    !     seed = n
    !     call random_seed(put=seed)
    !     allocate(a(n,n),b(n,n),c(n,n))
    !     call random_number(a)
    !     call random_number(b)
    !     call time_mflops(n,mm_ikj,mm_jki)
    !     deallocate(a,b,c,seed)
    ! end do


    CLOSE(10)
contains
subroutine time_mflops_block(matrix_n, mm_blocks)
    integer, intent(in) :: matrix_n
    procedure(mm_blocks_interface), optional :: mm_blocks
    real(dp) :: noOperations
    real(dp) :: elapsedTime
    ! multiplication, addition (assignment?)
    noOperations = 2*(matrix_n/10)**3 /1000._dp ! kiloFLOP/milisecond = megaFLOP/second
    ! Do the timing
    call tic()
    call mm_blocks( a, b, c, blocksize)
    call toc(elapsedTime)

    write(*,'(i0,2("  ",f12.4))') matrix_n, noOperations/elapsedTime
    write(10,'(i0,2("  ",f12.4))') matrix_n, noOperations/elapsedTime

end subroutine time_mflops_block

    subroutine time_mflops(matrix_n, slow, fast)
        integer, intent(in) :: matrix_n
        procedure(mm_interface), optional :: fast, slow
        real(dp) :: noOperations
        real(dp) :: elapsedTimeFast, elapsedTimeSlow
        ! multiplication, addition (assignment?)
        noOperations = 2*(matrix_n/10)**3 /1000._dp ! kiloFLOP/milisecond = megaFLOP/second
        ! Do the timing
        call tic()
        call fast( a, b, c )
        call toc(elapsedTimeFast)

        call tic()
        call slow( a, b, c )
        call toc(elapsedTimeSlow)

        write(10,'(i0,2("  ",f12.4))') matrix_n, noOperations/elapsedTimeSlow, noOperations/elapsedTimeFast
        !print "( A, i5, A, f12.4)", "Matrix size: ", matrix_n, ", MFLOP/s: ", noOperations/elapsedTimeFast       
        

    end subroutine time_mflops

end program mm_mflops
