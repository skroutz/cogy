module Cogy
  module Generators
    class ConfigGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      desc <<DESC
Description:
    Copies Cogy configuration file to your application"s initializer directory.
DESC
      def copy_config_file
        template "cogy_config.rb", "config/initializers/cogy.rb"
      end
    end
  end
end
