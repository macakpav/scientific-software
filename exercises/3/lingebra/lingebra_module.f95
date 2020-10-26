module lingebra_module
    implicit none

    public

    integer, parameter :: sp = selected_real_kind(6) ! double and single precission types
    integer, parameter :: wp = sp ! set working precission of real numbers

    
contains
character(64) function arrayFormat( arr )
  real(wp), intent(in) :: arr(:)
  write(arrayFormat,*) '(',size(arr)-1, '(es11.4,"   "),es11.4)'
end function arrayFormat

subroutine printArray(arr, name)
  implicit none
  real(wp), dimension(:), intent(in) :: arr
  character(*), optional, intent(in) :: name
  print *, name
  print arrayFormat(arr), arr
end subroutine printArray

character(64) function matrixFormat( mat )
  real(wp), intent(in) :: mat(:,:)
  write(matrixFormat,*) '(',size(mat,2)-1, '(es11.4,"  "),es11.4)'
end function matrixFormat

subroutine printMatrix(mat, name)
  implicit none
  real(wp), dimension(:,:), intent(in) :: mat
  character(*), optional, intent(in) :: name
  print *, name
  print matrixFormat(transpose(mat)), transpose(mat)
end subroutine printMatrix

end module lingebra_module
