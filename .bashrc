#begin .bashrc
# set vim to use on the command line
set -o vi

# FZF setting 
if type rg &> /dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files --hidden'
  export FZF_DEFAULT_OPTS="-m --height 50% --layout=reverse --border --inline-info 
"
fi


#export environment
export M1800=/global/project/projectdirs/m1800
export NB=/global/project/projectdirs/m1800/pin/github/
export HFR=/global/project/projectdirs/m1800/pin/Reach_scale_model
export PFLOTRAN=/global/project/projectdirs/pflotran
export TH=/global/project/projectdirs/m1800/pin/HFR-thermal
export THORNE=/global/project/projectdirs/m1800/pin/HFR-thorne
export PRW=/global/project/projectdirs/m1800/pin/PriestRapidsWatershed
export AT=/global/project/projectdirs/m1800/pin/AT-model
export PFLOTRAN_EXE=/global/project/projectdirs/pflotran/pflotran-cori-new/src/pflotran/pflotran
export PFLOTRAN_KNL_EXE=/global/project/projectdirs/m1800/pin/pflotran-knl/src/pflotran/pflotran
export ATS_EXE=/global/project/projectdirs/m1800/pin/ats-012121/amanzi-install-master-Release/bin/ats-012121-c39571b
export ATS_KNL_EXE=/global/project/projectdirs/m3421/ats-new/ats/install-master/cori-knl/intel-6.0.5-mpich-7.7.10/opt/bin/ats
export ATS_intel_exe=/global/project/projectdirs/m3421/ats-new/ats/install-master/cori-haswell/intel-6.0.5-mpich-7.7.10/opt/bin/ats
# export ATS_intel_landcover_exe=/global/project/projectdirs/m3421/ats-new/ats/install-ecoon-land_cover/cori-haswell/intel-6.0.5-mpich-7.7.10/opt/bin/ats
#export ATS_ET=/global/project/projectdirs/m3421/ats-new/ats/install-master/cori-haswell/gnu-6.0.5-mpich-7.7.10/opt/bin/ats
#export ATS_DEV=/global/project/projectdirs/m1800/pin/ats/ats-install-dev-trans-Release/bin/ats
# export ATS_GNU_landcover=/global/project/projectdirs/m1800/pin/ats-land_cover/amanzi-install-master-Release/bin/ats

export AMANZI_SRC_DIR=/global/project/projectdirs/m1800/pin/ats-geochem/repos/amanzi
export ATS_SRC_DIR=/global/project/projectdirs/m1800/pin/ats-geochem/repos/amanzi/src/physics/ats
# export PATHS
#export PATH=$PATH:/global/project/projectdirs/m1800/pin/pflotran/pflotran-030821/src/pflotran/bin
#export PATH=/global/project/projectdirs/m1800/pin/ats-012121/amanzi-install-master-Release/bin:$PATH
#export PATH=/global/project/projectdirs/m1800/pin/ats-022221/amanzi-install-master-Release/bin:$PATH
#export PATH=/global/project/projectdirs/m1800/pin/ats-land_cover/amanzi-install-master-Release/bin:$PATH
#export PATH=/global/project/projectdirs/m1800/pin/ats-geochem/amanzi-install-master-Release/bin:$PATH

alias csacct='sacct --format=JobID,partition,state,time,start,end,elapsed,nnodes,ncpus,nodelist,AllocTRES%32'  # show formatted job information
alias in='rg . | fzf --print0'  # use -e for exact match
alias cf='cdd $(fzf)'
alias f='fzf'
alias vf='vim $(fzf)'

alias lls='ls -GFht'
alias ltr='ls -ltrGFho'
alias pullmaster='git pull origin master'
alias pushmaster='git push origin master'
alias gitls='git status'
alias cfind='find . -iname'
alias cgrep='grep -ir --color'
alias salloc1='salloc -N 1 -C haswell -q interactive -t 00:30:00 -L SCRATCH'
alias srcbash='source ~/.bash_profile.ext'
alias fc='ls -F | wc -l'
alias ss='source ~/.zshrc'
 #bash function
xml_convert() {
python /global/project/projectdirs/m1800/pin/ats-111620/repos/amanzi/src/physics/ats/tools/input_converters/xml-1.0-dev.xml $1 -o $2
}

gitbr() {
  git for-each-ref --sort=committerdate refs/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'
}

pvbatch() {
         start_pvbatch.sh 4 4 haswell 00:30:00 default debug `pwd`/$1
 }

gitpullpush() {
# echo "commit message:"
read -ep "Enter commit message: " message
echo "--pull changes from github"
git pull origin master
git add --all
git commit -m "$message"
# echo "--$message"
echo "--push changes to github"
git push origin master
echo "--Done!"
}


cdd() {
cd $1 && ls -ltrGFho
}

csalloc_m3421() {
  salloc -N $1 -C haswell -q interactive -t $2 -L SCRATCH -A m3421
}

csalloc() {
  salloc -N $1 -C haswell -q interactive -t $2 -L SCRATCH
}

csalloc_knl() {
  salloc -N $1 -C knl -q interactive -t $2 -L SCRATCH -A m3940
}
csrun_pf() {
  srun -n $1 pflotran-030821 -pflotranin $2 2>&1 | tee ./run-$1-$( date '+%F_%H:%M:%S' ).log
}

csrun_pf_res() {
  srun -n $1 pflotran-dev -pflotranin $2 -realization_id $3 2>&1 | tee ./run.log
}

csrun_mesh() {
# run meshconvert
# $1-- no of cores; $2-- in .exo mesh; $3 -- out .par mesh
srun -n $1 meshconvert --partition-method=2 $2 $3
}

#csrun_ats-intel() {
#  srun -n $1 $ATS_intel_exe --xml_file=$2 2>&1 | tee ./run-$1-$( date '+%F_%H:%M:%S' ).log
#}
#csrun_ats-intel-landcover() {
#  srun -n $1 $ATS_intel_landcover_exe --xml_file=$2 2>&1 | tee ./run-$1-$( date '+%F_%H:%M:%S' ).log
#}

csrun_ats-geochem() {
  srun -n $1 ats-geochem-031221 --xml_file=$2 2>&1 | tee ./run-$1-$( date '+%F_%H:%M:%S' ).log
}
# csrun_ats_GNU-landcover() {
#   srun -n $1 $ATS_GNU_landcover --xml_file=$2 2>&1 | tee ./run-$1-$( date '+%F_%H:%M:%S' ).log
# }

# csrun_ats-landcover() {
#   srun -n $1 $ATS_intel_landcover_exe --xml_file=$2 2>&1 | tee ./run-$1-$( date '+%F_%H:%M:%S' ).log
# }
csrun_ats() {
  srun -n $1 $ATS_intel_exe --xml_file=$2 2>&1 | tee ./run-$1-$( date '+%F_%H:%M:%S' ).log
}
csrun_ats-knl() {
  srun -n $1 $ATS_KNL_EXE --xml_file=$2 2>&1 | tee ./run-$1-$( date '+%F_%H:%M:%S' ).log
}
csrun_ideasATS() {
  srun -n $1 /project/projectdirs/m2398/ideas/amanzi/install/cori/mpich2-7.7.10-gnu-8.3.0/Release-master-alquimia-ats-shared-200826/bin/ats --xml_file=$2 2>&1 | tee ./run-$1-$( date '+%F_%H:%M:%S' ).log
}


#if [[ -z $SHIFTER_RUNTIME ]]
#then
#
#  # Source appropriate .ext file
#  SHELL_PARSING=$0
#  if [ $SHELL_PARSING == -su ]; then
#      SHELL_PARSING=`readlink /proc/$$/exe`
#  fi
#  case $SHELL_PARSING in
#    -sh|sh|*/sh)
#    ;;
#    -ksh|ksh|*/ksh)
#      if [ -e $HOME/.kshrc.ext ]; then
#        typeset -xf module
#        . $HOME/.kshrc.ext
#      fi
#    ;;
#    -bash|bash|*/bash)
#      if [ -e $HOME/.bashrc.ext ]; then
#        . $HOME/.bashrc.ext
#      fi
#    ;;
#  esac
#fi
#end .bashrc

# [ -f ~/.fzf.bash ] && source ~/.fzf.bash
