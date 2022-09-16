$LOAD_PATH.push File.expand_path("../lib", __FILE__)

require "cogy/version"

Gem::Specification.new do |s|
  s.name        = "cogy"
  s.version     = Cogy::VERSION
  s.authors     = ["Agis Anastasopoulos"]
  s.email       = ["agis.anast@gmail.com"]
  s.homepage    = "https://github.com/skroutz/cogy"
  s.summary     = "Develop & deploy Cog commands from your Rails app"
  s.description = "Cogy integrates Cog with Rails in a way that writing " \
    "and deploying commands from your application is a breeze."
  s.license     = "MIT"

  s.files = Dir["{app,config,lib}/**/*", "CHANGELOG.md", "LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 6.1", "< 8"

  s.add_development_dependency "appraisal"
  s.add_development_dependency "minitest-reporters"
  s.add_development_dependency "pry-byebug"
  s.add_development_dependency "rubocop", "~> 0.55.0"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "yard"
end
