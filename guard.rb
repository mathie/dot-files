clearing :on

notification :gntp, host: '127.0.0.1'

guard :shell do
  watch(%r{^(?:app|lib)/.+\.rb$}) { system './.git/hooks/ctags' }
end
