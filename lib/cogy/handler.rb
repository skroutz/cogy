module Cogy
  # {Handler} is essentially the user-defined code that runs when a command
  # is invoked and will generate the response in order to be printed to the
  # user.
  class Handler
    # The {Command} that the handler handles
    attr_accessor :command

    # @param [Proc] blk the code that will run when the respective {Command}
    #   is invoked
    def initialize(blk)
      @blk = blk
      @command = nil # typically set by Command.register!
    end

    # Executes the handler.
    #
    # @param [Array] args the Cog command arguments as provided by the user
    #   who invoked the command.
    #   See https://cog-book.operable.io/#_first_steps_toward_cog_arguments
    # @param [Hash] opts the Cog command options as provided by the user who
    #   invoked the command
    # @param [String] user chat handle of the user who invoked the command
    #
    # @return [String] the result of the command. This is what will get printed
    #   back to the user that invoked the command and is effectively the return
    #   value of the command body.
    def run(args, opts, user)
      @blk.call(args, opts, user)
    end
  end
end
