module Cogy
  class Engine < ::Rails::Engine
    isolate_namespace Cogy

    config.after_initialize do
      if Cogy.bundle_version.nil?
        raise "You must set the :bundle_version setting"
      end

      if Cogy.executable_path.nil?
        raise "You must set the :executable_path setting"
      end

      Cogy.command_load_paths.each do |path|
        files = Dir[Rails.root.join(path,"*.rb")]
        files.each { |f| Cogy.module_eval(File.read(f)) }
      end
    end
  end
end
