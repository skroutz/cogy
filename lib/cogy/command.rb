module Cogy
  class Command
    attr :name, :args, :opts, :desc, :long_desc, :example, :rules, :handler

    def initialize(name, args: [], opts: {}, desc:, long_desc: nil, example: nil, rules: nil)
      @name = name
      @args = [args].flatten.map!(&:to_s)
      @opts = opts.with_indifferent_access
      @desc = desc
      @long_desc = long_desc
      @example = example
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

    def formatted_args
      args.map { |a| "<#{a}>" }.join(" ")
    end
  end
end
