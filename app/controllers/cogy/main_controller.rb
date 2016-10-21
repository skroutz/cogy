require_dependency "cogy/application_controller"

module Cogy
  class CogyController < ApplicationController
    # GET /cmd/:cmd/:user
    def command
      cmd = params[:cmd]
      args = request.query_parameters.select { |k,_| k !~ /\Acog_opt_/ }.keys
      opts = request.query_parameters.select { |k,_| k =~ /\Acog_opt_/ }
      opts = {}.tap { |h| opts.each { |k,v| h[k.sub("cog_opt_","")] = v } }
      user = params[:user]

      render text: Cogy.commands[cmd].run!(args, opts, user)
    end

    # GET /inventory
    def inventory
      render text: Cogy.bundle_config.to_yaml
    end
  end
end
