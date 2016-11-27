module Cogy
  # {Context} represents a particular invocation request of a {Command}
  # performed by a user. It holds state like the command arguments, options etc.
  # In other words, it provides the context in which a {Command} should be
  # invoked.
  #
  # A {Context} essentially is an HTTP request performed by the `cogy:cogy`
  # command (https://github.com/skroutz/cogy-bundle) on behalf of the user.
  # You can think of it as the equivalent of the ActionPack's `Request` class.
  class Context
    # @return [Command] the {Command} to be invoked by {Context#invoke}
    attr_reader :command

    # @return [Array] The Cog command arguments as passed by the user who
    #   invoked the command.
    #
    # @see https://cog-book.operable.io/#_arguments
    attr_reader :args

    # @return [Hash] The Cog command options as provided by the user who
    #   invoked the command
    #
    # @see https://cog-book.operable.io/#_options
    attr_reader :opts

    # @return [String] The chat handle of the user who invoked the command
    #
    # @see https://cog-book.operable.io/#_general_metadata
    attr_reader :handle

    # @return [Hash] The Cogy environment (ie. all environment variables in
    # the Relay executable that start with 'COGY_')
    #
    # @see https://github.com/skroutz/cogy-bundle/blob/master/commands/cogy
    attr_reader :env

    def initialize(command, args, opts, handle, env)
      @command = command
      @args = args
      @opts = opts
      @handle = handle
      @env = env

      define_arg_helpers
    end

    # Invokes the {Command}
    #
    # @return [Object] the result of the command. This is what will get printed
    #   back to the user that invoked the command and is effectively the return
    #   value of the command body.
    def invoke
      instance_eval(&command.handler)
    end

    private

    # Defines helpers for accessing the arguments of the respective {Command}
    # by their name.
    #
    # For example, assuming a command:
    #
    #     on "foo", args: [:a, :b] do
    #       a + b
    #     end
    #
    # If this was called with the arguments "foo" and "bar", it would return
    # "foobar".
    #
    # @note Keep in mind that these helpers override the attribute readers
    #   of {Context}, so you're advised to avoid naming arguments with words
    #   like "args", "opts" etc.
    #
    # @todo We may want to implement a protection against overriding reserved
    #   words
    def define_arg_helpers
      command.args.each_with_index do |arg, i|
        define_singleton_method(arg) { args[i] }
      end
    end
  end
end
