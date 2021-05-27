program read_nc_ibi
    use netcdf
    implicit none




    !!!!   VARIABLE DECLARATION   !!!!

    ! names
    character(len=100), parameter :: input_data = "cmems_ibi_example.nc", output_data = "cmems_symplify.nc"
    character(len=25) :: name

    ! id
    integer :: ncid, id, long_dimid, lat_dimid, time_dimid, lat_id, &
        long_id,time_id,  u_id, v_id
    
    ! dimensions
    integer :: dimlat, dimlong, dimdep, dimtime
    
    ! variables
    real, dimension(:), allocatable :: latitude, longitude
    real, dimension(:), allocatable :: time
    integer(2), dimension(:, :, :, :), allocatable :: vo_int, uo_int

    ! attributes
    real(8) :: vo_scale, uo_scale

    ! calculated variables
    real, dimension(:, :, :, :), allocatable :: vo, uo
    real, dimension(:, :, :), allocatable :: vect




    !!!!   READINF NETCDF   !!!!

    ! open netcdf
    call check(nf90_open(input_data, nf90_nowrite, ncid), "open nc")

    ! read dimensions
    call check(nf90_inq_dimid(ncid, "latitude", id), &
        "inquire lat dimension id")
    call check(nf90_inquire_dimension(ncid, id, name, dimlat), &
        "inquire latitude dimension")
    allocate(latitude(dimlat))
    call check(nf90_inq_dimid(ncid, "longitude", id), &
        "inquire long dimension id")
    call check(nf90_inquire_dimension(ncid, id, name, dimlong), &
        "inquire longitude dimension")
    allocate(longitude(dimlong))
    call check(nf90_inq_dimid(ncid, "time", id), &
        "inquire time dimension id")
    call check(nf90_inquire_dimension(ncid, id, name, dimtime), &
        "inquire time dimension")
    allocate(time(dimtime))
    call check(nf90_inq_dimid(ncid, "depth", id), &
        "inquire ldepth dimension id")
    call check(nf90_inquire_dimension(ncid, id, name, dimdep), &
        "inquire depth dimension")
    allocate(vo_int(dimlong, dimlat, dimdep, dimtime))
    allocate(uo_int(dimlong, dimlat, dimdep, dimtime))

    ! read variables
    call check(nf90_inq_varid(ncid, "latitude", id), &
        "getting lat id")
    call check(nf90_get_var(ncid, id, latitude), &
        "get var lat")
    call check(nf90_inq_varid(ncid, "longitude", id), &
        "getting long id")
    call check(nf90_get_var(ncid, id, longitude), &
        "get var long")
    call check(nf90_inq_varid(ncid, "time", id), &
        "getting time id")
    call check(nf90_get_var(ncid, id, time), &
        "get var time")
    call check(nf90_inq_varid(ncid, "vo", id), &
        "getting vo id")
    call check(nf90_get_var(ncid, id, vo_int), &
        "get var vo")
    call check(nf90_get_att(ncid, id, "scale_factor", vo_scale), &
        "get vo scale factor")
    call check(nf90_inq_varid(ncid, "uo", id), &
        "getting uo id")
    call check(nf90_get_var(ncid, id, uo_int), &
        "get var uo")
    call check(nf90_get_att(ncid, id, "scale_factor", uo_scale), &
        "get uo scale factor")

    ! close netcdf
    call check(nf90_close(ncid), "closing nc")




    !!!!   CALCULS   !!!!

    ! scale update
    allocate(vo(dimlong, dimlat, dimdep, dimtime))
    allocate(uo(dimlong, dimlat, dimdep, dimtime))
    vo = vo_int * vo_scale
    uo = uo_int * uo_scale

    ! removing depth
    allocate(vect(dimlong, dimlat, dimtime))
    vect = uo(:, :, 1, :)




    !!!!   CREATING NEW NETCDF   !!!

    ! create new netcdf
    call check(nf90_create(output_data, nf90_clobber, ncid), &
        "create new netcdf")

    ! new dimensions
    call check(nf90_def_dim(ncid, "longitude", dimlong, long_dimid), &
        "lat dim definition")
    call check(nf90_def_dim(ncid, "latitude", dimlat, lat_dimid), &
        "long dim def")
    call check(nf90_def_dim(ncid, "time", dimtime, time_dimid), &
        "tim dim def")

    ! definition of variables
    call check(nf90_def_var(ncid, "longitude", nf90_float, (/long_dimid/), long_id), &
        "long def")
    call check(nf90_def_var(ncid, "latitude", nf90_float, (/lat_dimid/), lat_id), &
        "lat def")
    call check(nf90_def_var(ncid, "time", nf90_float, (/time_dimid/), time_id), &
        "time def")
    call check(nf90_def_var(ncid, "u", nf90_float, (/long_dimid, lat_dimid, &
        time_dimid/), u_id), "u def")
    call check(nf90_def_var(ncid, "v", nf90_float, (/long_dimid, lat_dimid, &
        time_dimid/), v_id), "v def")

    ! putting attributes
    call check(nf90_put_att(ncid, long_id, "standard_name", "longitude"), "put std_name att long")
    call check(nf90_put_att(ncid, lat_id, "standard_name", "latitude"), "put std_name att lat")
    call check(nf90_put_att(ncid, time_id, "standard_name", "time"), "put std_name att time")
    call check(nf90_put_att(ncid, u_id, "standard_name", "eastward_sea_water_velocity"), "put std_name att u")
    call check(nf90_put_att(ncid, v_id, "standard_name", "northward_sea_water_velocity"), "put std_name att v")
    call check(nf90_put_att(ncid, long_id, "long_name" , "Longitude"), "put long_name att long")
    call check(nf90_put_att(ncid, lat_id, "long_name" , "Latitude"), "put long_name att lat")
    call check(nf90_put_att(ncid, time_id, "long_name" , "time"), "put long_name att time")
    call check(nf90_put_att(ncid, u_id, "long_name" , "Eastward velocity"), "put long_name att u")
    call check(nf90_put_att(ncid, v_id, "long_name" , "Northward velocity"), "put long_name att v")
    call check(nf90_put_att(ncid, long_id, "units", "degrees_east"), "put units att long")
    call check(nf90_put_att(ncid, lat_id, "units", "degrees_north"), "put units att lat")
    call check(nf90_put_att(ncid, time_id, "units", "hours since 1950-1-1 00:00:00"), "put units att time")
    call check(nf90_put_att(ncid, u_id, "units", "m s-1"), "put units att u")
    call check(nf90_put_att(ncid, v_id, "units", "m s-1"), "put units att v")
    call check(nf90_put_att(ncid, long_id, "axis", "X"), "put att axis long")
    call check(nf90_put_att(ncid, lat_id, "axis", "Y"), "put att axis lat")
    call check(nf90_put_att(ncid, time_id, "calendar", "standard"), "put att calendar time")
    call check(nf90_put_att(ncid, time_id, "axis", "T"), "put att axis time")
    call check(nf90_put_att(ncid, u_id, "unit_long", "Meters per second"), "put att unit long u")
    call check(nf90_put_att(ncid, v_id, "unit_long", "Meters per second"), "put att unit long v")

    ! putting global attributes
    call check(nf90_put_att(ncid, nf90_global, "title", "standard file"), "put global att title")
    call check(nf90_put_att(ncid, nf90_global, "institution", "CSIC"), "put global att insitution")
    call check(nf90_put_att(ncid, nf90_global, "source", "data/TENCST-PdE-hm-20210417-HC.nc"), "put global att source")
    call check(nf90_put_att(ncid, nf90_global, "history", "2021-05-08T08:52:38.158"), "put global att history")
    call check(nf90_put_att(ncid, nf90_global, "references", ""), "put global att references")
    call check(nf90_put_att(ncid, nf90_global, "comment", ""), "put global att comment")
    call check(nf90_put_att(ncid, nf90_global, "conventions", "CF-1.8"), "put global att conventions")
    call check(nf90_put_att(ncid, nf90_global, "type", "Current field"), "put global att type")
    call check(nf90_put_att(ncid, nf90_global, "Aknowledgments", "This work is supported"), "put global att Aknowledgments")
    call check(nf90_put_att(ncid, nf90_global, "Authors", "CSIC"), "put global att authors")
    call check(nf90_put_att(ncid, nf90_global, "Conventions", "CF-1.4"), "put global att Conventions")
    
    ! end define mode
    call check(nf90_enddef(ncid), "end of definition")

    ! putting variables
    call check(nf90_put_var(ncid, long_id, longitude), "put long")
    call check(nf90_put_var(ncid, lat_id, latitude), "put lat")
    call check(nf90_put_var(ncid, time_id, time), "put time")
    call check(nf90_put_var(ncid, u_id, vect), "put u")
    call check(nf90_put_var(ncid, v_id, vect), "put v")

    ! closing netcdf
    call check(nf90_close(ncid), "closing file")




    !!!!   CONTAINS   !!!!

    contains

        subroutine check(status, operation)
            use netcdf
            implicit none

            integer, intent(in) :: status
            character(len=*), intent(in) :: operation

            if (status == nf90_noerr) return
            print *, "Error encountered during ", operation
            print *, nf90_strerror(status)
            stop
        
        end subroutine




end program read_nc_ibi
