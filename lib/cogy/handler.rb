module Cogy
  class Handler
    attr_accessor :command

    def initialize(blk)
      @blk = blk
      @command = nil
    end

    def run(args, opts, user)
      @blk.call(args, command.opts.merge(opts), user)
    end
  end
end
