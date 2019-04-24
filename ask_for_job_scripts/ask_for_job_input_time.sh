RED='\033[1;33m'
GREEN='\033[1;32m'
NC='\033[0m' # No Color
printf " ${RED}Remember to source bashrc!${NC}\n"
printf " ${GREEN}Remember to activate the conda env!${NC}\n"
oarsub -q production -p "GPU <> 'NO'" -l "nodes=1,walltime=$1" -I
echo 'Heelo!'
