#!/bin/bash

location=$(find data/inputs/${2} -name ${1});
nb_lines=$(grep -c ${3} $location);
nb_tot=$(grep -o ${3} $location | wc -l);
echo "Location :" $location
echo "Number of lines with" ${3} ":" $nb_lines;
echo "Total number of" ${3} ":" $nb_tot;
