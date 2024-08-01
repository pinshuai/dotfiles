#!/bin/bash

# load module file
module use $HOME/MyModules
#source ~/github/dotfiles/.bash_profile

# set vim to use on the command line
set -o vi
# # set ripgrep to use with fzf 
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
# if type rg &> /dev/null; then
#   export FZF_DEFAULT_COMMAND='rg --files --hidden'
#   export FZF_DEFAULT_OPTS="-m --height 50% --layout=reverse --border --inline-info 
#   --preview-window=:hidden
#   --preview '([[ -f {} ]] && (bat --style=numbers --color=always {} || cat {})) || ([[ -d {} ]] && (tree -C {} | less)) || echo {} 2> /dev/null | head -200'
#   --bind '?:toggle-preview' 
#   "
# fi


# change bash prompt
# export PS1="\w>> "
# export PS1="\[\033[33;1m\]\w\[\033[m\]\$ "
# add git branch info
export PS1='\[\033[33;1m\]\w\[\033[0;32m\]$(if git rev-parse --git-dir > /dev/null 2>&1; then echo " - ["; fi)$(git branch 2>/dev/null | grep "^*" | colrm 1 2)\[\033[0;32m\]$(if git rev-parse --git-dir > /dev/null 2>&1; then echo "]"; fi)\[\033[0m\033[0;32m\] \$\[\033[0m\033[0;32m\]\[\033[0m\]\n> '

export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# add alias
alias in='rg . | fzf --print0'  # use -e for exact match; use -u for unrestricted match (i.e., skip .ignore files)
alias F='rg . --files --hidden --unrestricted | fzf --print0'
alias cf='cdd $(fzf)'
alias f='fzf'
alias vf='nvim $(fzf)'
alias v='nvim'
alias lls='ls -GFht'
alias ltr='ls -ltrGFho'
alias l='ls -ltrGFho'
alias pullmaster='git pull origin master'
alias pushmaster='git push origin master'
alias sshproxy='~/Dropbox/github/NERSC-MFA/sshproxy.sh -u pshuai'
alias sshcori='ssh -l pshuai -i ~/.ssh/nersc cori.nersc.gov'
alias sshycori='ssh -Y pshuai@cori.nersc.gov'
alias sshedi='ssh pshuai@edison.nersc.gov'
alias ss='source ~/.custom.sh'
# alias sqs='squeue -u u6046326 -l'
alias sqs='squeue -u u6046326 -o "%.18i %.9P %.8j %.8u %.22V %.8T %.10M %.9l %.6D %.22S %.20R %.10r %.10Q"'
alias si_notch_share='sinfo -p notchpeak-shared-short -l'
alias si_notch='sinfo -p notchpeak -l' # use -N to show detailed nodes information
# alias gitls='git status'
# alias gstS="git status --porcelain | awk '{print $2}' | xargs ls -halFS" # order by file size in git status
alias glf='git log --follow -p --'
alias sshpl='ssh shua784@pinklady.pnl.gov'
#alias cgrep='grep -ir --color'
alias nbv='open -a Jupyter\ Notebook\ Viewer'
alias sshcon='ssh shua784@constance.pnl.gov'
alias gst='git status'
alias gp='git push'
alias gl='git pull'
alias glg='git log --stat'

alias gcmsg='git commit -m'
alias gup='git pull --rebase'
alias gupa='git pull --rebase --autostash'
alias ga='git add'
alias gaa='git add --all'
alias gmtlvim='git mergetool --no-prompt --tool=vimdiff'
alias cds='c $SCRATCH_NFS'
alias cdn='c $NB'
# bash function

# add alias
export NB=/uufs/chpc.utah.edu/common/home/u6046326/github
export SIF_ATS_MASTER=/uufs/chpc.utah.edu/common/home/u6046326/CHPC/Container/ats_master-latest.sif 
export SIF_ATS_1d3=/uufs/chpc.utah.edu/common/home/u6046326/CHPC/Container/ats-1.3-latest.sif 
export SIF_ATS_1d5=/uufs/chpc.utah.edu/common/home/u6046326/CHPC/Container/ats_v1.5_dev28cbfab.sif
# export SCRATCH_LUS=/scratch/general/lustre/u6046326
export SCRATCH_NFS=/scratch/general/nfs1/pshuai
export SCRATCH_VAS=/scratch/general/vast/pshuai

# use youplot to show timestep of ats runs
plot_timestep() {
	cat $1 | grep "Cycle" | awk '{print $9, $13}' | awk '{printf "%s %.2f\n", $1, log($2)/log(10)}' | uplot line -d ' ' -w 100 -h 10 --ylabel 'timestep (log10)' --xlabel 'days' -t 'Run timestep'
}

# # list the files to be staged in the order of file size
gstS() {
    git status --porcelain | awk '{print $2}' | xargs ls -halFS
}

# docker_prune() {
#     # prune docker containers and images
# docker container prune
# docker container prune
# docker rmi $(docker images --filter "dangling=true" -q --no-trunc)
# }

cgrep() {
# search for keywords in files
grep -ir --color "$1" ./*
}

# pgrep() {
#   # search pdfs using pdfgrep in parallel
#   # arg:
#   #    $1: pdf names. eg "*.pdf", "Shuai*.pdf" (note the double quotes!)
#  #     $2: pattern. eg. fish, 'heat|fish'(note the single quote)
#  find . -iname "$1" -print0 | parallel -q0 pdfgrep -inHr --color always --max-count 10 --context 1 $2
# }

gitbr() {
  git for-each-ref --sort=committerdate refs/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'
}

singularity_ats_master(){
ml singularity gcc/8.5.0 mpich/3.4.2
mpirun -np $1 singularity exec $SIF_ATS_MASTER ats --xml_file=$2 2>&1 | tee ./run-$1-$( date '+%F_%H:%M:%S' ).log
}

singularity_ats_1d3(){
ml singularity gcc/8.5.0 mpich/3.4.2
mpirun -np $1 singularity exec $SIF_ATS_1d3 ats --xml_file=$2 2>&1 | tee ./run-$1-$( date '+%F_%H:%M:%S' ).log
}

singularity_ats_1d5(){
ml singularity gcc/8.5.0 mpich/3.4.2
mpirun -np $1 singularity exec $SIF_ATS_1d5 ats --xml_file=$2 2>&1 | tee ./run-$1-$( date '+%F_%H:%M:%S' ).log
}
# run_mesh() {
# # run meshconvert
# # $1-- no of cores; $2-- in .exo mesh; $3 -- out .par mesh
# mpirun -n $1 meshconvert --partition-method=2 $2 $3
# }

run_ats(){
mpirun -np $1 ats --xml_file=$2 2>&1 | tee ./run-$1-$( date '+%F_%H:%M:%S' ).log
}

# runpf(){
#   /Users/shua784/Dropbox/github/petsc_v3.13/arch-darwin-c-release/bin/mpirun -np $1 pflotran_v3.0-beta -pflotranin $2  >& 8.stdout}

cfind(){
  find ./ -iname $1 2>/dev/null
}

# rjlab(){
#     # Forwards port $1 (local machine) into port $2 (remote server) and listens to it
#     echo "forwarding remote port:$1 to local port:$2"
#     ssh -N -f -L localhost:$2:localhost:$1 shua784@pinklady.pnl.gov
# }

# gitpullpush() {
# # echo "commit message:"
# read -ep "Enter commit message: " message
# echo "--pull changes from github"
# git pull origin master
# git add --all
# git commit -m "$message"
# # echo "--$message"
# echo "--push changes to github"
# git push origin master
# echo "--Done!"
# }

# cdd() {
# cd $1 && ls -ltrGFho
# }

c() {
cd $1 && ls -ltrGFho
}

# syncprj() {
# rsync -avh -e ssh pshuai@cori.nersc.gov:/global/project/projectdirs/m1800/pin/"$1" $2
# }

# # scp file between servers
# proj2pc() {
#  \scp -rp pshuai@cori.nersc.gov:/global/project/projectdirs/m1800/pin/"$1" $2
# }

# pc2proj() {
#   \scp -rp $1 pshuai@cori.nersc.gov:/global/project/projectdirs/m1800/pin/"$2"
# }

# pc2proj-m3421() {
#   \scp -rp $1 pshuai@cori.nersc.gov:/global/project/projectdirs/m3421/pin/"$2"
# }
# cori2pc() {
#   \scp -rp pshuai@cori.nersc.gov:/global/cscratch1/sd/pshuai/"$1" $2
# }

# pc2cori() {
#  scp -rp $1 pshuai@cori.nersc.gov:/global/cscratch1/sd/pshuai/"$2"
# }

# pl2pc() {
#  \scp -rp shua784@pinklady.pnl.gov:"$1" $2
# }

# pc2pl() {
#   \scp -rp $1 shua784@pinklady.pnl.gov:"$2"
# }
# Here add custom module loads for all CHPC Linux systems

csalloc() {
	  salloc -N $1 -n $2 -t $3 -A notchpeak-shared-short -p notchpeak-shared-short
}

csalloc_notchpeak() {
	  salloc -N $1 -n $2 -t $3 -A shuai -p notchpeak
}

# ----------------------------------------------------------------------
if [[ "$UUFSCELL" = "kingspeak.peaks" ]] ; then
# add custom module loads after this
     :

# ----------------------------------------------------------------------
elif [[ "$UUFSCELL" = "notchpeak.peaks" ]] ; then
# add custom module loads after this
     :

# ----------------------------------------------------------------------
# Do Lonepeak specific initializations
elif [[ "$UUFSCELL" = "lonepeak.peaks" ]] ; then
# add custom module loads after this
     :

# ----------------------------------------------------------------------
# Do Ash specific initializations
elif [[ "$UUFSCELL" = "ash.peaks" ]] ; then
# add custom module loads after this
     :

# ----------------------------------------------------------------------
# Do Tangent specific initializations
elif [[ "$UUFSCELL" = "tangent.peaks" ]] ; then
# add custom module loads after this
     :

# ----------------------------------------------------------------------
elif [[ "$UUFSCELL" = "redwood.bridges" ]] ; then
# add custom module loads after this
     :

# ----------------------------------------------------------------------
# Do astro.utah.edu specific initializations
elif [[ "$UUFSCELL" = "astro.utah.edu" ]] ; then
# add custom module loads after this
	:

# ----------------------------------------------------------------------
# Do cemi specific initializations
elif [[ "$UUFSCELL" = "cemi" ]] ; then
# add custom module loads after this
	:

fi

[ -f ~/.fzf.bash  ] && source ~/.fzf.bash
# Uncomment to set TMPDIR from default (and small) /tmp to /scratch/local
#if [ ! -d /scratch/local/$USER ] ; then
#     mkdir /scratch/local/$USER 
#fi
#export TMPDIR=/scratch/local/$USER 


# ------ begin code written by ats_manager/setup_ats_manager.sh ------
export ATS_BASE=/uufs/chpc.utah.edu/common/home/u6046326/github/ats-amanzi-Jul2023
export MPI_DIR=/uufs/chpc.utah.edu/sys/spack/v019/linux-rocky8-x86_64/gcc-11.2.0/openmpi-4.1.4-fvjpa3zslc4266fazcxbv6ntjgojf6rx
# export PYTHONPATH="${PYTHONPATH}:/uufs/chpc.utah.edu/common/home/u6046326/github/ats-amanzi-Jul2023/ats_manager"
module use -a /uufs/chpc.utah.edu/common/home/u6046326/github/ats-amanzi-Jul2023/modulefiles
# ------ end code written by ats_manager/setup_ats_manager.sh --------

export PATH="/uufs/chpc.utah.edu/common/home/u6046326/software/pkg/mambaforge/bin:$PATH"
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/uufs/chpc.utah.edu/sys/installdir/miniconda3/4.3.31/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/uufs/chpc.utah.edu/sys/installdir/miniconda3/4.3.31/etc/profile.d/conda.sh" ]; then
        . "/uufs/chpc.utah.edu/sys/installdir/miniconda3/4.3.31/etc/profile.d/conda.sh"
    else
        export PATH="/uufs/chpc.utah.edu/sys/installdir/miniconda3/4.3.31/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

