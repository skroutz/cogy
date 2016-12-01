module Cogy
  # {Context} represents a particular invocation request of a {Command}
  # performed by a user. It holds state like the given arguments, options etc.
  # In other words, it provides the context in which a {Command} should be
  # invoked.
  #
  # A {Context} essentially is an HTTP request performed by `cogy:cogy`
  # (https://github.com/skroutz/cogy-bundle) on behalf of the user.
  # You can think of it as the equivalent of the ActionPack's `Request` object.
  class Context
    # @return [Command] the {Command} to be invoked
    attr_reader :command

    # @return [Array] the user-provided arguments
    #
    # @see https://cog-book.operable.io/#_arguments
    attr_reader :args

    # @return [Hash] the user-provided options
    #
    # @see https://cog-book.operable.io/#_options
    attr_reader :opts

    # @return [String] The chat handle of the user who invoked the command
    attr_reader :handle

    # @return [Hash] the Cog environment of the Relay
    #
    # @see https://cog-book.operable.io/#_command_environment_variables
    attr_reader :env

    def initialize(command, args, opts, handle, env)
      @command = command
      @args = args
      @opts = opts
      @handle = handle
      @env = env

      define_arg_helpers
    end

    # Invokes the command pointed by {#command}.
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
