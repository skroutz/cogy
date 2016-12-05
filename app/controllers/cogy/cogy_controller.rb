require_dependency "cogy/application_controller"

module Cogy
  # This is the entry point to the host application.
  #
  # All Cogy-command invocations of the users end up being served by this
  # controller ({#command}).
  class CogyController < ApplicationController
    # POST /<mount_path>/cmd/:cmd
    #
    # Executes the requested {Command} and returns the result.
    def command
      cmd = params[:cmd]
      args = params.select { |k, _| k.start_with?("COG_ARGV_") }
                   .sort_by { |k, _| k.match(/\d+\z/)[0] }.to_h.values
      opts = params.select { |k, _| k.start_with?("COG_OPT_") }
                   .transform_keys { |k| k.sub("COG_OPT_", "").downcase }
      user = params["COG_CHAT_HANDLE"]
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

    # GET /<mount_path>/inventory
    #
    # Returns the bundle config in YAML format, which is installable by Cog.
    # It is typically hit by `cogy:install` (https://github.com/skroutz/cogy-bundle).
    def inventory
      render text: Cogy.bundle_config.to_yaml, content_type: "application/x-yaml"
    end
  end
end
