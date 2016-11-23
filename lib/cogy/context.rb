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

    def initialize(args, opts, handle, env)
      @args = args
      @opts = opts
      @handle = handle
      @env = env
    end

    # Executes a {Command} in the context of {self}.
    #
    # @param [Command] cmd the {Command} to be executed
    #
    # @return [String] the result of the command. This is what will get printed
    #   back to the user that invoked the command and is effectively the return
    #   value of the command body.
    def run!(cmd)
      instance_eval(&cmd.handler)
    end
  end
end
