require "pathname"

module Cogy
  class Engine < ::Rails::Engine
    isolate_namespace Cogy

    config.after_initialize do
      Cogy.command_load_paths.each do |path|
        # Add commands
        files = Dir[Rails.root.join(path, "*.rb")]
        files.each { |f| Cogy.module_eval(File.read(f)) }

        # Add templates
        templates = Dir[Rails.root.join(path, "templates", "*")]
                    .select { |f| File.file?(f) }

        templates.each do |t|
          fname = Pathname(t).basename.to_s
          Cogy.templates[fname] = { "body" => File.read(t).strip }
        end
      end

      Context.include(Rails.application.routes.url_helpers)
    end
  end
end
