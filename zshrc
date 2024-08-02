# Fresh start, pulled heavily from https://www.youtube.com/watch?v=ud7YxC33Z3w
# Lots of the same functionality, less bloat and easier setup.
# Assumes fzf, starship, atuin installed and configured.

export PATH=$HOME/bin:/usr/local/bin:$PATH

if [[ -f "/opt/homebrew/bin/brew" ]] then
  # If you're using macOS, you'll want this enabled
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"


#export BAT_THEME="Nord"

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Load completions
autoload -Uz compinit && compinit

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Custom aliases and function
alias ksvc='kubectl get svc'
alias krm='kubectl delete '
alias kp='kubectl get pods'
alias kl='kubectl logs -f '
alias kg='kubectl get '
alias kc='kubectl'
alias -g kxd='kubectl -n xdddev'
alias -g kx='kubectl -n xdd'
alias c='cd -p '
alias v='vim '
alias c='cd -P'
alias grep="grep --color=auto"
alias gitdiff='git --no-pager diff'
alias e='emacs -nw'
alias h='history | grep '
alias ll='ls -l'
alias ld='ll -d */'
alias cd1="cd .."
alias cd2="cd ../.."
alias cd3="cd ../../.."
alias root="root -l"
alias gap="git add -p"
alias gd="git --no-pager diff"
alias gt="git log --graph --oneline --all"
alias fzf="fzf --border sharp"


pag() {
    ag $1 | fzf --delimiter : --preview 'fzf-bat-preview {1} {2}'

}

frg() {
    rg --line-number $1 | fzf --delimiter : --preview 'fzf-bat-preview {1} {2}'

}

eval "$(fzf --zsh)"

kfzf() {
    namespace=$1
    resource=$2
    pod=$(kubectl -n $1 get $2 | fzf | awk '{print $1}')
    echo $3
    if [[ "$3" == "cp" ]]
    then
        echo $pod | pbcopy
        echo "copied $pod to clipboard"
    else
        echo $pod
    fi
}

klf() {
    namespace=$1
    resource=pod
    pod=$(kfzf $namespace $resource)
    kubectl -n $1 logs -f  $pod 
}

kex() {
    namespace=$1
    resource=pod
    pod=$(kfzf $namespace $resource)
    kubectl -n $1 exec -it $pod -- /bin/bash
}

kge() {
    namespace=$1
    resource=$2
    pod=$(kfzf $namespace $resource)
    kubectl -n $1 get $2 -o yaml $pod | bat --color always -l yaml
}

is_in_git_repo() {
  git rev-parse HEAD > /dev/null 2>&1
}

fgst() {
  # "Nothing to see here, move along"
  is_in_git_repo || return

  local cmd="${FZF_CTRL_T_COMMAND:-"command git status -s"}"

  eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" fzf -m "$@" | while read -r item; do
    echo "$item" | awk '{print $2}'
  done
  echo
}

fga() {
  # "Nothing to see here, move along"
  is_in_git_repo || return

  local cmd="${FZF_CTRL_T_COMMAND:-"command git status -s"}"

  eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" fzf -m "$@" | while read -r item; do
    echo "$item" | awk '{printf $2}' | xargs -I {} -0 git add {}
  done
  echo
}

fgd() {
  # "Nothing to see here, move along"
  is_in_git_repo || return

  local cmd="${FZF_CTRL_T_COMMAND:-"command git status -s"}"

  eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" fzf -m "$@" | while read -r item; do
    echo "$item" | awk '{printf $2}' | xargs -I {} -0 git dft {}
  done
  echo
}


fshow() {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index --toggle-sort=\` \
      --bind "ctrl-m:execute:
                echo '{}' | grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R'"
}
watchscp () {
    fswatch -0 *  | while read -d "" event;
do
    RE=".*\.(swp|swx)"
    if [[ $event =~ $RE ]]
    then
        :
    else
        rel=${event#$PWD}
        echo $rel
        scp "$event" $1:$2$rel
    fi
done
}

watchrsync () {
    fswatch -0 *  | while read -d "" event;
do
    RE=".*\.(swp|swx)"
    if [[ $event =~ $RE ]]
    then
        :
    else
        rel=${event#$PWD}
        rsync -avz . $1:$2
    fi
done
}

flog () {
     branch="$(
        git branch --sort=-committerdate --format="%(committerdate:relative)%09%(refname:short)%09%(subject)" \
        | column -ts $'\t' \
        | fzf \
        | sed -E 's/.*ago +([^ ]*) .*/\1/'
      )"
     echo $branch
     git checkout $branch || (
      echo -n "git co $branch" | pbcopy
     )
}

function mkd ()
{
    mkdir $1
    cd $1
}

# Load the externals last
eval "$(atuin init zsh)"
eval "$(starship init zsh)"
