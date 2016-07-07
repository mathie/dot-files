# Defaults for Perl
export PERL_LOCAL_LIB_ROOT="${HOME}/.perl5";
export PERL_MB_OPT="--install_base ${PERL_LOCAL_LIB_ROOT}";
export PERL_MM_OPT="INSTALL_BASE=${PERL_LOCAL_LIB_ROOT}";
export PERL5LIB="${PERL_LOCAL_LIB_ROOT}/lib/perl5/darwin-thread-multi-2level:${PERL_LOCAL_LIB_ROOT}/lib/perl5";

# Defaults for Go
export GOPATH="${HOME}/Development/Go"

export PAGER='less'
export LESS='-iMRsS~'

# Use Vim as the default editor.
export EDITOR="vim"

export CLICOLOR=true

# Install Homebrew casks into /Applications
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

export GPG_TTY=$(tty)

# Fastlane seems to be getting a bit upset about my Keychain database ending in
# `-db` which is entirely understandable.
export CERT_KEYCHAIN_PATH=${HOME}/Library/Keychains/login.keychain-db
