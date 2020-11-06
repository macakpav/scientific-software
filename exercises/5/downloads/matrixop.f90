!   Several implementations to compute the matrix-matrix product of 
!	two square (NxN), double precision matrices A and B.
!   For the indices i, j and k we use the following notation:
!   	C(i,j) = sum_{k=1}^{N} A(i,k)*B(k,j) for i,j = 1,..,N

module matrixop
    implicit none
    save
    integer, parameter :: dp = selected_real_kind(15,307) ! Get at least double precision
    integer, parameter :: threshold = 32 ! Threshold for "divide and conquer" and "Strassen"
contains
    !--------------------------------------------------------------------------
    ! 1. Three nested loops
    !
    ! NOTE: use the following notation for the indices
    !    C(i,j) = sum_{k=1}^{N} A(i,k)*B(k,j)
    !       i = Row index of A and C
    !       j = Column index of B and C
    !       k = Column index of A and row index of B
    !--------------------------------------------------------------------------
    subroutine mm_ijk(A, B, C)
        real(kind=dp), dimension(:,:), intent(in)  :: A, B
        real(kind=dp), dimension(:,:), intent(out) :: C
        integer i,j,k
        C = 0.0_dp 
        do i = 1,size(A,1)
            do j = 1,size(A,1)
                do k = 1,size(A,1)
                    C(i,j) = C(i,j) + A(i,k)*B(k,j)
                enddo
            enddo     
        enddo
    end subroutine mm_ijk

    subroutine mm_ikj(A, B, C)
        real(kind=dp), dimension(:,:), intent(in)  :: A, B
        real(kind=dp), dimension(:,:), intent(out) :: C
        C = 0.0_dp ! TODO: complete this subroutine
    end subroutine mm_ikj

    subroutine mm_jik(A, B, C)
        real(kind=dp), dimension(:,:), intent(in)  :: A, B
        real(kind=dp), dimension(:,:), intent(out) :: C
        C = 0.0_dp ! TODO: complete this subroutine
        
    end subroutine mm_jik

    subroutine mm_jki(A, B, C)
        real(kind=dp), dimension(:,:), intent(in)  :: A, B
        real(kind=dp), dimension(:,:), intent(out) :: C
        C = 0.0_dp ! TODO: complete this subroutine
    end subroutine mm_jki
    

    subroutine mm_kij(A, B, C)
        real(kind=dp), dimension(:,:), intent(in)  :: A, B
        real(kind=dp), dimension(:,:), intent(out) :: C
        C = 0.0_dp ! TODO: complete this subroutine
    end subroutine mm_kij
    
    subroutine mm_kji(A, B, C)
        real(kind=dp), dimension(:,:), intent(in)  :: A, B
        real(kind=dp), dimension(:,:), intent(out) :: C
        C = 0.0_dp ! TODO: complete this subroutine
    end subroutine mm_kji
    !--------------------------------------------------------------------------
    ! 2. Two nested loops with vector operations
    !--------------------------------------------------------------------------
    subroutine mm_ikj_vect(A, B, C)
        real(kind=dp), dimension(:,:), intent(in)  :: A, B
        real(kind=dp), dimension(:,:), intent(out) :: C
        integer i,k
        C = 0.0_dp 
        do i=1,size(A,1)
            do k=1,size(A,1)
                C(i,:) = C(i,:) + A(i,k)*B(k,:)
            enddo
        enddo
    end subroutine mm_ikj_vect

    subroutine mm_jki_vect(A, B, C)
        real(kind=dp), dimension(:,:), intent(in)  :: A, B 
        real(kind=dp), dimension(:,:), intent(out) :: C
        C = 0.0_dp ! TODO: complete this subroutine
    end subroutine mm_jki_vect

    subroutine mm_kij_vect(A, B, C)
        real(kind=dp), dimension(:,:), intent(in)  :: A, B
        real(kind=dp), dimension(:,:), intent(out) :: C
        C = 0.0_dp ! TODO: complete this subroutine
    end subroutine mm_kij_vect

    subroutine mm_kji_vect(A, B, C)
        real(kind=dp), dimension(:,:), intent(in)  :: A, B
        real(kind=dp), dimension(:,:), intent(out) :: C
        C = 0.0_dp ! TODO: complete this subroutine
    end subroutine mm_kji_vect
    !--------------------------------------------------------------------------
    ! 3. Two nested loops with dot_product
    !--------------------------------------------------------------------------
    subroutine mm_ijk_dot_product(A, B, C)
        real(kind=dp), dimension(:,:), intent(in)  :: A, B
        real(kind=dp), dimension(:,:), intent(out) :: C
        C = 0.0_dp ! TODO: complete this subroutine
    end subroutine mm_ijk_dot_product

    subroutine mm_jik_dot_product(A, B, C)
        real(kind=dp), dimension(:,:), intent(in)  :: A, B
        real(kind=dp), dimension(:,:), intent(out) :: C
        C = 0.0_dp ! TODO: complete this subroutine
    end subroutine mm_jik_dot_product
    !--------------------------------------------------------------------------
    ! 4. Two nested loops with dot_product and explicit transpose of matrix A
    !--------------------------------------------------------------------------
    subroutine mm_transp_ijk_dot_product(A, B, C)
        real(kind=dp), dimension(:,:), intent(in)  :: A, B
        real(kind=dp), dimension(:,:), intent(out) :: C
        C = 0.0_dp ! TODO: complete this subroutine
    end subroutine mm_transp_ijk_dot_product

    subroutine mm_transp_jik_dot_product(A, B, C)
        real(kind=dp), dimension(:,:), intent(in)  :: A, B
        real(kind=dp), dimension(:,:), intent(out) :: C
        C = 0.0_dp ! TODO: complete this subroutine
    end subroutine mm_transp_jik_dot_product 
    !--------------------------------------------------------------------------
    ! 5. In blocks
    !--------------------------------------------------------------------------
    subroutine mm_blocks_a(A, B, C, blocksize)
        real(kind=dp), dimension(:,:), intent(in)  :: A, B
        real(kind=dp), dimension(:,:), intent(out) :: C
        integer, intent(in) :: blocksize
        C = 0.0_dp ! TODO: Complete this subroutine
    end subroutine mm_blocks_a
    subroutine mm_blocks_b(A, B, C, blocksize)
        real(kind=dp), dimension(:,:), intent(in)  :: A, B
        real(kind=dp), dimension(:,:), intent(out) :: C
        integer, intent(in) :: blocksize
        C = 0.0_dp ! TODO: Complete this subroutine
    end subroutine mm_blocks_b
    !--------------------------------------------------------------------------
    ! 6. Intrinsic matmul function
    !--------------------------------------------------------------------------
    subroutine mm_matmul(A, B, C)
        real(kind=dp), dimension(:,:), intent(in)  :: A, B
        real(kind=dp), dimension(:,:), intent(out) :: C
        C = matmul( A, B ) 
    end subroutine mm_matmul
    !--------------------------------------------------------------------------
    ! 7. Using BLAS
    !--------------------------------------------------------------------------
    subroutine mm_blas(A,B,C)
        real(kind=dp), dimension(:,:), intent(in)  :: A, B
        real(kind=dp), dimension(:,:), intent(out) :: C
        ! TODO: Complete this subroutine
    end subroutine mm_blas
    !--------------------------------------------------------------------------
    ! 8. Reference implementation to illustrate working principle of
    !    the divide and conquer method (for N = 2^k). Not optimized for 
    !    performance! Only for illustrative purposes. 
    !--------------------------------------------------------------------------
    recursive subroutine mm_divide_and_conquer(A, B, C)
        real(kind=dp), dimension(:,:), intent(in) :: A, B
        real(kind=dp), dimension(:,:), intent(out) :: C
        integer :: N,j,k
        real(kind=dp), dimension(size(A,1)/2,size(A,1)/2) :: M1,M2,M3,M4,M5,M6,M7,M8
        N = size(A,1)
        if (N > threshold) then
            call mm_divide_and_conquer(A(1:N/2,1:N/2),B(1:N/2,1:N/2),M1)
            call mm_divide_and_conquer(A(1:N/2,N/2+1:N),B(N/2+1:N,1:N/2),M2)
            call mm_divide_and_conquer(A(1:N/2,1:N/2),B(1:N/2,N/2+1:N),M3)
            call mm_divide_and_conquer(A(1:N/2,N/2+1:N),B(N/2+1:N,N/2+1:N),M4)
            call mm_divide_and_conquer(A(N/2+1:N,1:N/2),B(1:N/2,1:N/2),M5)
            call mm_divide_and_conquer(A(N/2+1:N,N/2+1:N),B(N/2+1:N,1:N/2),M6)
            call mm_divide_and_conquer(A(N/2+1:N,1:N/2),B(1:N/2,N/2+1:N),M7)
            call mm_divide_and_conquer(A(N/2+1:N,N/2+1:N),B(N/2+1:N,N/2+1:N),M8)
            C(1:N/2,1:N/2)     = M1 + M2
            C(1:N/2,N/2+1:N)   = M3 + M4
            C(N/2+1:N,1:N/2)   = M5 + M6
            C(N/2+1:N,N/2+1:N) = M7 + M8
        else 
            C = 0._dp 
            do j=1,N
                do k=1,N
                    C(:,j) = C(:,j) + A(:,k)*B(k,j)
                enddo
            enddo 
        endif
    end subroutine mm_divide_and_conquer
    !--------------------------------------------------------------------------
    ! 9. Reference implementation to illustrate working principle of 
    !    Strassen's algorithm (for N = 2^k). Not optimized for performance!
    !    Only for illustrative purposes.
    !--------------------------------------------------------------------------
    recursive subroutine mm_strassen(A, B, C)
        real(kind=dp), dimension(:,:), intent(in) :: A, B
        real(kind=dp), dimension(:,:), intent(out) :: C
        integer :: N,j,k
        real(kind=dp), dimension(size(A,1)/2,size(A,1)/2) :: M1,M2,M3,M4,M5,M6,M7
        N = size(A,1)
        if (N > threshold) then
            ! Compute M1
            call mm_strassen(A(1:N/2,1:N/2)+A(N/2+1:N,N/2+1:N), & 
                    B(1:N/2,1:N/2)+B(N/2+1:N,N/2+1:N),M1)
            ! Compute M2
            call mm_strassen(A(N/2+1:N,1:N/2)+A(N/2+1:N,N/2+1:N), &
                    B(1:N/2,1:N/2),M2)
            ! Compute M3
            call mm_strassen(A(1:N/2,1:N/2),B(1:N/2,N/2+1:N)- & 
                    B(N/2+1:N,N/2+1:N),M3)
            ! Compute M4
            call mm_strassen(A(N/2+1:N,N/2+1:N),&
                    B(N/2+1:N,1:N/2)-B(1:N/2,1:N/2),M4)
            ! Compute M5
            call mm_strassen(A(1:N/2,1:N/2)+A(1:N/2,N/2+1:N),& 
                    B(N/2+1:N,N/2+1:N),M5)
            ! Compute M6
            call mm_strassen(A(N/2+1:N,1:N/2)-A(1:N/2,1:N/2), & 
                    B(1:N/2,1:N/2)+B(1:N/2,N/2+1:N),M6)
            ! Compute M7
            call mm_strassen(A(1:N/2,N/2+1:N)-A(N/2+1:N,N/2+1:N), &
                 B(N/2+1:N,1:N/2)+B(N/2+1:N,N/2+1:N),M7)
            
            C(1:N/2,1:N/2) = M1 + M4 - M5 + M7
            C(1:N/2,N/2+1:N) = M3 + M5
            C(N/2+1:N,1:N/2) = M2 + M4 
            C(N/2+1:N,N/2+1:N) = M1 - M2 + M3 + M6
        else 
            C = 0._dp 
            do j=1,N
                do k=1,N
                    C(:,j) = C(:,j) + A(:,k)*B(k,j)
                enddo
            enddo 
        endif
    end subroutine mm_strassen
end module matrixop
