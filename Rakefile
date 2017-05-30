begin
  require "bundler/setup"
rescue LoadError
  puts "You must `gem install bundler` and `bundle install` to run rake tasks"
end

gemfile_name = File.basename(ENV["BUNDLE_GEMFILE"], ".gemfile")
rails_version = gemfile_name == "Gemfile" ? "5.1" : gemfile_name
ENV["COGY_DUMMY_APP_PATH"] = File.expand_path("../test/dummies/#{rails_version}", __FILE__)

APP_RAKEFILE = "#{ENV['COGY_DUMMY_APP_PATH']}/Rakefile".freeze
load "rails/tasks/engine.rake"
load "rails/tasks/statistics.rake"

Bundler::GemHelper.install_tasks

require "rake/testtask"
Rake::TestTask.new(:test) do |t|
  t.libs << "lib"
  t.libs << "test"
  t.pattern = "test/**/*_test.rb"
  t.verbose = false
end

require "yard"
YARD::Rake::YardocTask.new do |t|
  t.files   = ["app/**/*.rb", "config/**/*.rb", "lib/**/*.rb"]
end

require "rubocop/rake_task"
RuboCop::RakeTask.new

task default: [:test, :rubocop]
