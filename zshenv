export PERL_LOCAL_LIB_ROOT="${HOME}/.perl5";
export PERL_MB_OPT="--install_base ${PERL_LOCAL_LIB_ROOT}";
export PERL_MM_OPT="INSTALL_BASE=${PERL_LOCAL_LIB_ROOT}";
export PERL5LIB="${PERL_LOCAL_LIB_ROOT}/lib/perl5/darwin-thread-multi-2level:${PERL_LOCAL_LIB_ROOT}/lib/perl5";
export PATH="bin:${HOME}/bin:${HOME}/.rbenv/bin:${HOME}/.rbenv/shims:${PERL_LOCAL_LIB_ROOT}/bin:/usr/local/bin:/usr/local/sbin:/usr/local/share/npm/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin"
export JAVA_HOME=$(/usr/libexec/java_home)
export EC2_HOME="/usr/local/Library/LinkedKegs/ec2-api-tools/jars"
export PAGER='less'
export LESS='-iMRsS~'
export NODE_PATH="/usr/local/lib/node_modules"

# Use MacVim (though the reattach wrapper).
export EDITOR=${HOME}/bin/vim
export CLICOLOR=true

export SBT_OPTS='-XX:MaxPermSize=256M'
