program print_real_properties
    implicit none
    integer,parameter :: sp = selected_real_kind(6,37), dp = selected_real_kind(15,307), &
         ep = selected_real_kind(18,291)
    print *, "KIND  digits  precision10  e_min  e_max  range10             epsilon"
    print '(I4,I8,I13,I7,I7,I9,ES20.12)', &
           kind(0._sp),digits(0._sp),precision(0._sp),minexponent(0._sp), maxexponent(0._sp),range(0._sp), &
           epsilon(0._sp)
    print '(I4,I8,I13,I7,I7,I9,ES20.12)', &
           kind(0._dp),digits(0._dp),precision(0._dp),minexponent(0._dp), maxexponent(0._dp),range(0._dp), &
           epsilon(0._dp)
   print '(I4,I8,I13,I7,I7,I9,ES20.12)', &
           kind(0._ep),digits(0._ep),precision(0._ep),minexponent(0._ep), maxexponent(0._ep),range(0._ep), &
           epsilon(0._ep)
end program
