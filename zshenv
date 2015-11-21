# Defaults for Perl
export PERL_LOCAL_LIB_ROOT="${HOME}/.perl5";
export PERL_MB_OPT="--install_base ${PERL_LOCAL_LIB_ROOT}";
export PERL_MM_OPT="INSTALL_BASE=${PERL_LOCAL_LIB_ROOT}";
export PERL5LIB="${PERL_LOCAL_LIB_ROOT}/lib/perl5/darwin-thread-multi-2level:${PERL_LOCAL_LIB_ROOT}/lib/perl5";

# Defaults for Go
export GOPATH="${HOME}/Development/Go"

export PATH="bin:${HOME}/bin:/usr/local/heroku/bin:${HOME}/.rbenv/bin:${HOME}/.rbenv/shims:${GOPATH}/bin:/usr/local/opt/go/libexec/bin:${PERL_LOCAL_LIB_ROOT}/bin:/usr/local/bin:/usr/local/sbin:/usr/local/share/npm/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin"

export PAGER='less'
export LESS='-iMRsS~'
export NODE_PATH="/usr/local/lib/node_modules"

# Use Vim as the default editor.
export EDITOR="vim"
