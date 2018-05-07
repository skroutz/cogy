require "capistrano/version"

if defined?(Capistrano::VERSION) && Gem::Version.new(Capistrano::VERSION).release >= Gem::Version.new("3.0.0")
  load File.expand_path("capistrano/cogy.rake", __dir__)
else
  Capistrano::Configuration.instance(:must_exist).load do
    _cset(:cogy_release_trigger_url) { nil }
    _cset(:cogy_endpoint)            { nil }
    _cset(:cogy_trigger_timeout)     { nil }

    load File.expand_path("capistrano/cogy.rake", __dir__)
  end
end
