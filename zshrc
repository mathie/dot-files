export PATH="${HOME}/bin:${HOME}/.rbenv/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin"
fpath=(~/.zsh_functions ~/.zsh_functions/Completion $fpath)

export JAVA_HOME=$(/usr/libexec/java_home)

homebrew=/usr/local
: ~homebrew

eval "$(rbenv init -)"
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

export PAGER='less'
export LESS='-iMRsS~'

# Use MacVim (though the reattach wrapper).
export EDITOR=${HOME}/bin/vim
alias vim="${EDITOR}"

# Dayone command line tool
alias dayone="/Applications/Day\ One.app/Contents/MacOS/dayone"

# Helpful tmux aliases for interacting with the system clipboard.
alias tmux-buffer-to-clipboard='tmux save-buffer -|pbcopy'
alias tmux-buffer-from-clipboard='tmux set-buffer "$(pbpaste)"'

# tmux helper
alias mux='tmuxinator'
compctl -g '~/.tmuxinator/*(:t:r)' tmuxinator
for i in ~/.tmuxinator/*(:t:r); do
  alias ${i}="rbenv_global_exec tmuxinator ${i}"
done

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
alias ewgeco-production-console='ssh -t ewgeco@scapa.rubaidh.com "(cd /u/apps/ewgeco/current && script/console production)"'

function fa-puppet-agent() {
  local certname

  if [ $HOST = "mathie-old-imac.local" ]; then
    certname="blake.admin"
  elif [ $HOST = "Arabica.local" ]; then
    certname="mathie-mba.admin"
  else
    echo "Sorry, I don't know what certname to use."
    return 1
  fi
  puppet agent --test --verbose --certname ${certname} --server puppet.freeagentcentral.net

  # Work around a wee bug in the puppet config that sets the puppetmaster's
  # hostname to something unreachable.
  local tmpfile=$(mktemp -t hosts-without-puppet)
  awk '!/puppet.freeagentcentral.net/ { print }' < /etc/hosts > ${tmpfile}
  cat ${tmpfile} > /etc/hosts
  rm -f ${tmpfile}
}

alias fa-logs='ES_BASE=http://node2.ovh.elasticsearch:9200/ rbenv_global_exec ~/bin/fa-logs'

# Force the terminal to be screen rather than screen-256color when sshing into
# something else.
if [ $TERM = 'screen-256color' ]; then
  alias ssh='TERM="screen" ssh'
  alias vagrant='TERM="screen" vagrant'
fi

# Nice prompt
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git hg svn
zstyle ':vcs_info:*' stagedstr '%F{28}●%f'
zstyle ':vcs_info:*' unstagedstr '%F{11}●%f'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' get-revision true
zstyle ':vcs_info:*' formats ' %F{blue}%b%f@%F{yellow}%8<<%i%f %c%u'
precmd () { vcs_info }
export PROMPT=$'%{\e[0;90m%}%n@%m %*%{\e[0m%}
%{\e[0;%(?.32.31)m%}>%{\e[0m%} '
export RPROMPT=$'%{\e[0;90m%}%c $(rbenv version-name)${vcs_info_msg_0_}%{\e[0m%}'

HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
setopt extendedglob notify append_history inc_append_history share_history hist_ignore_all_dups extended_history
bindkey -e

# Completion settings
autoload -Uz compinit
compinit
setopt complete_in_word

# Report the runtime of commands that take longer than 5 seconds.
REPORTTIME=5

# Set the word style to the bash stylee I'm familiar with.
autoload -U select-word-style
select-word-style bash
zstyle ':zle:*' word-chars ${WORDCHARS}

# Amazon EC2 configuration
export EC2_HOME="/usr/local/Cellar/ec2-api-tools/1.5.2.5/jars"
function ec2-set-role() {
  export EC2_PRIVATE_KEY="${HOME}/.ec2/${1}-pk.pem"
  export EC2_CERT="${HOME}/.ec2/${1}-cert.pem"

  if [ ! -f ${EC2_PRIVATE_KEY} -o ! -f ${EC2_CERT} ]; then
    echo "Certificate or private key for ${1} missing!"
    unset EC2_PRIVATE_KEY EC2_CERT
    return 1
  fi
}
ec2-set-role rubaidh

# For the FreeAgent parallel runner, set the worker count to the number of CPU threads available.
export WORKER_COUNT=$(sysctl -n hw.activecpu)
