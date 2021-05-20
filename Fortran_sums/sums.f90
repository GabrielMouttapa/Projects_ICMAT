program sums
    implicit none

    real :: s, term
    integer(8) :: n, nmax
    integer :: ty, eps
    
    s = 0.0
    n = 1
    print *, "Tap 1 for 1st sum (1+1/n)^n and 2 for the 2nd sin n / n"
    read *, ty

    print *, "Enter the nb maximum of iterations"
    read *, nmax

    print *, "Enter the precision in power"
    read *, eps
    term = 2.0*10.0**eps

    do while (n <= nmax .and. abs(term) >= 10.0**eps)
        if (ty == 1) then
            term = (1.0 + 1.0/n)**n
        else
            term = sin(real(n))/n
        end if
        s = s + term
        n = n + 1        
    end do

    if (n == nmax+1) then
        print *, "The sum dosen't converge"
        print *, "Sum for n=1 to ", n
        print *, s
    else
        print *, "The sum converges"
        print *, "Iterations :", n
        print *, "Sum = ", s
    end if


end program sums
