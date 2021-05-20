#!/bin/bash

# 1st argument is the name of the file
# 2nd argument is the folder in which we have to search the file
# 3rd argument is the letter or the word to search in the file

location=$(find ./${2} -name ${1});
nb_lines=$(grep -c ${3} $location);
nb_tot=$(grep -o ${3} $location | wc -l);
echo "Location :" $location
echo "Number of lines with" ${3} ":" $nb_lines;
echo "Total number of" ${3} ":" $nb_tot;
