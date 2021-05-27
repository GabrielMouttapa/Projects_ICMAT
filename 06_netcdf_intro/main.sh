#!/bin/bash

./scr/read_nc_ibi;
ncdump -h data/outputs/cmems_symplify.nc
