module matrix_module

    implicit none
    save
    private
    public MatrixStats

contains
    subroutine MatrixStats( a )
        real, intent(in) :: a(:,:)
        real :: sum_rows(size(a,1)), sum_cols(size(a,2))
        character(64) :: form
        integer :: rows, cols
        sum_rows = sum(a,2)
        sum_cols = sum(a,1)
        rows=size(sum_rows)
        cols=size(sum_cols)
        
        
        print '(a,i2,a,i2,a,i3,a)', 'Number of rows: ', rows, ', number of columns: ', cols, &
        ', number of elements: ', size(a), '.'
        print '(a,es11.4,a,es11.4,a)', 'Smallest value: ', minval(a), ', largest value: ', maxval(a), '.'
        print '(a,i2,a,i2,a,i2,a,i2,a)', 'Range row indicies: ' , lbound(a,1), '-', ubound(a,1), &
        ', range column indices: ', lbound(a,2), '-', ubound(a,2), '.'

        form = ArrayFormat(sum_rows)
            print form, 'Sum rows: ', sum_rows(:rows-1), sum_rows(rows)

        form = ArrayFormat(sum_cols)
            print form, 'Sum columns: ', sum_cols(:cols-1), sum_cols(cols)

    end subroutine MatrixStats

    character(64) function ArrayFormat( arr )
        real, intent(in) :: arr(:)
        write(ArrayFormat,*) '(a,', size(arr)-1, '(e12.5,", "),e12.5)'
    end function ArrayFormat

end module matrix_module
