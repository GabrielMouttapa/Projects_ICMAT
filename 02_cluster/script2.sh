#!/bin/bash

location=${PWD}
for i in {1..9}
do
    qsub -q all.q -e ${location}/test_${i}.err -o ${location}/test_${i}.out ./script1.sh ${i};
  done;
qsub -q all.q -e ${location}/test_10.err -o ${location}/test_10.out ./script1.sh 1t
0
