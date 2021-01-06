! Name:     optimization_module
! Purpose:  Run optimization using Newtons iteration.
! Author:   pavel.macak@fs.cvut.cz (@student.kuleuven.be)

module optimization_module
  use siqrd_settings
  use io_module
  use simulation_module
  use timings
  implicit none
  private

  public optimizeSIQRD, maxInfected

contains

! return maximum number of infected individuals at any time
subroutine maxInfected(simulationResults, returnValue)
  implicit none
  real(wp), dimension(:,:),intent(in) :: simulationResults
  real(wp),intent(out) :: returnValue
  returnValue = maxval(simulationResults(2,:))
end subroutine maxInfected

! tweak the tweakedParameter so that the value returned by targetEvaluator matches targetValue
! uses simMethod to simulate SIQRD equations with simulationParameters
! uses parameterStep to approximate the derivative of targetEvaluator(tweakedParameter)
! info = 0 on safe return
! uses scratchMatrix to store results of SIQRD simulation, allocates this space otherwise
! optional return values:
!   time - cpu time that the Newton's method took to converge
!   iterations - how many iterations Newton's method needed to converge
!   residual - residual in last iteration
!   reachedValue - value from targetEvaluator in last iteration
subroutine optimizeSIQRD( tweakedParameter, parameterStep, simMethod,&
                simulationParameters, targetEvaluator, targetValue, info, time,&
                iterations, residual, reachedValue, scratchMatrix)
  real(wp), intent(in) :: parameterStep, targetValue
  real(wp), intent(inout) :: tweakedParameter ! has to be member of simulationParameters
  real(wp), dimension(:,:), target, optional, intent(out) :: scratchMatrix
  real(wp), intent(out), optional :: time, residual, reachedValue
  integer, intent(out), optional :: iterations
  type(simulationParametersType), intent(inout) :: simulationParameters
  integer, intent(out) :: info
  ! external simMethod, targetEvaluator
  interface ! definition of evaluator interface
    subroutine targetEvaluator(simulationResults, returnValue)
      use siqrd_settings
      implicit none
      real(wp), dimension(:,:),intent(in) :: simulationResults
      real(wp),intent(out) :: returnValue
    end subroutine targetEvaluator
  end interface
  interface ! definition of method interface
    subroutine simMethod(vars, parameters, status)
      use siqrd_settings
      use io_module
      real(wp), dimension(:,:), intent(inout) :: vars
      type(simulationParametersType), intent(in) :: parameters
      integer, intent(out) :: status
    end subroutine simMethod
  end interface

  real(wp), pointer :: variables(:,:)
  real(wp) :: valueForward, val, dF, res, tol, temp
  real(wp) :: stepLimit
  integer :: iter
  integer, parameter :: noIter = 1000

  ! possible allocation
  if (present(scratchMatrix)) then
    ! check dimensions of scratch space
    if (size(scratchMatrix,1) /= 5 .or. size(scratchMatrix,2) /= simulationParameters%noSteps) then
      write(stderr, fmt='(a,i0)') "Wrong size of scratch array. Has to be 5x",simulationParameters%noSteps
      info = -3
      return 
    end if
    variables => scratchMatrix
  else
    ! allocate space to hold variables
    write(stdout, fmt='(a)', advance="no") "No scratch array given to optimizeSIQRD, allocating now... "
    allocate( variables(5,simulationParameters%noSteps), stat=info)
    if (info/=0) then
      write(stderr, fmt='(a)') "Error allocating variables matrix inside optimizeSIQRD procedure!"
      return 
    end if 
    write(stdout, fmt='(a)') "allocated."
  end if 

  if(present(time)) then
    call tic()
  end if
  tol = 1e-6_wp*parameterStep
  tol = max(tol, 10._wp**(-precision(0._wp)+1))
  stepLimit = tweakedParameter!/2._wp ! 50% of the parameter, might reduce convergence speed but improve stability
  
  info = -10
  do iter = 1, noIter
    call simulateSIQRD(simMethod, simulationParameters, scratchArray=variables)
    call targetEvaluator(variables, val)
    
    res = abs(val - targetValue)/abs(targetValue) 
    if ( res < tol ) then
      info = 0
      exit
    end if
    
    temp=tweakedParameter
    tweakedParameter = tweakedParameter + parameterStep
    simulationParameters%beta = tweakedParameter !only needed for optimized nagfor compilation

    call simulateSIQRD(simMethod, simulationParameters, scratchArray=variables)
    call targetEvaluator(variables, valueForward)

    dF = ( valueForward - val ) / parameterStep ! aproximate derivative
    val = - 1/dF * (val-targetValue)

    val = min(max(-stepLimit, val),stepLimit) ! limit the step size the method does
    tweakedParameter = temp + val
    simulationParameters%beta = tweakedParameter !only needed for optimized nagfor compilation

  end do
  if (info == -10) print *, "Newtons method did not meet tolerance criteria!"

  ! set optional outputs
  if (present(time)) call toc(elapsedTime=time)
  if (present(iterations)) iterations = iter
  if (present(residual)) residual = res
  if (present(reachedValue)) reachedValue = val

  ! only deallocate if variables allocated during this procedure
  if (.not. present(scratchMatrix)) deallocate(variables)

  ! print *, "maxCount: ", val, "iterations: ", iter, "residual:", res, "beta:", tweakedParameter, "step:", parameterStep
end subroutine optimizeSIQRD


end module optimization_module

