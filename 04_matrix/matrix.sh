#!/bin/bash

target_file="/LUSTRE/users/gmouttapa/gfd_course/Projects_ICMAT/Fortran_matrix/change_matrix.list";
generic_file="/LUSTRE/users/gmouttapa/gfd_course/Projects_ICMAT/Fortran_matrix/change_matrix.list.gen";

for n in {1..5}; do
    for m in {1..5}; do
        sed "s/---n---/${n}/g;s/---m---/${m}/g" ${generic_file} > ${target_file};
        /LUSTRE/users/gmouttapa/gfd_course/Projects_ICMAT/Fortran_matrix/write_matrix.out
    done;
done
