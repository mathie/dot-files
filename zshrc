setopt autocd autopushd pushdminus pushdsilent pushdtohome pushdignoredups \
  prompt_subst extendedglob notify append_history inc_append_history \
  share_history hist_ignore_all_dups extended_history complete_in_word

fpath=(/usr/local/share/zsh-completions $fpath)
cdpath=(~ ~/Development)

eval "$(rbenv init -)"
eval "$(nodenv init -)";
. /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export PATH="bin:${PATH}"

# Set up GnuPG and its agent
export GPG_TTY=$(tty)
if [ -z "${GPG_AGENT_INFO}" -a -f "${HOME}/.gpg-agent-info" ]; then
  . "${HOME}/.gpg-agent-info"
  export GPG_AGENT_INFO SSH_AUTH_SOCK SSH_AGENT_PID
fi

if ! gpg-agent > /dev/null 2>&1; then
  eval "$(gpg-agent --daemon --enable-ssh-support --write-env-file "${HOME}/.gpg-agent-info")"
fi

# Emacs keybindings by default, which are more familiar to my macOS fingers.
bindkey -e

# Completion settings
autoload -Uz compinit
compinit
zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' group-name ''
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' matcher-list 'r:|[._-]=* r:|=*'
zstyle ':completion:*' original true
zstyle ':completion:*' use-compctl false
compdef hub=git

alias be='bundle exec'
alias ls='ls -Fhe@cAO'
alias git=hub
alias gs='git status --short --branch'
alias gd='git diff --color-words'
alias gdc='gd --cached'
alias glog='git log --pretty="format:%C(yellow)%h%Cblue%d%Creset %s %C(white) %an, %ar%Creset"'
alias gl='glog --graph'
alias gup='gru && git rebase -p'
alias gc='git commit'
alias ga='git add --all'
alias gap='git add --all --patch'
alias gp='git push'
alias gco='git checkout'
alias gb='git branch'
alias gba='git branch -a'
alias gpr='git pull-request'

osc() {
  local code="$1"
  local title="$2"

  printf "\e]%d;%s\e\\" ${code} ${title}
}

tab_title() {
  local title=$1

  osc 1 ${title}
}

window_title() {
  local title=$1

  osc 2 ${title}
}

working_directory_title() {
  local working_directory=$(file_url $1)

  osc 7 ${working_directory}
}

document_title() {
  local document=$(file_url $1)

  osc 6 ${document}
}

file_url() {
  local path=$1

  printf "file://%s%s" $(/bin/hostname) $(urlencode ${path:a})
}

urlencode() {
    setopt localoptions
    input=( ${(s::)1} )
    print ${(j::)input/(#b)([^\/A-Za-z0-9_.!~*\'\(\)-])/%$(([##16]#match))}
}

precmd() {
  vcs_info
}

chpwd() {
  working_directory_title "${PWD}"
}

preexec () {
  local cmd=${1[(wr)^(*=*|sudo|bundle|exec|be|-*)]}
  local target=${1[(wR)^(*=*|-*)]}

  tab_title "${cmd}"

  if [ ! -z "${target}" -a "${target}" != "${cmd}" -a -e "${target}" ]; then
    document_title ${target}(:a)
  fi
}

# Nice prompt
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' stagedstr '%F{28}●%f'
zstyle ':vcs_info:*' unstagedstr '%F{11}●%f'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' get-revision true
zstyle ':vcs_info:*' formats ' %F{blue}%b%f@%F{yellow}%8<<%i%f %c%u'
zstyle ':vcs_info:*' actionformats ' %F{blue}%b|%a%f@%F{yellow}%8<<%i%f %c%u'

# Set the word style to the bash stylee I'm familiar with.
autoload -U select-word-style
select-word-style bash
WORDCHARS=${WORDCHARS:s#/##}
zstyle ':zle:*' word-chars ${WORDCHARS}
