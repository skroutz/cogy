require "cogy/engine"
require "cogy/handler"
require "cogy/command"

module Cogy
  COG_BUNDLE_VERSION = 4

	# Holds all the registered Commands
  mattr_accessor :commands
  @@commands = {}

  # Bundle config-related stuff
	mattr_accessor :bundle_name
	@@bundle_name = "cogy"

  mattr_accessor :bundle_description
  @@bundle_description = "Cogy-generated commands"

  # Must be set explicitly
  mattr_accessor :bundle_version
  @@bundle_version = nil

  # A string representing the path to the command executable
  # TODO: raise if it isn't set
  mattr_accessor :executable_path
  @@executable_path = nil

  def self.on(cmd_name, opts = {}, &blk)
    cmd = Command.new(cmd_name, opts)
    handler = Handler.new(blk)
    cmd.register!(handler)
  end

  def self.bundle_config
    config = {
      "cog_bundle_version" => COG_BUNDLE_VERSION,
      "name" => bundle_name,
      "description" => bundle_description,
      "version" => bundle_version,
      "commands" => {}
    }

    commands.each do |name, cmd|
      # also add options
      config["commands"][name] = {
        "executable" => executable_path,
        "description" => cmd.desc,
        "arguments" => cmd.formatted_args,
        #"options" => cmd.options, TODO
        "rules" => cmd.rules
      }

      if cmd.example
        config["commands"][name]["example"] = cmd.example
      end
    end

    config
  end

  def self.configure
    yield self
  end
end
