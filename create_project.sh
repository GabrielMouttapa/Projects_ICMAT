#!/bin/bash

name="${1}_${2}"
mkdir ${name}
cd ${name}
mkdir scr data tests
echo "#!/bin/bash" > main.sh
chmod +x main.sh
cd data
mkdir inputs outputs

