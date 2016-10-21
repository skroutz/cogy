module Cogy
  class Engine < ::Rails::Engine
    isolate_namespace Cogy

    config.after_initialize do
      if Cogy.executable_path.nil?
        raise "You must set the :executable_path setting"
      end
    end
  end
end
