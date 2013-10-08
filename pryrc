# vim: ft=ruby

Pry.config.editor = proc { |file, line| "vim +#{line} #{file}" }
Pry.config.prompt_name = File.basename(Dir.pwd)

Pry.prompt = [ 0, 1 ].map do |i|
  ruby_engine = Object.const_defined?(:RUBY_ENGINE) ? RUBY_ENGINE : 'ruby'
  proc { |target_self, nest_level, pry|
    "(#{ruby_engine}-#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}) #{Pry::DEFAULT_PROMPT[i].call(target_self, nest_level, pry)}"
  }
end

begin
  require 'awesome_print'
  Pry.config.print = proc {|output, value| Pry::Helpers::BaseHelpers.stagger_output("=> #{value.ai}", output)}
rescue LoadError => e
  puts "Warning: awesome_print not installed."
end
