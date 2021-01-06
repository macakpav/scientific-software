program blas_divide_and_conquer
    integer, parameter :: dp = selected_real_kind(15,307), N = 2000
    integer, dimension(:), allocatable :: seed
    real(kind=dp), dimension(N,N) :: a, b, c

    ! Make sure we use the same pseudo-random numbers each run by initializing
    ! the seed to a certain value.
    call random_seed(size=k)
    allocate(seed(k))
    seed = N
    call random_seed(put=seed)

    call random_number(A)
    call random_number(B)

    call divide_and_conquer(A,B,C)    
    
    deallocate(seed)

contains

subroutine divide_and_conquer(A,B,C)
    ! One step of divide and conquer, uses a blas routine to multiply 
    ! the submatrices. Assumes that the matrix size N divisible by 2.

    ! Do not modify these lines
    real(kind=dp), dimension(:,:), intent(in) :: A, B
    real(kind=dp), dimension(:,:), intent(out):: C
    character,parameter :: transpA = 'N', transpB = 'N'
    integer :: m
    m = size(A,1)

    ! Modify these lines: choose the appropriate blas routine, and values for M,N,K,alpha,Axx,
    ! LDA,Bxx,LDB,beta,Cxx and LDC.
    call xxxMM(transpA,transpB,!M,N,K,alpha,A11,LDA,B11,LDB,beta,C11,LDC) ! C11 = A11*B11
    call xxxMM(transpA,transpB,!M,N,K,alpha,A12,LDA,B21,LDB,beta,C11,LDC) ! C11 = C11 + A12*B21
    call xxxMM(transpA,transpB,!M,N,K,alpha,A11,LDA,B12,LDB,beta,C12,LDC) ! C12 = A11*B12
    call xxxMM(transpA,transpB,!M,N,K,alpha,A12,LDA,B22,LDB,beta,C12,LDC) ! C12 = C12 + A12*B22
    call xxxMM(transpA,transpB,!M,N,K,alpha,A21,LDA,B11,LDB,beta,C21,LDC) ! C21 = A21*B11
    call xxxMM(transpA,transpB,!M,N,K,alpha,A22,LDA,B21,LDB,beta,C21,LDC) ! C21 = C21 + A22*B21
    call xxxMM(transpA,transpB,!M,N,K,alpha,A21,LDA,B12,LDB,beta,C22,LDC) ! C22 = A21*B12
    call xxxMM(transpA,transpB,!M,N,K,alpha,A22,LDA,B22,LDB,beta,C22,LDC) ! C22 = C22 + A22*B22
end subroutine divide_and_conquer    
end program blas_divide_and_conquer
