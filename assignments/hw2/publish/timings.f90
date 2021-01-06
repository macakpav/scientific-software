! Name:     timings (module)
! Purpose:  Defines subroutines tic(), toc() and startClock(), stopClock() used to time sections of code.
! Author:   pavel.macak@fs.cvut.cz (@student.kuleuven.be)
! Compilation:  Makefile is provided. As this is a module, it compiles when a program needs it.

module timings
    implicit none
    save
    private
    public tic, toc, startClock, stopClock
    integer, parameter :: sp = selected_real_kind(6,37), dp = selected_real_kind(15,307)
    integer, parameter :: wp = sp ! global setting defining working precission
    real(wp) :: cpuTimeTic=0._wp, wallClockTimeTic=0._wp ! global variables holding time
contains

    subroutine tic(startTime)
    ! tic() starts cpu timer. The subroutines records the processor time at execution of this command. Use toc()/ toc(elapsedTime) to print/get the elapsed time since the last call of tic().
        ! tic(startTime) returns the value of the processor time at execution of this command in startTime. Calling this command, shall not change the module variable associated with calling tic without argument.
        real(wp), optional, intent(out) :: startTime
        
        if ( present( startTime ) ) then
            call cpu_time( startTime )
        else
            call cpu_time( cpuTimeTic )
        end if
        end subroutine tic

    subroutine toc(elapsedTime, startTime)
    ! toc() prints the elapsed cpu time in seconds since the most recent call of tic() (ie. tic called without output argument).
        ! toc(elapsedTime) returns the elapsed cpu time in seconds since the most recent call of tic() (ie. tic called without output argument) in the variable elapsedTime.
        ! if toc() or toc(elapsedTime) is called without first calling tic() a meaningless result may be returned.
        ! toc(startTime) prints the elapsed cpu time in seconds since the call of the tic command corresponding to startTime.
        ! toc(elapsedTime, startTime) returns the elapsed cpu time in seconds since the call of the tic command corresponding to startTime in the variable elapsedTime.
        real(wp), optional, intent(in) :: startTime
        real(wp), optional, intent(out) :: elapsedTime
        real(wp) :: cpuTimeToc, timePassed
        call cpu_time(cpuTimeToc)

        if ( present(startTime) ) then
            timePassed = cpuTimeToc - startTime
        else
            timePassed = cpuTimeToc - cpuTimeTic
        end if

        if ( present(elapsedTime) ) then
            elapsedTime = timePassed
        else
            print '(a,es12.4)', "Elapsed CPU time: ", timePassed
        end if

    end subroutine toc

    subroutine startClock(startTime)
        ! startClock() starts wall clock timer. The subroutine records the value of a real-time clock at execution of this command. Use stopClock()/stopClock(elapsedTime) to print/get the elapsed time.
        ! startClock(startTime) stores the value of a real-time clock at execution of this command in startTime.
        real(wp), optional, intent(out) :: startTime
        integer :: count
        real(wp) :: count_rate
        call system_clock(count=count,count_rate=count_rate)
        if ( present( startTime ) ) then
            startTime=real(count,kind=wp)/count_rate
        else
            wallClockTimeTic=real(count,kind=wp)/count_rate
        end if
    end subroutine startClock
    
    subroutine stopClock(elapsedTime, startTime)
	    ! stopClock() prints the elapsed wall clock time in milliseconds since the most recent call of startClock() (ie. startClock call without output argument).
        ! stopClock(elapsedTime) returns the elapsed wall clock time in milliseconds since the most recent call of startClock() (ie. startClock call without output argument) in the variable elapsedTime.
        ! stopClock(startTime) prints the elapsed wall clock time in milliseconds since the call of the startClock command corresponding to startTime.
        ! stopClock(elapsedTime, startTime) returns the elapsed wall clock time in milliseconds since the call of the startClock command corresponding to startTime in the variable elapsedTime.
        real(wp), optional, intent(in) :: startTime
        real(wp), optional, intent(out) :: elapsedTime
        real(wp) :: wallClockTimeToc, timePassed, count_rate
        integer :: count
        call system_clock(count=count,count_rate=count_rate)
        ! print *, count_rate
        wallClockTimeToc=real(count,kind=wp)/count_rate

        if ( present(startTime) ) then
            timePassed = wallClockTimeToc - startTime
        else
            timePassed = wallClockTimeToc - wallClockTimeTic
        end if

        timePassed = timePassed*1000!scale(timePassed, exponent(timePassed)+3)

        if ( present(elapsedTime) ) then
            elapsedTime = timePassed
        else
            print '(a,f10.2)', "Elapsed system time: ", timePassed
        end if
    end subroutine stopClock
end
