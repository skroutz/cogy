require "cogy/engine"
require "cogy/handler"
require "cogy/command"

module Cogy
  @@commands = {}
  mattr_accessor :commands

  def self.on(cmd_name, opts = {}, &blk)
    cmd = Command.new(cmd_name, opts)
    handler = Handler.new(blk)
    cmd.register!(handler)
  end

  def self.bundle_config
    # TODO: move some of these to settings
    config = {
      "cog_bundle_version" => 4,
      "name" => Skroutz.settings[:cogy_bundle_name],
      "description" => "Various Cogy-generated commands from Yogurt",
      "version" => "0.0.2", # TODO: this should change dynamically
      "commands" => {}
    }

    commands.each do |name, cmd|
      # also add options
      config["commands"][name] = {
        "executable" => "/srv/cogcmd/debug/commands/cogy", # TEMP
        #"executable" => "/srv/cogcmd/#{config["name"]}/commands/all",
        "description" => cmd.desc,
        "arguments" => cmd.formatted_args,
        "rules" => cmd.rules
      }

      if cmd.example
        config["commands"][name]["example"] = cmd.example
      end
    end

    config
  end
end
