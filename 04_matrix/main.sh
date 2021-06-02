#!/bin/bash

target_file="change_matrix.list";
generic_file="change_matrix.list.gen";
location=${PWD}
i=${1}
j=${2}
for n in $(seq 1 $i); do
    for m in $(seq 1 $j); do
        mkdir data/inputs/folder_${n}x${m}
        sed "s/---n---/${n}/g;s/---m---/${m}/g" data/inputs/${generic_file} > data/inputs/folder_${n}x${m}/${target_file};
        cp src/write_matrix.* data/inputs/folder_${n}x${m};
        qsub -q all.q -e "${location}/data/outputs/errors/matrix${n}x${m}.err" -o "${location}/data/outputs/outs/matrix${n}x${m}.out" ${location}/data/inputs/folder_${n}x${m}/write_matrix.sh ${location}/data/inputs/folder_${n}x${m};
    done;
done
qsub -q all.q -e "${location}/data/outputs/errors/del.err" -o "${location}/data/outputs/outs/del.out" ${location}/src/del.sh ${location}/data/inputs
