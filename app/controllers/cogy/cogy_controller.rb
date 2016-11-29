require_dependency "cogy/application_controller"

module Cogy
  class CogyController < ApplicationController
    # POST <mount_path>/cmd/:cmd/:user
    #
    # The command endpoint is the one that the cogy executable (see
    # https://github.com/skroutz/cogy-bundle hits. It executes the requested
    # {Command} and responds back the result, which is then printed to the user
    # by the cogy executable.
    #
    # See https://github.com/skroutz/cogy-bundle.
    def command
      cmd = params[:cmd]
      args = params.select { |k, _| k.start_with?("COG_ARGV_") }
                   .sort_by { |k, _| k.match(/\d+\z/)[0] }.to_h.values
      opts = params.select { |k, _| k.start_with?("COG_OPT_") }
                   .transform_keys { |k| k.sub("COG_OPT_", "").downcase }
      user = params[:user]
      cog_env = request.request_parameters

      begin
        if (command = Cogy.commands[cmd])
          result = Context.new(command, args, opts, user, cog_env).invoke
          if result.is_a?(Hash)
            result = "COG_TEMPLATE: #{command.template || command.name}\n" \
                     "JSON\n" \
                     "#{result.to_json}"
          end
          render text: result
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
