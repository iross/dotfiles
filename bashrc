# .bashrc
PATH=/home/iaross/bin:/home/iaross/local/bin:/home/iaross/bin/bin:$PATH
# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

alias c='cd -p '
alias v='vim '
alias c='cd -P'
alias grep="grep --color=auto"
alias ql='qlmanage -p 2>/dev/null'
alias e='emacs -nw'
alias h='history | grep '
alias ll='ls -l'
alias ld='ll -d */'
alias cd1="cd .."
alias cd2="cd ../.."
alias cd3="cd ../../.."
alias root="root -l"
alias gap="git add -p"
alias gitdiff="git --no-pager diff"

function mkd ()
{
    mkdir $1
    cd $1
}
function mvln ()
{
    mv $1 $2
    echo "Making symbolic link: $1->$2/$1"
    ln -s $2/$1 $1
}
function mvf ()
{
    mv $1 $2
    cd $2
}
function s ()
{
	ssh -Y login$1.hep.wisc.edu
}
function git-top ()
{
    ref=$(git rev-parse --show-toplevel) 2> /dev/null || return
    echo $ref
}
function resubmitJobs ()
{
     ls *rescue$1 | grep -v wrapper | xargs -n 1 -I % farmoutAnalysisJobs --rescue-dag-file=%
}
# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
 #DISABLE_AUTO_UPDATE="true"
 DISABLE_UPDATE_PROMPT="true"
# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=()

export PYTHONSTARTUP=~/.pystartup

#http://jeroenjanssens.com/2013/08/16/quickly-navigate-your-filesystem-from-the-command-line.html
export MARKPATH=$HOME/.marks
function jump { 
    cd -P $MARKPATH/$1 2>/dev/null || echo "No such mark: $1"
}
function mark { 
    mkdir -p $MARKPATH; ln -s $(pwd) $MARKPATH/$1
}
function unmark { 
    rm -i $MARKPATH/$1 
}
function marks {
    ls -l $MARKPATH | sed 's/  / /g' | cut -d' ' -f9- | sed 's/ -/\t-/g' && echo
}
# User specific aliases and functions
