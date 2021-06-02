#!/bin/bash

location=${PWD}
for i in {1..10}; do
    qsub -q all.q -e ${location}/data/outputs/errors/test_${i}.err -o ${location}/data/outputs/outs/test_${i}.out ${location}/src/script1.sh ${i} ${location};
done;
