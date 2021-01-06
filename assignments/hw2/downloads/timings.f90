module timings
    implicit none
    save
    private
    public tic,toc,startClock,stopClock
contains

    subroutine tic()
        ! tic() starts cpu timer. The subroutines records the processor time at execution of this command. Use toc()/ toc(elapsedTime) to print/get the elapsed time since the last call of tic().
        ! tic(startTime) returns the value of the processor time at execution of this command in startTime. Calling this command, shall not change the module variable associated with calling tic without argument.
    end subroutine tic

    subroutine toc()
	! toc() prints the elapsed cpu time in seconds since the most recent call of tic() (ie. tic called without output argument).
        ! toc(elapsedTime) returns the elapsed cpu time in seconds since the most recent call of tic() (ie. tic called without output argument) in the variable elapsedTime.
        ! if toc() or toc(elapsedTime) is called without first calling tic() a meaningless result may be returned.
        ! toc(startTime) prints the elapsed cpu time in seconds since the call of the tic command corresponding to startTime.
        ! toc(elapsedTime, startTime) returns the elapsed cpu time in seconds since the call of the tic command corresponding to startTime in the variable elapsedTime.
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
