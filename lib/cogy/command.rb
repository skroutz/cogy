module Cogy
  # {Command} represents a user-defined registered command that can be used
  # in the chat. It contains the Cog-related stuff (ie. everything that
  # needs to be in the bundle config) and a block that will run and return
  # the result (ie. handler).
  class Command
    # The name of the command. Also used in {Cogy.bundle_config}.
    #
    # @return [String]
    attr_reader :name

    # The code that will run when the command is invoked
    #
    # @return [Proc]
    attr_reader :handler

    # Attributes related to the bundle config in Cog
    attr_reader :args, :opts, :desc, :long_desc, :examples, :rules

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

      validate_opts
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

    private

    def validate_opts
      opts.each do |k, v|
        missing = [:type, :required] - v.keys.map(&:to_sym)

        if !missing.empty?
          raise ArgumentError,
                "`#{name}`: Parameters #{missing} for `#{k}` option are missing"
        end
      end
    end
  end
end
