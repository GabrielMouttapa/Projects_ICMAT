#!/bin/bash

mkdir ${1}
cd ${1}
mkdir src data
touch main.py
python3 -m venv env
source env/bin/activate
env/bin/pip install --upgrade pip

# Libraries
echo numpy==1.19.5 > requirements.txt
echo matplotlib==3.3.4 >> requirements.txt
echo netCDF4==1.5.6 >> requirements.txt

env/bin/pip install -r ./requirements.txt
cd data
mkdir outputs inputs
