module Cogy
  class Command
    attr :name, :args, :opts, :desc, :long_desc, :examples, :rules, :handler

    def initialize(name, args: [], opts: {}, desc:, long_desc: nil, examples: nil, rules: nil)
      @name = name
      @args = [args].flatten.map!(&:to_s)
      @opts = opts.with_indifferent_access
      @desc = desc
      @long_desc = long_desc
      @examples = examples
      @rules = rules || ["allow"]
    end

    def register!(handler)
      if Cogy.commands[name]
        raise "A command with the name #{name} is already registered"
      end

      @handler = handler
      @handler.command = self

      Cogy.commands[name] = self
    end

    def run!(*args)
      handler.run(*args)
    end

    # Suitable for bundle config display
    def formatted_args
      args.map { |a| "<#{a}>" }.join(" ")
    end

    # Suitable for bundle config display.
    #
    # Get rid of HashWithIndifferentAccess, otherwise the resulting YAML
    # will contain garbage.
    def formatted_opts
      opts.to_hash
    end
  end
end
