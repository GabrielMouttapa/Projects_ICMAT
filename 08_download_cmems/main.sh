#!/bin/bash

location=${PWD};
qsub -q all.q -e ${location}/data/outputs/errors/test.err -o ${location}/data/outputs/outs/test.out ${location}/src/main_python.py
