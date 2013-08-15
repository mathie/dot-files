begin
  require 'rubygems'
  require 'pry'

  begin
    require 'awesome_print'
  rescue LoadError => e
    puts "Warning: Couldn't load awesome_print, continuing without: #{e.message}"
  end

  Pry.start

  exit 0
rescue LoadError => e
  puts "Warning: Couldn't load pry, continuing without: #{e.message}"
end
