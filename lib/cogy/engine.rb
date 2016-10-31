module Cogy
  class Engine < ::Rails::Engine
    isolate_namespace Cogy

    config.after_initialize do
      if Cogy.executable_path.nil?
        raise "You must set the :executable_path setting"
      end

      Cogy.command_load_paths.each do |path|
        files = Dir[Rails.root.join(path,"*.rb")]
        files.each { |f| require_relative(f) }
      end
    end
  end
end
