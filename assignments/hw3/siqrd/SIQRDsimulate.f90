! Name:     SIQRDsimulate
! Purpose:  Simulate the SIQRD equations.
! Author:   pavel.macak@fs.cvut.cz (@student.kuleuven.be)
! Compilation: Makefile is provided - make simulate to run after compilation, make SQIRDsimulate to only compile
!              Also nagfor requires use of f90_unix_proc module for the abort() subroutine to work (used if Newtons method fails)
!              Also ifort requires use of ifport module for the same reason.
!              Tested with nagfor, ifort and gfortran(recommended).

program SIQRDsimulate
  use siqrd_settings
  use io_module
  use simulation_module
  use methods_module

  implicit none

  real(wp), allocatable, dimension(:,:) :: scratchMatrix
  integer :: status 
  Type(simulationParametersType) :: simulationParameters

  call readParams(simulationParameters, INPUT_FILE, status) ! read input from file and command line
  if (status/=0) then
    write(stderr,'(a)') "Error reading inputs!"
  end if

  if (status==0) then
    allocate(scratchMatrix(5,simulationParameters%noSteps), stat=status)
    if (status/=0) then
      write(stderr, fmt='(a,i0,a,i0)') "Could not allocate scratch matrix: ", 5, "x",simulationParameters%noSteps
    end if
  end if
  
  if (status==0) then
    call simulateSIQRD(eulerForward, simulationParameters, scratchMatrix)
    call saveResults(scratchMatrix, "eulerForward", simulationParameters)
    
    call simulateSIQRD(heunMethod, simulationParameters, scratchMatrix)
    call saveResults(scratchMatrix, "heun", simulationParameters)

    call simulateSIQRD(eulerBackward, simulationParameters, scratchMatrix)
    call saveResults(scratchMatrix, "eulerBackward", simulationParameters)
  end if

  if(allocated(scratchMatrix)) deallocate(scratchMatrix)
end program SIQRDsimulate
