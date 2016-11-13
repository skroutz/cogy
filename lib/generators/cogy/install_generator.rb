module Cogy
  module Generators
    class Install < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      desc <<DESC
Description:
    Mount the engine, create a sample command and add a configuration file
DESC

      def run_config_generator
        generate "cogy:config"
      end

      def copy_sample_command_and_readme
        template 'command_file.rb', 'cogy/general.rb'
        template 'cogy_folder_readme.md', 'cogy/README.md'
      end

      def mount_engine
        route 'mount Cogy::Engine, at: "/cogy"'
      end
    end
  end
end
