# set vim to use on the command line
set -o vi
# set ripgrep to use with fzf 
if type rg &> /dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files --hidden'
  export FZF_DEFAULT_OPTS="-m --height 50% --layout=reverse --border --inline-info 
  --preview-window=:hidden
  --preview '([[ -f {} ]] && (bat --style=numbers --color=always {} || cat {})) || ([[ -d {} ]] && (tree -C {} | less)) || echo {} 2> /dev/null | head -200'
  --bind '?:toggle-preview' 
  "
fi


# change bash prompt
# export PS1="\w>> "
# export PS1="\[\033[33;1m\]\w\[\033[m\]\$ "
# add git branch info
export PS1='\[\033[33;1m\]\w\[\033[0;32m\]$(if git rev-parse --git-dir > /dev/null 2>&1; then echo " - ["; fi)$(git branch 2>/dev/null | grep "^*" | colrm 1 2)\[\033[0;32m\]$(if git rev-parse --git-dir > /dev/null 2>&1; then echo "]"; fi)\[\033[0m\033[0;32m\] \$\[\033[0m\033[0;32m\]\[\033[0m\] '

# export CLICOLOR=1
# export LSCOLORS=ExFxBxDxCxegedabagacad

# add alias
alias in='rg . | fzf --print0'  # use -e for exact match; use -u for unrestricted match (i.e., skip .ignore files)
alias F='rg . --files --hidden --unrestricted | fzf --print0'
alias cf='cdd $(fd -t d . $HOME | fzf)'
alias f='fzf'
alias vf='nvim $(fzf)'
alias v='nvim'
alias lls='ls -GFht'
alias ltr='ls -ltrGFho'
# alias l='ls -ltrGFho'
alias pullmaster='git pull origin master'
alias pushmaster='git push origin master'
alias sshproxy='~/Dropbox/github/NERSC-MFA/sshproxy.sh -u pshuai'
alias sshcori='ssh -l pshuai -i ~/.ssh/nersc cori.nersc.gov'
alias sshperlmutter='ssh pshuai@perlmutter-p1.nersc.gov'
alias sshycori='ssh -Y pshuai@cori.nersc.gov'
alias sshedi='ssh pshuai@edison.nersc.gov'
# alias gitls='git status'
# alias gstS="git status --porcelain | awk '{print $2}' | xargs ls -halFS" # order by file size in git status
alias glf='git log --follow -p --'
alias sshpl='ssh shua784@pinklady.pnl.gov'
#alias cgrep='grep -ir --color'
alias nbv='open -a Jupyter\ Notebook\ Viewer'
alias sshcon='ssh shua784@constance.pnl.gov'
alias bfg="java -jar ~/Dropbox/Software/BFG/bfg-1.14.0.jar"
# bash function

# list the files to be staged in the order of file size
gstS() {
    git status --porcelain | awk '{print $2}' | xargs ls -halFS
}

docker_prune() {
    # prune docker containers and images
docker container prune
docker rmi $(docker images --filter "dangling=true" -q --no-trunc)
}

cgrep(){
# search for keywords in files
grep -ir --color "$1" ./*
}

pgrep() {
  # search pdfs using pdfgrep in parallel
  # arg:
  #    $1: pdf names. eg "*.pdf", "Shuai*.pdf" (note the double quotes!)
 #     $2: pattern. eg. fish, 'heat|fish'(note the single quote)
 find . -iname "$1" -print0 | parallel -q0 pdfgrep -inHr --color always --max-count 10 --context 1 $2
}

gitbr() {
  git for-each-ref --sort=committerdate refs/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'
}

run_mesh() {
# run meshconvert
# $1-- no of cores; $2-- in .exo mesh; $3 -- out .par mesh
mpirun -n $1 meshconvert --partition-method=2 $2 $3
}

run_ats(){
mpirun -n $1 ats-land_cover --xml_file=$2 2>&1 | tee ./run-$1-$( date '+%F_%H:%M:%S' ).log
}

run_pf1(){
$PFLOTRAN_EXE -pflotranin $1 2>&1 | tee ./run-$( date '+%F_%H:%M:%S' ).log
}

runpf(){
  /Users/shua784/Dropbox/github/petsc_v3.13/arch-darwin-c-release/bin/mpirun -np $1 pflotran_v3.0-beta -pflotranin $2  >& 8.stdout}

cfind(){
  find ./ -iname $1 2>/dev/null
}

rjlab(){
    # Forwards port $1 (local machine) into port $2 (remote server) and listens to it
    echo "forwarding remote port:$1 to local port:$2"
    ssh -N -f -L localhost:$2:localhost:$1 shua784@pinklady.pnl.gov
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

c() {
cd $1 && ls -ltrGFho
}

syncprj() {
rsync -avh -e ssh pshuai@cori.nersc.gov:/global/project/projectdirs/m1800/pin/"$1" $2
}

# scp file between servers
proj2pc() {
 \scp -rp pshuai@cori.nersc.gov:/global/project/projectdirs/m1800/pin/"$1" $2
}

pc2proj() {
  \scp -rp $1 pshuai@cori.nersc.gov:/global/project/projectdirs/m1800/pin/"$2"
}

pc2proj-m3421() {
  \scp -rp $1 pshuai@cori.nersc.gov:/global/project/projectdirs/m3421/pin/"$2"
}

cori2pc() {
  \scp -rp pshuai@cori.nersc.gov:/global/cscratch1/sd/pshuai/"$1" $2
}

pc2pm() {
  \scp -rp $1 pshuai@perlmutter-p1.nersc.gov:/pscratch/sd/p/pshuai/"$2"
}

pm2pc() {
  \scp -rp pshuai@perlmutter-p1.nersc.gov:/pscratch/sd/p/pshuai/"$1" $2
}

pc2cori() {
 scp -rp $1 pshuai@cori.nersc.gov:/global/cscratch1/sd/pshuai/"$2"
}

pc2chpc_nfs() {
 scp -rp $1 u6046326@notchpeak1.chpc.utah.edu:/scratch/general/nfs1/pshuai/"$2"
}

chpc_nfs2pc() {
 scp -rp u6046326@notchpeak1.chpc.utah.edu:/scratch/general/nfs1/pshuai/"$1" $2
}

pc2chpc_home() {
 scp -rp $1 u6046326@notchpeak1.chpc.utah.edu:/uufs/chpc.utah.edu/common/home/u6046326/"$2"
}

chpc_home2pc() {
 scp -rp u6046326@notchpeak1.chpc.utah.edu:/uufs/chpc.utah.edu/common/home/u6046326/"$1" $2
}

pl2pc() {
 \scp -rp shua784@pinklady.pnl.gov:"$1" $2
}

pc2pl() {
  \scp -rp $1 shua784@pinklady.pnl.gov:"$2"
}

# add shortcut
export NB=$HOME/github
export ATS_SRC_DIR=$NB/ats
export AMANZI_SRC_DIR=$NB/amanzi

export WATERSHED_WORKFLOW_DATA_DIR=$HOME/github/watershed-workflow/data_library 
export WATERSHED_WORKFLOW_DIR=$HOME/github/watershed-workflow

# add python path for ats
export PYTHONPATH="${PYTHONPATH}:$ATS_SRC_DIR/tools/utils"

# add python path for watershed_workfow
# ========== API keys (do not share) ===============
# WaDE
export WADE_API_KEY=
# ========= Username/Passwords (CONFIDENTIAL) =======
# AppEEARS
export APPEEARS_USERNAME=
export APPEEARS_PASSWORD=

#=========add pflotran short course related vars=================
export PATH="/opt/homebrew/bin:$PATH"  
export PETSC_DIR==$NB/petsc
export PETSC_ARCH=arch-darwin-c-opt  
export PFLOTRAN_DIR=$NB/pflotran
export dfnworks_DIR=$NB/dfnWorks 
export PFLOTRAN_EXE=$PFLOTRAN_DIR/src/pflotran/pflotran 
export LAGRIT_EXE=$NB/LaGriT/build/lagrit 
export DFNGEN_EXE=$dfnworks_DIR/DFNGen/DFNGen 
export PATH="$NB/Dakota/software/dakota/bin:$PATH"


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/shuai/opt/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/shuai/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/shuai/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/shuai/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

