#!/bin/bash

mkdir ${1}
cd ${1}
mkdir src data
touch main.py
touch src/requirements.txt
python3 -m venv env
source env/bin/activate
env/bin/pip install --upgrade pip

#### Libraries ####

# Numpy
#echo numpy==1.19.5 >> src/requirements.txt
#echo import numpy as mp >> main.py

# Pyplot
#echo matplotlib==3.3.4 >> src/requirements.txt
#echo import matplotlib.pyplot as plt >> main.py

# netCDF
#echo netCDF4==1.5.6 >> src/requirements.txt
#echo import netCDF4 >> main.py

# motuclient

echo motuclient==1.8.8 >> src/requirements.txt
echo import motuclient >> main.py

# dotenv

echo python-dotenv==0.15.0 >> src/requirements.txt
echo from dotenv import load_dotenv >> main.py

env/bin/pip install -r ./src/requirements.txt
cd data
mkdir outputs inputs
