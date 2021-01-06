! Name:     SIQRDoptimize
! Purpose:  Simulate the SIQRD equations.
! Author:   pavel.macak@fs.cvut.cz (@student.kuleuven.be)
! Compilation: Makefile is provided - make optimize to run after compilation, make SIQRDoptimize to only compile
!              Tested with nagfor, ifort and gfortran(recommended).

program SIQRDoptimize
  use siqrd_settings
  use io_module
  use optimization_module
  use methods_module

  implicit none

  real(wp), allocatable, dimension(:,:) :: scratchMatrix
  integer :: status, iters
  real(wp) :: time, startingBeta
  Type(simulationParametersType) :: simulationParameters
  character(64) :: format = '(es7.1,", ",es10.4,", ",es8.2,", ",i0)'
  
  ! read input from file and command line
  call readParamsOptimization(simulationParameters, INPUT_FILE, status) 
  if (status/=0) then
    print '(a,i0,a,i0)', "Error reading inputs."
  end if

  ! allocation of scratch space
  if (status==0) then
    allocate(scratchMatrix(5,simulationParameters%noSteps), stat=status)
    if (status/=0) then
      print '(a,i0,a,i0)', "Could not allocate matrix: ", 5, "x",simulationParameters%noSteps
    end if
  end if


  if (status==0) then
    startingBeta = simulationParameters%beta

    ! using Euler's forward method
    simulationParameters%beta =  startingBeta
    call optimizeSIQRD( simulationParameters%beta, simulationParameters%dBeta, eulerForward, simulationParameters,&
      maxInfected, simulationParameters%targetValue, status, time=time, iterations=iters, scratchMatrix=scratchMatrix)
    write(stdout, format) simulationParameters%dBeta, simulationParameters%beta, time, iters

    ! using Heun's method
    simulationParameters%beta =  startingBeta
    call optimizeSIQRD( simulationParameters%beta, simulationParameters%dBeta, heunMethod, simulationParameters,&
      maxInfected, simulationParameters%targetValue, status, time=time, iterations=iters, scratchMatrix=scratchMatrix)
    write(stdout, format) simulationParameters%dBeta, simulationParameters%beta, time, iters

    ! using Euler's backward method
    simulationParameters%beta =  startingBeta
    call optimizeSIQRD( simulationParameters%beta, simulationParameters%dBeta, eulerBackward, simulationParameters,&
      maxInfected, simulationParameters%targetValue, status, time=time, iterations=iters, scratchMatrix=scratchMatrix)
    write(stdout, format) simulationParameters%dBeta, simulationParameters%beta, time, iters

  end if
  
  if(allocated(scratchMatrix)) deallocate(scratchMatrix)
end program SIQRDoptimize

