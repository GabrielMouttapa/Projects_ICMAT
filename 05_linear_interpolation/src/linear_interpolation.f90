program linear_interpolation
    implicit none

    real(8), dimension(:), allocatable :: x_values, x_inter, y_values, y_inter, y_real
    real(8) :: xmin, xmax, step_values, step_inter
    integer :: nb_pt_values, nb_pt_inter
    character(3) :: ty

    print *, "Type cos, sin, log, exp, sqr or tan"
    read *, ty
    print *, "xmin"
    read *, xmin
    print *, "xmax"
    read *, xmax
    print *, "step_values"
    read *, step_values
    print *, "step_interpolation"
    read *, step_inter

    nb_pt_values = floor((xmax-xmin)/step_values)+1
    nb_pt_inter = floor((xmax-xmin)/step_inter)+1
    allocate(x_values(nb_pt_values))
    allocate(x_inter(nb_pt_inter)) 
    allocate(y_values(nb_pt_values))
    allocate(y_inter(nb_pt_inter))
    allocate(y_real(nb_pt_inter))
    x_values = step_array(xmin, xmax, step_values)
    x_inter = step_array(xmin, xmax, step_inter)
    if (ty == "cos") then
        y_values = cos(x_values)
        y_real = cos(x_inter)
    else if (ty == "sin") then
        y_values = sin(x_values)
        y_real = sin(x_inter)
    else if (ty == "tan") then
        y_values = tan(x_values)
        y_real = tan(x_inter)
    else if (ty == "exp") then
        y_values = exp(x_values)
        y_real = exp(x_inter)
    else if (ty == "log") then
        y_values = log(x_values)
        y_real = log(x_inter)
    else if (ty == "sqr") then
        y_values = sqrt(x_values)
        y_real = sqrt(x_inter)
    end if

    call linterp1D(x_values, y_values, x_inter, y_inter)

    print *, "Norm interp-real", norm(y_inter, y_real)
    !if (nb_pt_inter <= 15) then
        print *, "Interpolation", y_inter
        print *, "Real", y_real
    !end if
    




    contains

        function step_array(a, b, s)
            implicit none

            real(8) :: a, b, s
            real(8), dimension(:), allocatable :: step_array
            integer :: i, imax

            imax = floor((b-a)/s)+1
            allocate(step_array(imax))

            do i=1, imax, 1
                step_array(i) = a + s*i
            end do

            return
        end function

        function norm(u, v)
            implicit none

            real(8), dimension(:), allocatable :: u, v
            integer :: i
            real(8) :: s, norm

            s = 0.0

            do i=1, size(u), 1
                s = s + (u(i) - v(i))**2
            end do

            norm = sqrt(s)
            return

        end function

        function locate(xx, x)
            implicit none
            real(8), dimension(:), intent(in) :: xx
            real(8), intent(in) :: x
            integer :: locate,  n, jl, jm, ju
            logical :: ascnd

            n = size(xx)
            ascnd = (xx(n) >=  xx(1))
            jl = 0
            ju = n+1
            
            do
                if (ju - jl <= 1) exit
                jm=(ju+jl)/2

                if (ascnd .eqv. (x >= xx(jm))) then
                    jl=jm
                else
                    ju=jm
                end if
            end do

            if (x == xx(1)) then
                locate=1
            else if (x == xx(n)) then
                locate=n-1
            else
                locate=jl
            end if

        end function locate    
            
        subroutine linterp1D(x_values, y_values, x_inter, y_inter)
            implicit none

            real(8), dimension(:), intent(in) :: x_values, y_values, x_inter
            real(8), dimension(:), intent(out) :: y_inter
            integer :: i, j
            real(8) :: x

            do i=1, size(x_inter), 1
                x = x_inter(i)

                ! searshing of the good place of j
                j = locate(x_values, x) + 1
                y_inter(i) = y_values(j) + (y_values(j+1) - y_values(j))&
                    * (x_inter(i) - x_values(j)) / (x_values(j+1) - x_values(j))

            end do   

                    
        end subroutine

end program
