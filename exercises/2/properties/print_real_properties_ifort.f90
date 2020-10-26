program print_real_properties
    implicit none
    integer,parameter :: sp = selected_real_kind(6,37), dp = selected_real_kind(15,307), &
         qp = selected_real_kind(33,4931)
    print *, "KIND  digits  precision10  e_min  e_max  range10             epsilon"
    print '(I4,I8,I13,I7,I7,I9,ES20.12)', &
           kind(0._sp),digits(0._sp),precision(0._sp),minexponent(0._sp), maxexponent(0._sp),range(0._sp), &
           epsilon(0._sp)
    print '(I4,I8,I13,I7,I7,I9,ES20.12)', &
           kind(0._dp),digits(0._dp),precision(0._dp),minexponent(0._dp), maxexponent(0._dp),range(0._dp), &
           epsilon(0._dp)
    print '(I4,I8,I13,I7,I7,I9,ES20.12)', &
           kind(0._qp),digits(0._qp),precision(0._qp),minexponent(0._qp), maxexponent(0._qp),range(0._qp), &
           epsilon(0._qp)
end program
