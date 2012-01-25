export PATH="/Users/mathie/bin:/Users/mathie/.homebrew/bin:/Users/mathie/.homebrew/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/X11/bin"

. ~/.rvm/scripts/rvm

setopt prompt_subst
setopt hist_ignore_dups

alias ls='ls -Fh'
alias sudo='sudo -H -p "[%u@%h -> %U] Password:"'

# Use MacVim
export EDITOR=/Applications/MacVim.app/Contents/MacOS/vim
alias vim="${EDITOR}"

# Dayone command line tool
alias dayone="/Applications/Day\ One.app/Contents/MacOS/dayone"

# Helpful git aliases
alias gs='git status --short --branch'
alias gd='git diff'
alias gdc='git diff --cached'
alias glog='git log --pretty="format:%C(yellow)%h%Cblue%d%Creset %s %C(white) %an, %ar%Creset"'
alias gl='glog --graph'
alias gla='gl --all'
alias gup='git smart-pull'
alias gc='git commit'
alias ga='git add'
alias gap='git add --patch'

export PROMPT=$'%{\e[0;90m%}%n@%m %*%{\e[0m%}
%{\e[0;%(?.32.31)m%}>%{\e[0m%} '
export RPROMPT=$'%{\e[0;90m%}%c $(rvm-prompt i v)$(git_cwd_info)%{\e[0m%}'

HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
setopt extendedglob notify
setopt append_history
setopt inc_append_history
unsetopt autocd
bindkey -e

autoload -Uz compinit
compinit
setopt complete_in_word

