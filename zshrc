# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

#use rvm for ruby management. I really need to set up clean installs of ruby/python...
source /Users/iross/.rvm/scripts/rvm

# todo: clean up this junk IAR 17.Aug.2013
export ROOTSYS=/usr/local
export PATH=/usr/local/bin/:$PATH:$ROOTSYS/bin:/sw/bin/
export PATH=/Applications/Octave.app/Contents/Resources/bin:$PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ROOTSYS/lib
export PYTHONDIR=$PYTHONDIR:/opt/local/Library/Frameworks/Python.framework/Versions/2.7/
export PYTHONPATH=$PYTHONPATH:$ROOTSYS/lib/root

export PATH=/Library/Frameworks/Python.framework/Versions/Current/bin/:$PATH

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="custom"

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
function gs ()
{
    ack -l todo $(git rev-parse --show-toplevel)/* > $(git rev-parse --show-toplevel)/.todo
    git status
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

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
#
bindkey "^R" history-incremental-search-backward
bindkey "^E" end-of-line
bindkey "^A" beginning-of-line
export PYTHONSTARTUP=~/.pystartup

# This keeps the number of todos always available the right hand side of my
# command line. I filter it to only count those tagged as "+next", so it's more
# of a motivation to clear out the list.
todo_count(){
  if $(which todo &> /dev/null)
  then
    num=$(echo $(todo list $1 | wc -l))
    let todos=num-2
    if [ $todos != 0 ]
    then
      echo "$todos"
    else
      echo ""
    fi
  else
    echo ""
  fi
}

function todo_prompt() {
  local COUNT=$(todo_count $1);
  if [ $COUNT != 0 ]; then
    echo "$1: $COUNT";
  else
    echo "";
  fi
}

function notes_count() {
  if [[ -z $1 ]]; then
    local NOTES_PATTERN="TODO|FIXME|HACK";
  else
    local NOTES_PATTERN=$1;
  fi
  grep -ERn "\b($NOTES_PATTERN)\b" {app,config,lib,spec,test} 2>/dev/null | wc -l | sed 's/ //g'
}

function notes_prompt() {
  local COUNT=$(notes_count $1);
  if [ $COUNT != 0 ]; then
    echo "$1: $COUNT";
  else
    echo "";
  fi
}

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
