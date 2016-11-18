module Cogy
  class Engine < ::Rails::Engine
    isolate_namespace Cogy

    config.after_initialize do
      Cogy.command_load_paths.each do |path|
        files = Dir[Rails.root.join(path,"*.rb")]
        files.each { |f| Cogy.module_eval(File.read(f)) }
      end

      Context.include(Rails.application.routes.url_helpers)
    end
  end
end
