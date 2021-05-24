#!/bin/bash

location=${PWD}
qsub -q all.q -e ${location}/matrix.err -o ${location}/matrix.out ${location}/matrix.sh
