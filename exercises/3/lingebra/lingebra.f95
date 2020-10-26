program Main
    use lingebra_module

    external :: slacpy, sgetrf, slaset, sgemm, slaswp, sgetri
    real(wp), dimension(10,10)  :: A, B
    real(wp), dimension(5,5)    :: L, U, C
    real(wp), ALLOCATABLE       :: workspace(:)
    integer, dimension(5)       :: ipiv
    integer                     :: info

    call random_number(A)
    !call printMatrix(A(:5,:5),"A before slascpy")
    call slacpy( '', 10, 10, A, 10, B, 10 )

    call sgetrf( 5, 5, A(1,1), 10, ipiv, info )
    print *, info
    !call printMatrix(A(:5,:5),"A after sgetrf")

    !call slaset('L', 5, 5, 0, 1, L, 5)
    !call slaset('U', 5, 5, 0, 1, U, 5)
    L=0.0
    U=0.0
    C=0.0

    call slacpy('L', 5, 5, A(1,1), 10, L(1,1), 5)
    call slacpy('U', 5, 5, A(1,1), 10, U(1,1), 5)

    call slaset('U', 5, 5, 0.0, 1.0, L(1,1), 5)
    call printMatrix(L, "L")
    call printMatrix(U, "U")

    call sgemm('n','n',5,5,5,1.0,L(1,1),5,U(1,1),5,0.0,C(1,1),5)
    call slaswp(5,C(1,1),5,1,5,ipiv,-1)

    call printMatrix(B(:5,:5), "B slice 5x5")
    call printMatrix(C, "C")
    call printMatrix(C-(B(:5,:5)), "Diference of C and B")
    print *, "Max diference is:", maxval( C-B(:5,:5) )

    allocate(workspace(1))
    call sgetri(5,A(1,1),10,ipiv,workspace(1),-1,info)
    print *, info
    info=nint(workspace(1))
    deallocate(workspace)
    allocate(workspace(info))
    call sgetri(5,A(1,1),10,ipiv,workspace,size(workspace),info)
    print *, info

    call sgemm('n','n',5,5,5,1.0,A(1,1),10,B(1,1),10,0.0,C(1,1),5)
    call printMatrix(C,"Should be identity matrix")

end program Main

