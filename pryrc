Pry.config.editor = proc { |file, line| "vim +#{line} #{file}" }

Pry.prompt = [
  proc { |target_self, nest_level, pry|
    "(#{RUBY_ENGINE}-#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}) [#{pry.input_array.size}] pry(#{Pry.view_clip(target_self)})#{":#{nest_level}" unless nest_level.zero?}> "
  },

  proc { |target_self, nest_level, pry|
    "(#{RUBY_ENGINE}-#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}) [#{pry.input_array.size}] pry(#{Pry.view_clip(target_self)})#{":#{nest_level}" unless nest_level.zero?}* "
  }
]

begin
  require 'awesome_print'
  Pry.config.print = proc {|output, value| Pry::Helpers::BaseHelpers.stagger_output("=> #{value.ai}", output)}
rescue LoadError => e
  puts "Warning: awesome_print not installed."
end
