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




# export PS1="\w>> "
# export PS1="\[\033[33;1m\]\w\[\033[m\]\$ "
# add git branch info
# export PS1='\[\033[33;1m\]\w\[\033[0;32m\]$(if git rev-parse --git-dir > /dev/null 2>&1; then echo " - ["; fi)$(git branch 2>/dev/null | grep "^*" | colrm 1 2)\[\033[0;32m\]$(if git rev-parse --git-dir > /dev/null 2>&1; then echo "]"; fi)\[\033[0m\033[0;32m\] \$\[\033[0m\033[0;32m\]\[\033[0m\] '

# export CLICOLOR=1
# export LSCOLORS=ExFxBxDxCxegedabagacad

# add alias
alias mkdir='mkdir -p'
alias cp='cp -rp'
alias ci='c $ICLOUD'
alias cdn='c $NB'
alias dokilA='docker kill $(docker ps -a -q)'
alias dokil1='docker kill $(docker ps -a -q | head -n 1)'
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
alias pngcomp="oxipng -o 4"

# bash function


extract_frames_from_video() {
    local INPUT=$1
    local SCENEDETECT_METHOD=${2:-"detect-content"}  # Default to 'detect-content'
    local THRESHOLD=${3:-18}  # Default threshold value is 18 if not provided

    if [[ -z "$INPUT" ]]; then
        echo "Error: Please provide a video URL or a file path."
        return 1
    fi

    local OUTPUT_VIDEO
    local OUTPUT_DIR
    local OUTPUT_PDF

    # Check if the input is a URL or a file path
    if [[ "$INPUT" =~ ^http ]]; then
        # Input is a URL, download the video
        OUTPUT_VIDEO="$(yt-dlp --get-filename -o '%(title)s.%(ext)s' "$INPUT")"
        echo "Downloading video from $INPUT..."
        yt-dlp -o "$OUTPUT_VIDEO" "$INPUT"

        if [[ $? -ne 0 ]]; then
            echo "Error: Failed to download video."
            return 1
        fi
    elif [[ -f "$INPUT" ]]; then
        # Input is a file path, use it directly
        OUTPUT_VIDEO="$INPUT"
        echo "Using local video file: $OUTPUT_VIDEO"
    else
        echo "Error: Invalid input. Please provide a valid URL or file path."
        return 1
    fi

    # Set output directory and PDF names based on the video filename
    OUTPUT_DIR="${OUTPUT_VIDEO%.*}_frames"
    OUTPUT_PDF="${OUTPUT_VIDEO%.*}_frames.pdf"

    echo "Creating output directory: $OUTPUT_DIR"
    mkdir -p "$OUTPUT_DIR"

    echo "Extracting frames with scenedetect using arguments: $SCENEDETECT_METHOD and threshold: $THRESHOLD..."
    scenedetect -i "$OUTPUT_VIDEO" --stats stats.csv -o "$OUTPUT_DIR" $SCENEDETECT_METHOD --threshold $THRESHOLD save-images --quality 95

    if [[ $? -ne 0 ]]; then
        echo "Error: Failed to extract frames."
        return 1
    fi

    echo "Converting frames to PDF..."
    magick "$OUTPUT_DIR"/*.jpg "$OUTPUT_PDF"

    if [[ $? -eq 0 ]]; then
        echo "PDF creation complete. PDF saved as $OUTPUT_PDF."
    else
        echo "Error: Failed to create PDF."
        return 1
    fi
}

doc2md() {
  # Convert a document to markdown
  # First argument is the name of the document file
  # Second argument is the name of the markdown file (optional)
  
  input_file="$1"
  
  # Check if the second argument is provided
  if [ -z "$2" ]; then
    # Remove the extension from the first argument and add .md
    output_file="${input_file%.*}.md"
  else
    output_file="$2"
  fi

  # Run the pandoc command
  pandoc "$input_file" -o "$output_file" \
    --to markdown_strict \
    --extract-media=./figures \
    --verbose
}


pandoc2pdf() {
  # Convert markdown to pdf
  # First argument is the name of the markdown file
  # Second argument is the name of the pdf file (optional)
  
  input_file="$1"
  
  # Check if the second argument is provided
  if [ -z "$2" ]; then
    # Remove the extension from the first argument and add .pdf
    output_file="${input_file%.*}.pdf"
  else
    output_file="$2"
  fi

  # Run the pandoc command
  pandoc "$input_file" -o "$output_file" \
    --resource-path=/Users/shuai/github/notes/attachments/figures \
    --from markdown \
    --strip-comments=true \
    --template eisvogel \
    --listings \
    --bibliography=/Users/shuai/Dropbox/Papers4Mendeley/BibTex/MyLibrary.bib \
    --citeproc \
    --csl=/Users/shuai/.local/share/pandoc/csl/apa.csl \
    --pdf-engine=/usr/local/texlive/2023/bin/universal-darwin/pdflatex \
    --verbose
}

screenshot2pdf() {
  # Convert screenshot(s) to a single PDF
  # First argument is the date in the format of %Y-%m-%d
  # Second argument is the name of the pdf file (optional)
  # after conversion, use smallPDF to compress the file
  #
  date_str="$1"
  
  # Check if the second argument is provided
  if [ -z "$2" ]; then
    # Set default output file name based on the date
    output_file="Screenshots_$date_str.pdf"
  else
    output_file="$2"
  fi
  
  # Convert the screenshots to a single PDF
  magick convert ~/Dropbox/Screenshots/Screenshot\ $date_str*.png ~/Dropbox/Screenshots/$output_file
}

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
  mpirun -np $1 pflotran -pflotranin $2 2>&1 | tee ./run-$( date '+%F_%H:%M:%S' ).log
}

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
rsync -avh -e ssh pshuai@perlmutter-p1.nersc.gov:/global/cfs/cdirs/m1800/pin/"$1" $2
}

# scp file between servers
proj2pc() {
 \scp -rp pshuai@perlmutter-p1.nersc.gov:/global/cfs/cdirs/m1800/pin/"$1" $2
}

pc2proj() {
  \scp -rp $1 pshuai@perlmutter-p1.nersc.gov:/global/cfs/cdirs/m1800/pin/"$2"
}

pc2proj-m3421() {
  \scp -rp $1 pshuai@perlmutter-p1.nersc.gov:/global/project/projectdirs/m3421/pin/"$2"
}


pc2pm() {
  \scp -rp $1 pshuai@perlmutter-p1.nersc.gov:/pscratch/sd/p/pshuai/"$2"
}

pm2pc() {
  \scp -rp pshuai@perlmutter-p1.nersc.gov:/pscratch/sd/p/pshuai/"$1" $2
}


pc2chpc_nfs() {
 scp -rp $1 u6046326@notchpeak1.chpc.utah.edu:/scratch/general/nfs1/pshuai/"$2"
}

chpc_nfs2pc() {
 scp -rp u6046326@notchpeak1.chpc.utah.edu:/scratch/general/nfs1/pshuai/"$1" $2
}

chpc_group2pc() {
 scp -rp u6046326@notchpeak1.chpc.utah.edu:/uufs/chpc.utah.edu/common/home/shuai-group1/"$1" $2
}

pc2chpc_group() {
 scp -rp $1 u6046326@notchpeak1.chpc.utah.edu:/uufs/chpc.utah.edu/common/home/shuai-group1/"$2"
}

pc2chpc_home() {
 scp -rp $1 u6046326@notchpeak1.chpc.utah.edu:/uufs/chpc.utah.edu/common/home/u6046326/"$2"
}

chpc_home2pc() {
 scp -rp u6046326@notchpeak1.chpc.utah.edu:/uufs/chpc.utah.edu/common/home/u6046326/"$1" $2
}

tacc_work2pc() {
 scp -rp pshuai@login2.ls6.tacc.utexas.edu:/work/09628/pshuai/ls6/"$1" $2
}

pc2tacc_work() {
 scp -rp $1 pshuai@login2.ls6.tacc.utexas.edu:/work/09628/pshuai/ls6/"$2"
}





# add shortcut

export NB=$HOME/github
export ICLOUD=$HOME/Library/Mobile\ Documents/iCloud~md~obsidian/Documents/notes
export ATS_SRC_DIR=$NB/ats
export AMANZI_SRC_DIR=$NB/amanzi

export WATERSHED_WORKFLOW_DATA_DIR=$HOME/github/watershed-workflow/data_library 
export WATERSHED_WORKFLOW_DIR=$HOME/github/watershed-workflow

# add python path for ats
# export PYTHONPATH="${PYTHONPATH}:$ATS_SRC_DIR/tools/utils"

# add python path for watershed_workfow
# export PYTHONPATH="${PYTHONPATH}:$SEACAS_DIR/lib"
# ========== API keys (do not share) ===============
# WaDE
export WADE_API_KEY=
# ========= Username/Passwords (CONFIDENTIAL) =======
# AppEEARS
export APPEEARS_USERNAME=
export APPEEARS_PASSWORD=

export PATH="/usr/local/texlive/2023/bin/universal-darwin:$PATH"

#=========add pflotran short course related vars=================
export PATH="/opt/homebrew/bin:$PATH"  
export PETSC_DIR=$NB/petsc
export SEACAS_DIR=$NB/seacas
export PETSC_ARCH=arch-darwin-c-opt  
export PFLOTRAN_DIR=$NB/pflotran
export DAKOTA_DIR=$NB/dakota
export dfnworks_DIR=$NB/dfnWorks 
export dfnworks_PATH=$NB/dfnWorks 
export PFLOTRAN_EXE=$PFLOTRAN_DIR/src/pflotran/pflotran 
export LAGRIT_EXE=$NB/LaGriT/build/lagrit 
export DFNGEN_EXE=$dfnworks_DIR/DFNGen/DFNGen 
export PATH="$DAKOTA_DIR/bin:$PATH"
export PATH="$PFLOTRAN_DIR/src/pflotran/bin:$PATH"

# For compilers to find libffi you may need to set:
export LDFLAGS="-L/opt/homebrew/opt/libffi/lib"
export CPPFLAGS="-I/opt/homebrew/opt/libffi/include"

# For pkg-config to find libffi you may need to set:
export PKG_CONFIG_PATH="/opt/homebrew/opt/libffi/lib/pkgconfig"


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

