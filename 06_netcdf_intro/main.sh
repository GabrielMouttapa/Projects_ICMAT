#!/bin/bash

module load ROMS/intel
src/read_nc_ibi;
ncdump -h data/outputs/cmems_symplify.nc
