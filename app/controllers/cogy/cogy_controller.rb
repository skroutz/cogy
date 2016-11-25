require_dependency "cogy/application_controller"

module Cogy
  class CogyController < ApplicationController
    # GET <mount_path>/cmd/:cmd/:user
    #
    # The command endpoint is the one that the cogy executable (see
    # https://github.com/skroutz/cogy-bundle hits. It executes the requested
    # {Command} and responds back the result, which is then printed to the user
    # by the cogy executable.
    #
    # See https://github.com/skroutz/cogy-bundle.
    def command
      cmd = params[:cmd]
      args = request.query_parameters.select { |k, _| k.start_with?("cog_argv_") }
                    .sort_by { |k, _| k.match(/\d+\z/)[0] }.to_h.values

      opts = request.query_parameters.select { |k, _| k.start_with?("cog_opt_") }
                    .transform_keys { |k| k.sub("cog_opt_", "") }
      cogy_env = request.query_parameters.select { |k, _| k.start_with?("cogy_") }
      user = params[:user]

      begin
        if (command = Cogy.commands[cmd])
          context = Context.new(command, args, opts, user, cogy_env)
          render text: context.run!
        else
          render status: 404, text: "The command '#{cmd}' does not exist."
        end
      rescue => e
        @user = user
        @cmd = cmd
        @exception = e
        respond_to do |format|
          format.any do
            render "/cogy/error.text.erb", content_type: "text/plain", status: 500
          end
        end
      end
    end

    # GET <mount_path>/inventory
    #
    # The inventory endpoint, is essentially the bundle config in YAML format,
    # which is installable by Cog. It is typically installed by the
    # `cogy:install` command (see https://github.com/skroutz/cogy-bundle).
    def inventory
      render text: Cogy.bundle_config.to_yaml, content_type: "application/x-yaml"
    end
  end
end
