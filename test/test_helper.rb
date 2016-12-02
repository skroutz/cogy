ENV["RAILS_ENV"] = "test"

require File.expand_path("../../test/dummy/config/environment.rb", __FILE__)
require "rails/test_help"
require "minitest/spec"

require "minitest/reporters"
# Standard minitest reporter but with red/green colors
Minitest::Reporters.use!(Minitest::Reporters::DefaultReporter.new)

# Filter out Minitest backtrace while allowing backtrace from other libraries
# to be shown.
Minitest.backtrace_filter = Minitest::BacktraceFilter.new

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }
