require "cogy/engine"
require "cogy/command"
require "cogy/context"

module Cogy
  # The supported Cog bundle config version.
  #
  # @see http://docs.operable.io/docs/bundle-configs
  COG_BUNDLE_VERSION = 4

  # Holds all the registered {Command} objects. Not to be messed with.
  @@commands = {}
  mattr_accessor :commands

  # Configuration related to the Cog bundle. Used in {Cogy.bundle_config}
  # in order to generate the bundle config YAML.
  #
  # @see https://cog-book.operable.io/#_the_config_file
  @@bundle = {
    # The bundle name
    name: "myapp",

    # The bundle description
    description: "Cog commands generated from Cogy",

    # The bundle version.
    #
    # Can also be an object that responds to `#call` and returns a string. For
    # example:
    #
    #   -> { rand(1).to_s }
    #
    version: "0.0.1",

    # The path in the Cog Relay where the cogy executable
    # (ie. https://github.com/skroutz/cogy-bundle/blob/master/commands/cogy) is
    # located.
    cogy_executable: "/usr/bin/cogy"
  }
  mattr_accessor :bundle

  # The Cog templates. Used in {Cogy.bundle_config}.
  #
  # @see https://cog-book.operable.io/#_templates
  @@templates = {}
  mattr_accessor :templates

  # Paths where the files that define the commands will be searched in the
  # host application.
  @@command_load_paths = ["cogy"]
  mattr_accessor :command_load_paths

  # Registers a command to Cogy. All the options passed are used solely for
  # generating the bundle config (ie. {Cogy.bundle_config}). The passed block
  # is the code that will get executed when the command is invoked.
  #
  # The last value of the block is what will get printed as the result of the
  # command. It should be a string. If you want to return early in a point
  # inside the block, use `next` instead of `return`.
  #
  # Inside the command block, there are the public attributes of {Context}
  # available.
  #
  # @param cmd_name [String, Symbol] the name of the command. This is how the
  #   command will be invoked in the chat.
  # @param [Hash] opts the options to create the command with. All these options
  #   are used solely for generating the bundle config for Cog, thus they map
  #   directly to Cog's bundle config format.
  #   See https://cog-book.operable.io/#_the_config_file for more information.
  # @option opts [Array<Symbol, String>, Symbol, String] :args ([])
  # @option opts [Hash{Symbol=>Hash}] :opts ({})
  # @option opts [String] :desc required
  # @option opts [String] :long_desc (nil)
  # @option opts [String] :examples (nil)
  # @option opts [Array] :rules (["allow"])
  #
  # @example
  #   Cogy.on "calc",
  #     args: [:a, :b],
  #     opts: { op: { description: "The operation to perform", type: "string", required: true } },
  #     desc: "Perform an arithmetic operation between two numbers",
  #     long_desc: "Operations supported are provided with their respective symbols
  #                 passed as the --op option.",
  #     examples: "Addition:       !calc --op + 1 2\n" \
  #               "Subtraction:    !calc --op - 5 3\n" \
  #               "Multiplication: !calc --op * 2 5\n" \
  #               "Division:       !calc --op / 3 2\",
  #     rules: ["allow"] do
  #     result = args.map(&:to_i).inject(&opts["op"].to_sym)
  #     "Hello #{user}, the answer is: #{result}"
  #   end
  #
  # @return [void]
  #
  # @note If you want to return early in a point inside a command block,
  #   `next` should be used instead of `return`, due to the way Proc objects
  #   work in Ruby.
  def self.on(cmd_name, opts = {}, &handler)
    cmd = Command.new(cmd_name, handler, opts)
    cmd.register!
  end

  # Generates the bundle config
  #
  # @return [Hash]
  def self.bundle_config
    version = if bundle[:version].respond_to?(:call)
                bundle[:version].call
              else
                bundle[:version]
              end

    config = {
      "cog_bundle_version" => COG_BUNDLE_VERSION,
      "name" => bundle[:name],
      "description" => bundle[:description],
      "version" => version
    }

    config["commands"] = {} if commands.present?

    commands.each do |name, cmd|
      config["commands"][name] = {
        "executable" => bundle[:cogy_executable],
        "description" => cmd.desc,
        "rules" => cmd.rules
      }

      if !cmd.args.empty?
        config["commands"][name]["arguments"] = cmd.formatted_args
      end

      if !cmd.opts.empty?
        config["commands"][name]["options"] = cmd.formatted_opts
      end

      if cmd.long_desc
        config["commands"][name]["long_description"] = cmd.long_desc
      end

      if cmd.examples
        config["commands"][name]["examples"] = cmd.examples
      end
    end

    config["templates"] = templates if !templates.empty?

    config
  end

  # Configures Cogy according to the passed block.
  #
  # @yield [self] yields {Cogy}
  #
  # @return [void]
  #
  # @see https://github.com/skroutz/cogy#configuration
  def self.configure
    yield self
  end

  # Defines a user helper method that can be used throughout commands.
  #
  # @param [Symbol] name the name of the helper
  # @param [Proc] blk the helper body
  #
  # @return [void]
  #
  # @note User helpers also have access to the default helpers like `user`, `env`
  #   etc.
  #
  # @example
  #   Cogy.configure do |c|
  #     helper(:user) { User.find_by(slack_handle: handle) }
  #
  #     # a helper that accepts an argument
  #     helper(:format) { |answer| answer.titleize }
  #   end
  def self.helper(name, &blk)
    Context.class_eval { define_method(name, blk) }
  end
end
