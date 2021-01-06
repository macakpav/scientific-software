! Name:     SIQRDstability
! Purpose:  Compute and print to screen the eigenvalues of Jacobian for given simulation parameters.
! Author:   pavel.macak@fs.cvut.cz (@student.kuleuven.be)
! Compilation: Makefile is provided - make stabilize to run after compilation, make SIQRDstabilize to only compile
!              Tested with nagfor, ifort and gfortran(recommended).

program SIQRDstability
  use siqrd_settings
  use io_module
  use methods_module

  implicit none
  !integer, parameter :: dp = selected_real_kind(15) ! implemented only for double precision
  integer, parameter :: n=5, lda=n, ldvl=1, ldvr=1, lwmax=10000
  real(dp) :: equlibriumPoint(5), jacobianMatrix(5,5), eigenValues(n), wi(n), temp(1), v(1)
  real(dp), allocatable :: work(:)
  integer :: info, lwork
  Type(simulationParametersType) :: simulationParameters

  interface ! LAPACK routine to compute eigenvalues
    subroutine dgeev (JOBVL, JOBVR, N, A, LDA, WR, WI, VL, LDVL, VR, LDVR, WORK, LWORK, INFO)
      CHARACTER          JOBVL, JOBVR
      INTEGER            INFO, LDA, LDVL, LDVR, LWORK, N
      DOUBLE PRECISION   A( LDA, * ), VL( LDVL, * ), VR( LDVR, * ), WI( * ), WORK( * ), WR( * )
    end subroutine dgeev
  end interface

  ! read input
  call readParamsStability(simulationParameters, INPUT_FILE, info) 
  if (info/=0) then
    write(stderr,'(a,i0,a,i0)') "Error reading inputs."
  end if

  if (info==0) then
    do info = 0, 0 ! exit can be used to "terminate" the program instead of the compiler dependent call abort()
      equlibriumPoint = [1,0,0,0,0]
      jacobianMatrix = jacobianSIQRD(equlibriumPoint, simulationParameters)

      ! get optimal size for work array
      lwork = -1
      call dgeev('N','N', n, jacobianMatrix, lda, eigenValues, wi, v, ldvl, v, ldvr, temp, lwork, info)
      if (info/=0) then
        write(stderr,'(a,i0,a)') "Error getting the optimal size for dgeev, (", info,")."
        exit
      end if

      ! allocate work array
      lwork = min(lwmax,ceiling(temp(1)))
      allocate(work(lwork))

      ! actually run dgeev
      call dgeev('N','N', n, jacobianMatrix, lda, eigenValues, wi, v, ldvl, v, ldvr, work, lwork, info)
      if (info/=0) then
        write(stderr,'(a,i0,a)') "Error in dgeev, (", info,")."
        exit
      end if

      ! print results to screen
      call printArray(eigenValues)

      ! deallocate work array
      if (allocated(work)) then
        deallocate(work)
      end if
    end do
  end if
  
end program SIQRDstability

