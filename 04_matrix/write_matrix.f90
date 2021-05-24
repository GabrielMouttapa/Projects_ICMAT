program function_example
    implicit none

    integer :: i, j, n, m, ok
    character(200) :: target_file
    real(8), allocatable, dimension(:, :) :: matrix
    
    namelist /change_matrix/ n, m, target_file
    open(unit=100,file='/LUSTRE/users/gmouttapa/gfd_course/Projects_ICMAT/Fortran_matrix/change_matrix.list', action='READ')
    read(100, NML=change_matrix)
    close(100)

    allocate(matrix(1:n, 1:m))
    do i=1,n
        do j=1,m
            matrix(i, j) = i+j
        end do
    end do

    ok = save_matrix(target_file)

    contains

        integer function save_matrix(file_name)
            implicit none
            integer i
            !real(8), dimension(:, :), intent(in) :: matrix !intent(in) is use to tell fortran than the size will be tell by the variables
            character(*), intent(in) :: file_name !usually we put the maximum lenght of the string in the *
            open(10, file=file_name) ! 10 is an id, it's only numbers
            do i=1, size(matrix, 2)
                write(10, *) matrix(:, i)
            end do
            close(10)
            save_matrix = 0
        end function

end program
