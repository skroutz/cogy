require "capistrano/version"

if defined?(Capistrano::VERSION) && Gem::Version.new(Capistrano::VERSION).release >= Gem::Version.new('3.0.0')
  puts "Loading v3"
  load File.expand_path("../capistrano/v3/cogy.rake", __FILE__)
else
  puts "loading v2"
  #require 'cogy/capistrano/v2/hooks'
end
