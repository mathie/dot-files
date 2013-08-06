fpath=(~/.zsh_functions ~/.zsh_functions/Completion $fpath)

homebrew=/usr/local
: ~homebrew

# Completion settings
autoload -Uz compinit
compinit
setopt complete_in_word
zstyle ':completion:*:default' list-colors ''

eval "$(rbenv init - | grep -v export.PATH)"
function rbenv_global_exec() {
  (rbenv shell $(rbenv global); exec $*)
}
alias be='bundle exec'

setopt prompt_subst
setopt autopushd pushdminus pushdsilent pushdtohome pushdignoredups

cdpath=( ~ ~/Development )
setopt autocd

alias ls='ls -Fh'
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

# tmux helper
alias mux='tmuxinator'
compctl -g '~/.tmuxinator/*(:t:r)' tmuxinator
for i in ~/.tmuxinator/*(:t:r); do
  alias ${i}="rbenv_global_exec tmuxinator ${i}"
done

# Use the github enhanced wrapper for git
alias git='/usr/local/bin/hub'
compdef hub=git

# Helpful git aliases
alias gs='git status --short --branch'
alias gd='git diff'
alias gdc='git diff --cached'
alias glog='git log --pretty="format:%C(yellow)%h%Cblue%d%Creset %s %C(white) %an, %ar%Creset"'
alias gl='glog --graph'
alias gla='gl --all'
alias gup='rbenv_global_exec git smart-pull'
alias gc='git commit'
alias ga='git add'
alias gap='git add --patch'
alias gp='git push'
alias gru='git remote update --prune'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gb='git branch'
alias gba='git branch -a'

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

# Nice prompt
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git hg svn
zstyle ':vcs_info:*' stagedstr '%F{28}●%f'
zstyle ':vcs_info:*' unstagedstr '%F{11}●%f'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' get-revision true
zstyle ':vcs_info:*' formats ' %F{blue}%b%f@%F{yellow}%8<<%i%f %c%u'
zstyle ':vcs_info:*' actionformats ' %F{blue}%b|%a%f@%F{yellow}%8<<%i%f %c%u'
precmd () { vcs_info }
export PROMPT=$'%{\e[0;90m%}%n@%m %*%{\e[0m%}
%{\e[0;%(?.32.31)m%}>%{\e[0m%} '
export RPROMPT=$'%{\e[0;90m%}%2~ $(rbenv version-name)${vcs_info_msg_0_}%{\e[0m%}'

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

# Amazon EC2 configuration
function ec2-set-role() {
  export EC2_PRIVATE_KEY="${HOME}/.ec2/${1}-pk.pem"
  export EC2_CERT="${HOME}/.ec2/${1}-cert.pem"

  if [ ! -f ${EC2_PRIVATE_KEY} -o ! -f ${EC2_CERT} ]; then
    echo "Certificate or private key for ${1} missing!"
    unset EC2_PRIVATE_KEY EC2_CERT
    return 1
  fi

  if [ -f ${HOME}/.ec2/${1}-default-region ]; then
    export EC2_URL="https://ec2.$(cat ${HOME}/.ec2/${1}-default-region).amazonaws.com"
  else
    unset EC2_URL
  fi
}
ec2-set-role rubaidh

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
