fpath=(~/.zsh_functions /usr/local/share/zsh-completions $fpath)

# Completion settings
autoload -Uz compinit
compinit
setopt complete_in_word
zstyle ':completion:*:default' list-colors ''

eval "$(rbenv init - zsh | grep -v export.PATH)"
function rbenv_global_exec() {
  (rbenv shell $(rbenv global); exec $*)
}
alias be='bundle exec'

setopt prompt_subst
setopt autopushd pushdminus pushdsilent pushdtohome pushdignoredups

cdpath=( ~ ~/Development ${GOPATH}/src/github.com ${GOPATH}/src/code.google.com/p )
setopt autocd

alias ls='ls -Fhe@cAO'
alias sudo='sudo -H -p "[%u@%h -> %U] Password:"'

alias vim="${EDITOR}"
alias :e="${EDITOR}"
alias :r="cat"

# Helpful tmux aliases for interacting with the system clipboard.
alias tmux-buffer-to-clipboard='tmux save-buffer -|pbcopy'
alias tmux-buffer-from-clipboard='tmux set-buffer "$(pbpaste)"'

function tmux-new-session() {
  local session_name=${1}

  if [ -z "${session_name}" ]; then
    echo "Usage: tmux-new-session <session name>"
    return 1
  fi

  if [ ! -z "${TMUX}" ]; then
    env TMUX= tmux new-session -d -s ${session_name}
    tmux switch-client -t ${session_name}
  else
    tmux new-session -s ${session_name}
  fi
}

# Use the github enhanced wrapper for git
alias git='/usr/local/bin/hub'
compdef hub=git

# Helpful git aliases
alias gs='git status --short --branch'
alias gd='git diff --color-words'
alias gdc='gd --cached'
alias glog='git log --pretty="format:%C(yellow)%h%Cblue%d%Creset %s %C(white) %an, %ar%Creset"'
alias gl='glog --graph'
alias gla='gl --all'
alias gup='gru && git rebase -p'
alias gc='git commit'
alias ga='git add --all'
alias gap='git add --all --patch'
alias gp='git push'
alias gru='git remote update --prune'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gb='git branch'
alias gba='git branch -a'
alias gf='git fetch'
alias gpr='git pull-request'

function gblame() {
  for branch in $(git branch -r); do
    echo $(git show -s --format=format:"%an ${branch/origin\//}" $branch)
  done | sort -u
}

function gblame_me() {
  gblame | grep "^Graeme Mathieson"
}

# Force the terminal to be screen rather than screen-256color when sshing into
# something else.
if [ $TERM = 'screen-256color' ]; then
  alias ssh='TERM="screen" ssh'
  alias vagrant='TERM="screen" vagrant'
fi

# Manage SSH control masters
autoload -U ssh_control_status ssh_control_exit_masters

title() {
  print -Pn "\ek$1\e\\"
}

pane_title() {
  print -Pn "\e]2;$1\e\\"
}

# Nice prompt
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git hg svn
zstyle ':vcs_info:*' stagedstr '%F{28}●%f'
zstyle ':vcs_info:*' unstagedstr '%F{11}●%f'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' get-revision true
zstyle ':vcs_info:*' formats ' %F{blue}%b%f@%F{yellow}%8<<%i%f %c%u'
zstyle ':vcs_info:*' actionformats ' %F{blue}%b|%a%f@%F{yellow}%8<<%i%f %c%u'

precmd () {
  vcs_info
  title 'zsh'
  pane_title "%~"
}

preexec () {
  local cmd=${1[(wr)^(*=*|sudo|bundle|exec|be|-*)]}
  local target=${1[(wR)^(*=*|-*)]}

  title "${cmd}"

  if [ ! -z "${target}" -a "${target}" != "${cmd}" ]; then
    if [ -e "${target}" ]; then
      pane_title ${target}(:a)
    else
      pane_title "${target}"
    fi
  fi
}

export PROMPT=$'%{\e[0;34m%}%n@%m %{\e[0;33m%}%*%{\e[0m%}
%{\e[0;%(?.32.31)m%}>%{\e[0m%} '
export RPROMPT=$'%{\e[0;33m%}%2~ %{\e[0;32m%}$(rbenv version-name)${vcs_info_msg_0_}%{\e[0m%}'

HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
setopt extendedglob notify append_history inc_append_history share_history hist_ignore_all_dups extended_history
bindkey -e

# shift-tab reverses through completions
bindkey '^[[Z' reverse-menu-complete

# Report the runtime of commands that take longer than 5 seconds.
REPORTTIME=5

# Set the word style to the bash stylee I'm familiar with.
autoload -U select-word-style
select-word-style bash
WORDCHARS=${WORDCHARS:s#/##}
zstyle ':zle:*' word-chars ${WORDCHARS}

# Shortcut for VMWare command line tools
alias vmrun="/Applications/VMware\ Fusion.app/Contents/Library/vmrun"
alias vmware-vdiskmanager="/Applications/VMware\ Fusion.app/Contents/Library/vmware-vdiskmanager"
function vm() {
  local command="${1}"
  local vm_name="${2}"
  local base_path="/Users/mathie/Documents/Virtual Machines.localized"
  local vmx_file="${base_path}/${vm_name}.vmwarevm/${vm_name}.vmx"

  if [ "${command}" = "list" ]; then
    vmrun list | sed -E -e "s#${base_path}/[^/]+/(.*).vmx\$#\1#"
  elif [ "${command}" = "available" ]; then
    ls "${base_path}" |sed -e 's/.vmwarevm\/$//'
  elif [ "${command}" = "start" ]; then
    vmrun start "${vmx_file}" nogui
  elif [ "${command}" = "stop" ]; then
    vmrun stop "${vmx_file}" hard
  elif [ "${command}" = "restart" ]; then
    vmrun reset "${vmx_file}" hard
  else
    echo "Unknown command: ${command}."
    return 1
  fi
}

# Help files
unalias run-help
autoload run-help
export HELPDIR=/usr/local/share/zsh/helpfiles

# added by travis gem
[ -f /Users/mathie/.travis/travis.sh ] && source /Users/mathie/.travis/travis.sh
