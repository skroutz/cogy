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
    # The Cog command arguments as provided by the user who invoked the command.
    #
    # See https://cog-book.operable.io/#_arguments
    attr :args

    # The Cog command options as provided by the user who invoked the command
    #
    # See https://cog-book.operable.io/#_options
    attr :opts

    # The chat handle of the user who invoked the command
    #
    # See https://cog-book.operable.io/#_general_metadata
    attr :user

    # The Cogy environment (ie. all environment variables in the Relay
    # executable that start with 'COGY_')
    attr :env

    def initialize(args, opts, user, env)
      @args = args
      @opts = opts
      @user = user
      @env = env
    end
  end
end
