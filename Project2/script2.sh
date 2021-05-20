#!/bin/bash

location=$(pwd)
for i in {1..9}
do
    qsub -q all.q@node0${i}.icmat -e ${k}/test_${i}.err -o ${k}/test_${i}.out script1.sh ${i};
done;
qsub -q all.q@node0${i}.icmat -e ${k}/test_10.err -o ${k}/test_10.out script1.sh 10;
