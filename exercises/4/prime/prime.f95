! This program searches for the n'th prime... but not in the most efficient
! way...
!

! #optimizations
! #-Os least memory usage
! #--Og debug informations for vlagrind etc.
! #--Ofast like O3 on steroids but can change functionality

program prime
implicit none

integer  :: n, i, j
integer, dimension(500000) :: primelist
logical  :: is_prime

n = size(primelist)

primelist(1) = 2
primelist(2) = 3
do i = 3,n
  primelist(i) = primelist(i-1)
  do
    primelist(i) = primelist(i) + 2
    is_prime = .true.
    do j=2,i-1
      if ((primelist(j)*primelist(j)>primelist(i))) exit
      if (mod(primelist(i), primelist(j)) == 0) then
        is_prime = .false.
        exit
      end if
    end do
    if (is_prime) then
      exit
    endif
  end do
end do


write(unit=*, fmt="(A, I0, A, I0)") &
  "FINAL RESULT: Prime ", n, ": ", primelist(n)


end program prime
