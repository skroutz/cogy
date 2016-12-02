module Cogy
  # {Command} represents a user-defined, registered command that can be used
  # in the chat. It contains information about Cog-related stuff (ie. everything that
  # needs to be in the bundle config like args & opts) and the block that will
  # return the result ({Command#handler}).
  class Command
    # @return [String]
    attr_reader :name

    # @return [Proc]
    attr_reader :handler

    # Attribute related to the bundle-config
    attr_reader :args, :opts, :desc, :long_desc, :examples, :rules, :template

    # This is typically used via {Cogy.on} which also registers the newly
    # created {Command}.
    #
    # @param name      [String, Symbol] the name of the command. This is how the
    #   command will be invoked in the chat.
    #
    # @param handler   [Proc] the code that will run when the command is invoked
    #
    # @param args      [Array<Symbol, String>, Symbol, String] the arguments
    #   accepted by the command
    #
    # @param opts      [Hash{Symbol=>Hash}] the options accepted by the command
    # @param desc      [String] the description
    # @param long_desc [String] the long description
    # @param examples  [String] usage examples of the command
    # @param rules     [Array] the command rules
    # @param template  [String] the name of the template to use
    #
    # @raise [ArgumentError] if {#opts} are invalid
    #
    # @see Cogy.on
    def initialize(name, handler, args: [], opts: {}, desc:, long_desc: nil, examples: nil, rules: nil, template: nil)
      @name = name.to_s
      @handler = handler
      @args = [args].flatten.map!(&:to_s)
      @opts = opts.with_indifferent_access
      @desc = desc
      @long_desc = long_desc
      @examples = examples
      @rules = rules || ["allow"]
      @template = template

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
