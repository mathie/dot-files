export EDITOR="/usr/local/bin/atom -w"
export PAGER="less"
export LESS='-iMRsS~'
export CLICOLOR=true

export PROMPT=$'%{\e[0;34m%}%n@%m %{\e[0;33m%}%*%{\e[0m%}
%{\e[0;%(?.32.31)m%}>%{\e[0m%} '
export RPROMPT=$'%{\e[0;33m%}%2~ ${vcs_info_msg_0_}%{\e[0m%}'

export HISTFILE=~/.zsh_history
export HISTSIZE=1000000
export SAVEHIST=1000000
export REPORTTIME=5
