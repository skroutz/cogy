$:.push File.expand_path("../lib", __FILE__)

require "cogy/version"

Gem::Specification.new do |s|
  s.name        = "cogy"
  s.version     = Cogy::VERSION
  s.authors     = ["Agis Anastasopoulos"]
  s.email       = ["agis.anast@gmail.com"]
  s.homepage    = "https://github.com/skroutz/cogy"
  s.summary     = "Easily manage Cog commands from your Rails apps"
  s.description = "Cogy makes writing and maintaining Cog commands in Rails " \
    "a breeze"
  s.license     = "MIT"

  s.files = Dir["{app,config,lib}/**/*", "LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2", ">= 4.2.7.1"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "pry-byebug"
  s.add_development_dependency "minitest-reporters"
  s.add_development_dependency "yard"
end
