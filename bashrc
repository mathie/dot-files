source ~/.zshenv

if [ -x "$(which rbenv)" ]; then
  eval "$(rbenv init - | grep -v export.PATH)"
fi

# added by travis gem
[ -f /Users/mathie/.travis/travis.sh ] && source /Users/mathie/.travis/travis.sh
