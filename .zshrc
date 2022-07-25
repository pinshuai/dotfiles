source ~/.bash_profile
# get bash behavior of wildcard 
# setopt nonomatch
# prevent zsh to throw a no-match error
# alias scp='noglob scp'
unsetopt nomatch

# bind keys
bindkey "[C" forward-word
bindkey "[D" backward-word
# use tab to autocomplete suggestions, may overwrite default tab dirs behaviors
# bindkey '\t' autosuggest-accept

setopt extendedglob
# store dirs history
setopt AUTO_PUSHD                  # pushes the old directory onto the stack
setopt PUSHD_MINUS                 # exchange the meanings of '+' and '-'
setopt CDABLE_VARS                 # expand the expression (allows 'cd -2/tmp')
autoload -U compinit && compinit   # load + start completion
zstyle ':completion:*:directory-stack' list-colors '=(#b) #([0-9]#)*( *)==95=38;5;12'

gitpullpush() {
## echo "commit message:"
read "message?Enter commit message: "
echo "--pull changes from github"
git pull origin main
git add --all
git commit -m "$message"
## echo "--$message"
echo "--push changes to github"
git push origin main
echo "--Done!"
}

# func
rjlab(){
    # Forwards port $1 (local machine) into port $2 (remote server) and listens to it
    echo "forwarding remote port:$1 to local port:$2"
    ssh -N -f -L localhost:${2}:localhost:${1} shua784@pinklady.pnl.gov
}


# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/shua784/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.

# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git fzf zsh-autosuggestions docker docker-compose)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#

alias l='ls -ltrGFho'
alias scp='\scp'
alias ss='source ~/.zshrc'
# cdd() {
#cd $1
#ls -ltr
#}
#
#syncprj() {
#rsync -avh -e ssh pshuai@cori.nersc.gov:/global/project/projectdirs/m1800/pin/"$1" $2
#}
#
## scp file between servers
## add \ before scp for zsh env.
#proj2pc() {
# \scp -rp pshuai@cori.nersc.gov:/global/project/projectdirs/m1800/pin/"$1" $2
#}
#
#pc2proj() {
#  \scp -rp $1 pshuai@cori.nersc.gov:/global/project/projectdirs/m1800/pin/"$2"
#}
#
#cori2pc() {
#  \scp -rp pshuai@cori.nersc.gov:/global/cscratch1/sd/pshuai/"$1" $2
#}
#
#pc2cori() {
#  \scp -rp $1 pshuai@cori.nersc.gov:/global/cscratch1/sd/pshuai/"$2"
#}

#### add shortcuts###
#export HFR=/Users/shua784/Dropbox/PNNL/Projects/Reach_scale_model
#export TH=/Users/shua784/Dropbox/PNNL/Projects/HFR-thermal
#export NB=/Users/shua784/Dropbox/github
#export AT=/Users/shua784/Dropbox/PNNL/Projects/AT-model


test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# for zoxide
eval "$(zoxide init zsh)"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
