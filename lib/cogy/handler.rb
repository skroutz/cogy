module Cogy
  class Handler
    def initialize(handler, args: [])
      @handler = handler
      @args = args
    end

    def run(env)
      @handler.run("foo")
    end
  end
end
