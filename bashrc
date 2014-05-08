source ~/.zshenv

eval "$(rbenv init - | grep -v export.PATH)"

# added by travis gem
[ -f /Users/mathie/.travis/travis.sh ] && source /Users/mathie/.travis/travis.sh
