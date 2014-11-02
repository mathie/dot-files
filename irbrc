begin
  require 'rubygems'
  require 'pry'

  begin
    require 'awesome_print'
  rescue LoadError
    puts "Warning: Couldn't load awesome_print, continuing without."
  end

  Pry.start

  exit 0
rescue LoadError
  puts "Warning: Couldn't load pry, continuing without."
end
