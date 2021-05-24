program sums
    implicit none

    real(8) :: s, term, pi
    integer(8) :: n, nmax
    integer :: ty, eps
    
    pi = 3.1415926535897932384626433832795028841971693993751058209749445923
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
            term = 2* sin(real(n))/n     !2* for the terms in n and -n
        end if
        s = s + term
        n = n + 1        
    end do

    if (n == nmax+1) then
        print *, "The sum dosen't converge, or not enough iterations for the precision"
        print *, "Sum for n=1 to ", n
        if (ty == 1) then
            print *, s
        else
            print *, "Sum = ", s+1.0    ! +1 to count the term for n=0
            print *, "Pi = ", pi
        end if
    else
        print *, "The sum converges"
        print *, "Iterations :", n
        if (ty == 1) then
            print *, s
        else
            print *, "Sum = ", s+1.0 ! +1 to count the term for n=0
            print *, "Pi =  ", pi
        end if
    end if


end program sums
