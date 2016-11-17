module Cogy
  # {Command} represents a user-defined registered command that can be used
  # in the chat. It contains the Cog-related stuff (ie. everything that
  # needs to be in the bundle config) and a block that will run and return
  # the result (ie. handler).
  class Command
    attr :name

    # The code that will run when the command is invoked
    attr :handler

    # Attributes related to the bundle config in Cog
    attr :args, :opts, :desc, :long_desc, :examples, :rules

    # See {Cogy.on}
    def initialize(name, handler, args: [], opts: {}, desc:, long_desc: nil, examples: nil, rules: nil)
      @name = name.to_s
      @handler = handler
      @args = [args].flatten.map!(&:to_s)
      @opts = opts.with_indifferent_access
      @desc = desc
      @long_desc = long_desc
      @examples = examples
      @rules = rules || ["allow"]
    end

    # Registers a command.
    #
    # @raise [StandardError] if a command with the same name is already
    #   registered
    #
    # @return [self]
    def register!
      if Cogy.commands[name]
        raise "A command with the name #{name} is already registered"
      end

      Cogy.commands[name] = self
    end

    # Executes the handler.
    #
    # @param [Array] args the Cog command arguments as provided by the user
    #   who invoked the command.
    #   See https://cog-book.operable.io/#_first_steps_toward_cog_arguments
    # @param [Hash] opts the Cog command options as provided by the user who
    #   invoked the command
    # @param [String] user chat handle of the user who invoked the command
    # @param [Hash] env the Cogy environment (ie. all environment variables
    #   in the Relay executable that start with 'COGY_')
    #
    # @return [String] the result of the command. This is what will get printed
    #   back to the user that invoked the command and is effectively the return
    #   value of the command body.
    def run!(args, opts, user, env)
      handler.call(args, opts, user, env)
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
