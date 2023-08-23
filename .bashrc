#begin .bashrc
alias tmux="TERM=screen-256color-bce tmux"
# set vim to use on the command line
set -o vi

# FZF setting 
if type rg &> /dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files --hidden'
  export FZF_DEFAULT_OPTS="-m --height 50% --layout=reverse --border --inline-info 
"
fi


#export environment
export M1800=$CFS/m1800
export M3421=$CFS/m3421
export NB=$CFS/m1800/pin/github/
export GITHUB_DIR=$CFS/m1800/pin/github/
export HFR=$CFS/m1800/pin/Reach_scale_model
export PFLOTRAN=$CFS/pflotran
export TH=$CFS/m1800/pin/HFR-thermal
export THORNE=$CFS/m1800/pin/HFR-thorne
export PRW=$CFS/m1800/pin/PriestRapidsWatershed
export AT=$CFS/m1800/pin/AT-model
export PFLOTRAN_EXE=$CFS/pflotran/pflotran-cori-new/src/pflotran/pflotran
export PFLOTRAN_KNL_EXE=$CFS/m1800/pin/pflotran-knl/src/pflotran/pflotran
# export ATS_GEOCHEM_EXE=$CFS/m1800/pin/ats-geochem-111821/amanzi-install-master-Release/bin/ats
# export ATS_EXE=$CFS/m1800/pin/ats-012121/amanzi-install-master-Release/bin/ats-012121-c39571b
# export ATS_KNL_EXE=$CFS/m3421/ats-new/ats/install-master/cori-knl/intel-6.0.5-mpich-7.7.10/opt/bin/ats
# export ATS_HASWELL_EXE=$CFS/m3421/ats-new/ats/install-master/cori-haswell/intel-6.0.5-mpich-7.7.10/opt/bin/ats
# export ATS_HASWELL_V12=$CFS/m3421/ats-new/ats/install/amanzi-1.2+ats-1.2/cori-haswell/intel-6.0.5-mpich-7.7.10/opt/bin/ats
# export ATS_intel_exe=$CFS/m3421/ats-new/ats/install-master/cori-haswell/intel-6.0.5-mpich-7.7.10/opt/bin/ats
export ATS_MODULE_FILE=$CFS/m3421/ats-new/modulefiles
export MYFUNC_DIR=$CFS/m1800/pin/github/myfunctions
# export AMANZI_SRC_DIR=$CFS/m1800/pin/ats-geochem/repos/amanzi
# export ATS_SRC_DIR=$CFS/m1800/pin/ats-geochem/repos/amanzi/src/physics/ats
# export PATHS
#export PATH=$PATH:$CFS/m1800/pin/pflotran/pflotran-030821/src/pflotran/bin
#export PATH=$CFS/m1800/pin/ats-012121/amanzi-install-master-Release/bin:$PATH
#export PATH=$CFS/m1800/pin/ats-022221/amanzi-install-master-Release/bin:$PATH
#export PATH=$CFS/m1800/pin/ats-land_cover/amanzi-install-master-Release/bin:$PATH
#export PATH=$CFS/m1800/pin/ats-geochem/amanzi-install-master-Release/bin:$PATH

alias csacct='sacct --format=JobID,partition,state,time,start,end,elapsed,nnodes,ncpus,nodelist,AllocTRES%32'  # show formatted job information
alias in='rg . | fzf --print0'  # use -e for exact match
alias cf='cdd $(fzf)'
alias f='fzf'
alias vf='vim $(fzf)'
alias v='vim'

alias lls='ls -GFht'
alias ltr='ls -ltrGFho'
alias pullmaster='git pull origin master'
alias pushmaster='git push origin master'
alias gitls='git status'
alias glgf='git log -p --follow' # follow the file history
alias cfind='find . -iname'
alias cgrep='grep -ir --color'
alias salloc1='salloc -N 1 -C haswell -q interactive -t 00:30:00 -L SCRATCH'
alias srcbash='source ~/.bash_profile.ext'
alias fc='ls -F | wc -l'
alias ss='source ~/.zshrc'
alias dus='du -h --max-depth=1 | sort -hr' # show a list of directory size and ranked from large to small
alias sshperlmutter='ssh pshuai@perlmutter-p1.nersc.gov'
 #bash function
xml_convert() {
python $CFS/m1800/pin/ats-111620/repos/amanzi/src/physics/ats/tools/input_converters/xml-1.0-dev.xml $1 -o $2
}

# rank file by size in "git status"
gstS () {
	git status --porcelain | awk '{print $2}' | xargs ls -halFS
}

# show detailed branch information
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


c() {
cd $1 && ls -ltrGFho
}

csalloc_m3940() {
  salloc -N $1 -C cpu -q interactive -t $2 -L SCRATCH -A m3940
}

csalloc() {
  salloc -N $1 -C cpu -q interactive -t $2 -L SCRATCH -A $3
}

csalloc_haswell() {
  salloc -N $1 -C haswell -q interactive -t $2 -L SCRATCH -A m1800
}

csalloc_perl() {
  salloc -N $1 -C cpu -q interactive -t $2 -L SCRATCH -A m1800
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
  srun -n $1 $ATS_GEOCHEM_EXE --xml_file=$2 2>&1 | tee ./run-$1-$( date '+%F_%H:%M:%S' ).log
}
# csrun_ats_GNU-landcover() {
#   srun -n $1 $ATS_GNU_landcover --xml_file=$2 2>&1 | tee ./run-$1-$( date '+%F_%H:%M:%S' ).log
# }

# csrun_ats-landcover() {
#   srun -n $1 $ATS_intel_landcover_exe --xml_file=$2 2>&1 | tee ./run-$1-$( date '+%F_%H:%M:%S' ).log
# }
csrun_ats() {
  srun -n $1 $ATS_HASWELL_EXE --xml_file=$2 2>&1 | tee ./run-$1-$( date '+%F_%H:%M:%S' ).log
}

csrun_ats_v12() {
  srun -n $1 $ATS_HASWELL_V12 --xml_file=$2 2>&1 | tee ./run-$1-$( date '+%F_%H:%M:%S' ).log
}

csrun_ats_master() {
  srun -n $1 ats --xml_file=$2 2>&1 | tee ./run-$1-$( date '+%F_%H:%M:%S' ).log
}

csrun_ats-knl() {
  srun -n $1 $ATS_KNL_EXE --xml_file=$2 2>&1 | tee ./run-$1-$( date '+%F_%H:%M:%S' ).log
}
csrun_ideasATS() {
  srun -n $1 /project/projectdirs/m2398/ideas/amanzi/install/cori/mpich2-7.7.10-gnu-8.3.0/Release-master-alquimia-ats-shared-200826/bin/ats --xml_file=$2 2>&1 | tee ./run-$1-$( date '+%F_%H:%M:%S' ).log
}

# ------ begin code written by ats_manager/setup_ats_manager.sh ------
# export ATS_BASE=/global/cfs/cdirs/m1800/pin/ats-perlmutter_v1.5
# export PYTHONPATH=:/global/cfs/cdirs/m1800/pin/ats-perlmutter_v1.5/ats_manager
# export MPI_DIR=/opt/cray/pe/mpich/8.1.25/ofi/gnu/9.1
# module use -a /global/cfs/cdirs/m1800/pin/ats-perlmutter_v1.5/modulefiles
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
