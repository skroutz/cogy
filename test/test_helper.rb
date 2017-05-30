ENV["RAILS_ENV"] = "test"

require "#{ENV['COGY_DUMMY_APP_PATH']}/config/environment.rb"
require "rails/test_help"
require "minitest/spec"
require "byebug"

require "minitest/reporters"
# Standard minitest reporter but with red/green colors
Minitest::Reporters.use!(Minitest::Reporters::DefaultReporter.new)

# Filter out Minitest backtrace while allowing backtrace from other libraries
# to be shown.
Minitest.backtrace_filter = Minitest::BacktraceFilter.new

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }
