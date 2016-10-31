module Cogy
  class Handler
    attr_accessor :command

    def initialize(blk)
      @blk = blk
      @command = nil
    end

    def run(args, opts, user)
      opts = opts.reverse_merge(command.opts.transform_values { |v| v["default"] })
      @blk.call(args, opts, user)
    end
  end
end
