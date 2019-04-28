RED='\033[1;33m'
GREEN='\033[1;32m'
L_BLUE='\033[1;34m'
NC='\033[0m' # No Color
printf " ${RED}Remember to source bashrc!${NC}\n"
printf " ${GREEN}Remember to activate the conda env!${NC}\n"
printf " ${L_BLUE}Asking for job with $2 ${NC}\n"
oarsub -q default -p "GPU = '$2'" -l "nodes=1,walltime=$1" -I
