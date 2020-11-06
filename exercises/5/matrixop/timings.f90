module timings
    implicit none
    save
    private
    public tic,toc,startClock,stopClock,wp,ticInternalTime
    integer, parameter :: sp = selected_real_kind(6,37), dp = selected_real_kind(15,307)
    integer, parameter :: wp = dp 
    real(wp) :: ticInternalTime
contains

    subroutine tic(startTime)
    ! tic() starts cpu timer. The subroutines records the processor time at execution of this command. Use toc()/ toc(elapsedTime) to print/get the elapsed time since the last call of tic().
        ! tic(startTime) returns the value of the processor time at execution of this command in startTime. Calling this command, shall not change the module variable associated with calling tic without argument.
        real(wp), optional, intent(out) :: startTime
        
        if ( present( startTime ) ) then
            call cpu_time( startTime )
        else
            call cpu_time( ticInternalTime )
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
        real(wp) :: tocInternalTime, timePassed
        call cpu_time(tocInternalTime)

        if ( present(startTime) ) then
            timePassed = tocInternalTime - startTime
        else
            timePassed = tocInternalTime - ticInternalTime
        end if

        if ( present(elapsedTime) ) then
            elapsedTime = timePassed
        else
            print '(a,es12.4)', "Elapsed time: ", timePassed
        end if

    end subroutine toc

    subroutine startClock()
        ! startClock() starts wall clock timer. The subroutine records the value of a real-time clock at execution of this command. Use stopClock()/stopClock(elapsedTime) to print/get the elapsed time.
        ! startClock(startTime) stores the value of a real-time clock at execution of this command in startTime.
    end subroutine startClock
    
    subroutine stopClock()
	    ! stopClock() prints the elapsed wall clock time in milliseconds since the most recent call of startClock() (ie. startClock call without output argument).
        ! stopClock(elapsedTime) returns the elapsed wall clock time in milliseconds since the most recent call of startClock() (ie. startClock call without output argument) in the variable elapsedTime.
        ! stopClock(startTime) prints the elapsed wall clock time in milliseconds since the call of the startClock command corresponding to startTime.
        ! stopClock(elapsedTime, startTime) returns the elapsed wall clock time in milliseconds since the call of the startClock command corresponding to startTime in the variable elapsedTime.
    end subroutine stopClock
end
