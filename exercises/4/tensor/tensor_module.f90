module tensor_module
    implicit none
    public
    integer, parameter :: sp = selected_real_kind(6,37), dp = selected_real_kind(15,307)
    integer, parameter :: wp = sp  
    public compare
contains

subroutine compare(T, str)
implicit none
real(wp),intent(in),DIMENSION(:,:,:) :: T
character(*),intent(in) :: str
real(wp) :: sum_, exsum_
real(wp) :: timeCPU, timeWorld, timeCPU2
integer :: c, m
real(wp) :: r

call cpu_time(timeCPU)
call system_clock(c,r,m)
timeWorld=c/r
select case (str)
case ("builtinsum")
    sum_ = builtinsum(T)
case ("blocksum")
    sum_ = blocksum(T)
case ("smallest")
    sum_ = smallest(T)
case ("biggest")
    sum_ = biggest(T)
case ("kahan")
    sum_ = kahan(T)
case default
    print *, "Wrong function name!"
    return
end select
call cpu_time(timeCPU2)
timeCPU = timeCPU2-timeCPU
call system_clock(c,r,m)
timeWorld=c/r - timeWorld

print *, "Clock time:", timeCPU
print *, "CPU time:", timeWorld

exsum_ = exact(T)
print *, "Relative error is:", abs(exsum_-sum_)/exsum_

end subroutine compare

function builtinsum(ten) result(sum_)
    implicit none
    real(wp),DIMENSION(:,:,:) :: ten
    real(wp) :: sum_
    print *, "builtinsum"
    sum_=sum(ten)
end function builtinsum

function blocksum(ten) result(bsum_)
    implicit none
    real(wp),DIMENSION(:,:,:) :: ten
    real(wp) :: bsum_
    print *, "blocksum"
    bsum_=sum(sum(sum(ten,1),1),1)
end function blocksum

function smallest(ten) result(sum_)
    implicit none
    real(wp),DIMENSION(:,:,:) :: ten
    real(wp) :: sum_
    INTEGER :: i,j,k
    print *, "smallest"
    sum_ = 0
    do i = 1, size(ten,1)
        do j = 1, size(ten,2)
            do k = 1, size(ten,3)
                sum_ = sum_ +  ten(i,j,k)
            end do
        end do
    end do
end function smallest

function biggest(ten) result(sum_)
    implicit none
    real(wp),DIMENSION(:,:,:) :: ten
    real(wp) :: sum_
    INTEGER :: i,j,k
    print *, "biggest"
    sum_ = 0
    do i = size(ten,1),1,-1
        do j = size(ten,2),1,-1
            do k = size(ten,3),1,-1
                sum_ = sum_ +  ten(i,j,k)
            end do
        end do
    end do
end function biggest

function kahan(ten) result(total)
    implicit none
    real(wp),DIMENSION(:,:,:) :: ten
    real(wp) :: total, y, temp, c
    INTEGER :: i,j,k
    print *, "kahan"
    total = 0
    c = 0
    do i = 1, size(ten,1)
        do j = 1, size(ten,2)
            do k = 1, size(ten,3)
                y = ten(i,j,k)-c
                temp = total + y
                c = (temp - total) - y
                total = temp
            end do
        end do
    end do

end function kahan

function exact(T) result(sum_)
    implicit none
    real(wp), DIMENSION(:,:,:) :: T
    real(wp) :: N
    real(wp) :: sum_
    N = size(T,1)
    sum_ = N**3 * ((N**3 + 1) / 2)
end function exact



end module tensor_module
