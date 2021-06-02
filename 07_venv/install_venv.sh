python3 -m venv ${1};
source ${1}/bin/activate;
${1}/bin/pip install --upgrade pip;
echo numpy==1.19.5 > requirements.txt
${1}/bin/pip install -r ./requirements.txt
