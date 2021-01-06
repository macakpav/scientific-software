! Name:     blas_divide_and_conquer
! Purpose:  Implements divide and conquer algorithm BLAS library.
! Completed by:   pavel.macak@fs.cvut.cz (@student.kuleuven.be)
! Compilation:  Makefile is provided. 
!               To compile this program use 'make blas_divide_and_conquer' 
!               or 'make conquer' to also run after compilation.

program blas_divide_and_conquer
    integer, parameter :: dp = selected_real_kind(15,307), N = 2000
    integer, dimension(:), allocatable :: seed
    real(kind=dp), dimension(N,N) :: A, B, C
    ! real(kind=dp), dimension(N,N) :: C_matmul
    external dgemm
    ! interface
    !     subroutine dgemm(transa, transb, m, n, k, alpha, a, lda, b, ldb, beta, c, ldc)
    !         DOUBLE PRECISION ALPHA,BETA
    !         INTEGER K,LDA,LDB,LDC,M,N
    !         CHARACTER TRANSA,TRANSB
    !         DOUBLE PRECISION A(LDA,*),B(LDB,*),C(LDC,*)
    !     end subroutine dgemm
    ! end interface

    ! Make sure we use the same pseudo-random numbers each run by initializing
    ! the seed to a certain value.
    call random_seed(size=k)
    allocate(seed(k))
    seed = N
    call random_seed(put=seed)

    call random_number(A)
    call random_number(B)

    ! C_matmul =  matmul(A,B)

    call divide_and_conquer(A,B,C)

    ! print *, "Difference: ", sum(abs(C-C_matmul))/sum(abs(C_matmul))

    deallocate(seed)

contains

subroutine divide_and_conquer(A,B,C)
    ! One step of divide and conquer, uses a blas routine to multiply 
    ! the submatrices. Assumes that the matrix size N divisible by 2.

    ! Do not modify these lines
    real(kind=dp), dimension(:,:), intent(in) :: A, B
    real(kind=dp), dimension(:,:), intent(out):: C
    character,parameter :: transpA = 'N', transpB = 'N'
    integer :: m,bs
    m = size(A,1)
    bs = m/2

    ! Modify these lines: choose the appropriate blas routine, and values for M,N,K,alpha,Axx,
    ! LDA,Bxx,LDB,beta,Cxx and LDC.
    !   dgemm (TRANSA, TRANSB, M, N, K, ALPHA, A, LDA, B, LDB, BETA, C, LDC)
    ! print *, "Sum of C: ",  sum(C)
    call dgemm(transpA,transpB,bs,bs,bs,1._dp,A(1,1),m,      B(1,1),m,      0._dp,C(1,1),m) ! C11 = A11*B11
    ! print*, sum(C(1:bs,1:bs))
    ! print*, sum(matmul(A(:bs,:bs),B(:bs,:bs)))
    call dgemm(transpA,transpB,bs,bs,bs,1._dp,A(1,bs+1),m,   B(bs+1,1),m,   1._dp,C(1,1),m) ! C11 = C11 + A12*B21
    ! print*, sum(C(1:bs,1:bs))
    ! print*, sum(matmul(A(:bs,:bs),B(:bs,:bs))+matmul(A(:bs,bs+1:),B(bs+1:,:bs)))
    call dgemm(transpA,transpB,bs,bs,bs,1._dp,A(1,1),m,      B(1,bs+1),m,   0._dp,C(1,bs+1),m) ! C12 = A11*B12
    ! print*, sum(C(:bs,bs+1:))
    ! print*, sum(matmul(A(:bs,:bs),B(:bs,bs+1:)))
    call dgemm(transpA,transpB,bs,bs,bs,1._dp,A(1,bs+1),m,   B(bs+1,bs+1),m,1._dp,C(1,bs+1),m) ! C12 = C12 + A12*B22
    call dgemm(transpA,transpB,bs,bs,bs,1._dp,A(bs+1,1),m,   B(1,1),m,      0._dp,C(bs+1,1),m) ! C21 = A21*B11
    call dgemm(transpA,transpB,bs,bs,bs,1._dp,A(bs+1,bs+1),m,B(bs+1,1),m,   1._dp,C(bs+1,1),m) ! C21 = C21 + A22*B21
    call dgemm(transpA,transpB,bs,bs,bs,1._dp,A(bs+1,1),m,   B(1,bs+1),m,   0._dp,C(bs+1,bs+1),m) ! C22 = A21*B12
    ! print*, sum(C(bs+1:,bs+1:))
    ! print*, sum(matmul(A(bs+1:,:bs),B(:bs,bs+1:)))
    call dgemm(transpA,transpB,bs,bs,bs,1._dp,A(bs+1,bs+1),m,B(bs+1,bs+1),m,1._dp,C(bs+1,bs+1),m) ! C22 = C22 + A22*B22

end subroutine divide_and_conquer    
end program blas_divide_and_conquer
