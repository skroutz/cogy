require_dependency "cogy/application_controller"

module Cogy
  class CogyController < ApplicationController
    # GET /cmd/:cmd/:user
    def command
      cmd = params[:cmd]
      args = request.query_parameters.select { |k,_| k !~ /\Acog_opt_/ }.values
      opts = request.query_parameters.select { |k,_| k =~ /\Acog_opt_/ }
        .transform_keys { |k| k.sub("cog_opt_", "") }
      user = params[:user]

      render text: Cogy.commands[cmd].run!(args, opts, user)
    end

    # GET /inventory
    def inventory
      render text: Cogy.bundle_config.to_yaml
    end
  end
end
