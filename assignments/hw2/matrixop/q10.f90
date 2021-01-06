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
    real :: k
    character(32) :: cmd, cmd2
    integer, parameter :: Nslow=1500, Nfast=2000
    integer, dimension(:), allocatable :: seed
    real(kind=dp), allocatable :: a(:,:), b(:,:), c(:,:)

call GET_COMMAND_ARGUMENT(1,value=cmd)
call GET_COMMAND_ARGUMENT(2,value=cmd2)
read(cmd2,*) k
    select case (cmd)
    case("s")
        call timeblocks("Slow", Nslow, nint(k), mm_ikj, mm_blocks_b)
    case("f")
        call timeblocks("Fast", Nslow, nint(k), mm_jki, mm_blocks_a)
    case default
        call abort()
    end select

contains

subroutine timeblocks(which, n, blocksize, method, method_blocks)
    implicit none
    integer,intent(in) :: blocksize, n
    procedure(mm_interface), optional :: method
    procedure(mm_blocks_interface), optional :: method_blocks
    character(*), intent(in) :: which
    integer nseed
    nseed=n
    call random_seed(size=nseed)
    allocate(seed(nseed))
    seed = nseed
    call random_seed(put=seed)
    allocate(a(n,n),b(n,n),c(n,n))

    call random_number(a)
    call random_number(b)
    c=0.0_dp

    print *, which, ", blocksize ", blocksize
    call do_timing("no-block",method)
    call do_timing("block",method_blocks=method_blocks,blocksize=blocksize)
    deallocate(a,b,c,seed)

end subroutine timeblocks

subroutine do_timing(funcName, method, method_blocks, blocksize)
    character(len=*), intent(in) :: funcName
    procedure(mm_interface), optional :: method
    procedure(mm_blocks_interface), optional :: method_blocks
    integer,intent(in), optional :: blocksize
    real(dp) :: elapsedTime
    ! Do the timing
    call tic()
    if( present(method) ) then
        call method( a, b, c )
    else
        call method_blocks( a, b, c, blocksize)
    end if
    call toc(elapsedTime)
    print "(A18, A, F10.6, A)", funcName, ": CPU time", elapsedTime, " sec"       

end subroutine do_timing    

end program mm_mflops
