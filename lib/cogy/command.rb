module Cogy
  # {Command} represents a user-defined registered command that can be used
  # in the chat. It contains the Cog-related stuff (ie. everything that
  # needs to be in the bundle config).
  #
  # Each {Command} also contains its {Handler} that will be called when the
  # command is run.
  class Command
    attr :name, :args, :opts, :desc, :long_desc, :examples, :rules

    # Returns the {Handler} that will be invoked when the command is executed
    attr :handler

    # See {Cogy.on}
    def initialize(name, args: [], opts: {}, desc:, long_desc: nil, examples: nil, rules: nil)
      @name = name.to_s
      @args = [args].flatten.map!(&:to_s)
      @opts = opts.with_indifferent_access
      @desc = desc
      @long_desc = long_desc
      @examples = examples
      @rules = rules || ["allow"]
    end

    # Registers a command.
    #
    # @param handler [Handler] the {Handler} that will be called when the command is
    #   executed
    #
    # @raise [StandardError] if a command with the same name is already
    #   registered
    #
    # @return [self]
    def register!(handler)
      if Cogy.commands[name]
        raise "A command with the name #{name} is already registered"
      end

      @handler = handler
      @handler.command = self

      Cogy.commands[name] = self
    end

    # Executes a command
    def run!(*args)
      handler.run(*args)
    end

    # @return [String] the command arguments suitable for conversion to YAML
    #   for displaying in a bundle config.
    def formatted_args
      args.map { |a| "<#{a}>" }.join(" ")
    end

    # @return [Hash] the command options suitable for conversion to YAML
    #   for displaying in a bundle config
    def formatted_opts
      # Convert to Hash in order to get rid of HashWithIndifferentAccess,
      # otherwise the resulting YAML will contain garbage.
      opts.to_hash
    end
  end
end
