export PATH="/Users/mathie/bin:/Users/mathie/.homebrew/bin:/Users/mathie/.homebrew/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/X11/bin"

. ~/.rvm/scripts/rvm

# Shortcut some paths
rvm=${HOME}/.rvm
: ~rvm
homebrew=${HOME}/.homebrew
: ~homebrew

setopt prompt_subst
setopt hist_ignore_dups
setopt autopushd pushdminus pushdsilent pushdtohome pushdignoredups

cdpath=( ~ ~/Development )
setopt autocd

alias ls='ls -Fh'
alias sudo='sudo -H -p "[%u@%h -> %U] Password:"'

# Use MacVim (though the reattach wrapper).
export EDITOR=${HOME}/bin/vim
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
alias gp='git push'
alias gru='git remote update --prune'

function gblame() {
  for branch in $(git branch -r); do
    echo $(git show -s --format=format:"%an ${branch/origin\//}" $branch)
  done | sort -u
}

function gblame_me() {
  gblame | grep "^Graeme Mathieson"
}

# Shortcuts for various remote Rails consoles
alias fa-production-console='ssh -t deploy@console.freeagentcentral.net "(cd current && bundle exec rails console production)"'
alias fa-staging-console='ssh -t deploy@web1.staging "(cd current && bundle exec rails console staging)"'

# Force the terminal to be screen rather than screen-256color when sshing into
# something else.
if [ $TERM = 'screen-256color' ]; then
  alias ssh='TERM="screen" ssh'
fi

# Nice prompt
export PROMPT=$'%{\e[0;90m%}%n@%m %*%{\e[0m%}
%{\e[0;%(?.32.31)m%}>%{\e[0m%} '
export RPROMPT=$'%{\e[0;90m%}%c $(rvm-prompt i v)$(git_cwd_info)%{\e[0m%}'

HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
setopt extendedglob notify
setopt append_history
setopt inc_append_history
bindkey -e

autoload -Uz compinit
compinit
setopt complete_in_word

