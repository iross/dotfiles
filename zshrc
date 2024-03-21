# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$PATH/$HOME/bin:/usr/local/bin
export PATH=`python3 -m site --user-base`/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="iar"

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
alias ddd="ssh -L 8080:127.0.0.1:8000 iaross@deepdivesubmit.chtc.wisc.edu"
alias fzf="fzf --border sharp"

alias ats='atuin search --format "{command} -- (@{host}) {time} - {duration} ({exit})" '

watchscp () {
    fswatch -0 *  | while read -d "" event;
do
    RE=".*\.(swp|swx)"
    if [[ $event =~ $RE ]]
    then
        :
    else
        rel=${event#$PWD}
        scp "$event" $1:$2$rel
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
function td()
{
    task done $1
    ts $1
}
function ts()
{
    _end=$(task $1 _unique end)
    echo $_end
    if [ -n "$_end" ]; then
        _end=$(date -r $_end)
        desc=$(task $1 _unique description)
        estimate=$(task $1 _unique estimate)
        echo Time summary for \"$desc\" copied to clipboard.
        echo "## Time Summary \n \`\`\` \n Completed $_end\n $(timew summary $desc :all )\nEstimate: $estimate\n\`\`\`" | pbcopy
    else
        echo "Task not complete. Cannot summarize."
        return 1
    fi
}
function ta()
{
    task +ACTIVE
    task +ACTIVE _uuid | tr -d '\n'| pbcopy
}

function tn()
{
    desc=$(task +ACTIVE _unique description)
    uuid=$(task +ACTIVE _unique uuid)
    proj=$(task +ACTIVE _unique project)
    tags=$(task +ACTIVE _unique tags)
    estimate=$(task +ACTIVE _unique estimate)
    annotations=$(task +ACTIVE export |  jq --arg prefix 'DUMMY' '.[].annotations[] | {entry, description} | join(" - ")'  | sed 's/^/- /' | tr -d \")
    if echo $tags | grep -q "work"
    then
        filename=$(echo "$desc" | tr '/' _)
        note_path="/Users/iaross/sync/obsidian/Work/tasks/${filename}.md"
        echo $filename
        echo $note_path
        if [ ! -f $note_path ]
        then
            echo "---" >> $note_path
            echo "tw_uuid: $uuid" >> $note_path
            echo "tw_project: $proj" >> $note_path
            echo "tw_estimate: $estmagte" >> $note_path
            echo "tw_tags: $tags" >> $note_path
            echo "tw_annotations:\n$annotations" >> $note_path
            echo "---" >> $note_path
        else
            echo "File exists!"
        fi
        url="obsidian://open?vault=obsidian&file=Work%2Ftasks%2F${filename}"
        open $url
        echo $annotations | pbcopy
    else
        echo $annotations| pbcopy
    fi
}

function st()
{
    task start $1
}

function gstage()
{
    git tag -d staging
    git push origin :refs/tags/staging
    git tag staging
    git push origin --tags
}
function ds()
{
    docker exec -it $1 /bin/bash
}

function ks()
{
    kubectl exec -it $1 /bin/bash
}


function nn()
{
    DATE=`date +%Y%b%d`
    touch /Users/iross/Google\ Drive/notes/notes/$DATE.md
    /Users/iross/bin/vim /Users/iross/Google\ Drive/notes/notes/$DATE.md
}

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
function gstage ()
{
    git tag -d staging;
    git push origin :refs/tags/staging
    git tag staging
    echo git push origin --tags
}
#function gs ()
#{
#    ack -l todo $(git rev-parse --show-toplevel)/* > $(git rev-parse --show-toplevel)/.todo
#    git status
#}
# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

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
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  fzf-tab
  git
  zsh-syntax-highlighting
  zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh
setopt CSH_NULL_GLOB
unsetopt correct_all

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

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
export PYTHONSTARTUP=~/.pystartup
export PATH="/usr/local/opt/postgresql@9.6/bin:$PATH"

select_items_command="todoist --namespace --project-namespace list | peco | cut -d ' ' -f 1 | tr '\n' ' '"

function insert-in-buffer () {
    if [ -n "$1" ]; then
        local new_left=""
        if [ -n "$LBUFFER" ]; then
            new_left="${new_left}${LBUFFER} "
        fi
        if [ -n "$2" ]; then
            new_left="${new_left}${2} "
        fi
        new_left="${new_left}$1"
        BUFFER=${new_left}${RBUFFER}
        CURSOR=${#new_left}
    fi
}

# todoist find item
function peco-todoist-item () {
    local SELECTED_ITEMS="$(eval ${select_items_command})"
    insert-in-buffer $SELECTED_ITEMS
}
zle -N peco-todoist-item
bindkey "^xtt" peco-todoist-item

# todoist find project
function peco-todoist-project () {
    local SELECTED_PROJECT="$(todoist --project-namespace projects | peco | head -n1 | cut -d ' ' -f 1)"
    insert-in-buffer "${SELECTED_PROJECT}" "-P"
}
zle -N peco-todoist-project
bindkey "^xtp" peco-todoist-project

# todoist find labels
function peco-todoist-labels () {
    local SELECTED_LABELS="$(todoist labels | peco | cut -d ' ' -f 1 | tr '\n' ',' | sed -e 's/,$//')"
    insert-in-buffer "${SELECTED_LABELS}" "-L"
}
zle -N peco-todoist-labels
bindkey "^xtl" peco-todoist-labels

# todoist select date
function peco-todoist-date () {
    date -v 1d &>/dev/null
    if [ $? -eq 0 ]; then
        # BSD date option
        OPTION="-v+#d"
    else
        # GNU date option
        OPTION="-d # day"
    fi

    local SELECTED_DATE="$(seq 0 30 | xargs -I# date $OPTION '+%d/%m/%Y %a' | peco | cut -d ' ' -f 1)"
    insert-in-buffer "'${SELECTED_DATE}'" "-d"
}
zle -N peco-todoist-date
bindkey "^xtd" peco-todoist-date

function todoist-exec-with-select-task () {
    if [ -n "$2" ]; then
        BUFFER="todoist $1 $(echo "$2" | tr '\n' ' ')"
        CURSOR=$#BUFFER
        zle accept-line
    fi
}

# todoist close
function peco-todoist-close() {
    local SELECTED_ITEMS="$(eval ${select_items_command})"
    todoist-exec-with-select-task close $SELECTED_ITEMS
}
zle -N peco-todoist-close
bindkey "^xtc" peco-todoist-close

# todoist delete
function peco-todoist-delete() {
    local SELECTED_ITEMS="$(eval ${select_items_command})"
    todoist-exec-with-select-task delete $SELECTED_ITEMS
}
zle -N peco-todoist-delete
bindkey "^xtk" peco-todoist-delete

# todoist open
function peco-todoist-open() {
    local SELECTED_ITEMS="$(eval ${select_items_command})"
    todoist-exec-with-select-task "show --browse" $SELECTED_ITEMS
}
zle -N peco-todoist-open
bindkey "^xto" peco-todoist-open

bindkey -v
export KEYTIMEOUT=1


if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/iaross/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)


source /Users/iaross/.config/broot/launcher/bash/br

eval "$(atuin init zsh)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

eval "$(starship init zsh)"
