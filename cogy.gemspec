$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "cogy/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "cogy"
  s.version     = Cogy::VERSION
  s.authors     = ["Agis Anastasopoulos"]
  s.email       = ["agis@skroutz.gr"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Cogy."
  s.description = "TODO: Description of Cogy."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.7.1"

  s.add_development_dependency "sqlite3"
end
