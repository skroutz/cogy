require "test_helper"

module Cogy
  class BuiltinHelpersTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup { @routes = Engine.routes }

    def test_args_helper_overrides_predefined_helpers
      get "/cogy/cmd/args_overrides/george", cog_argv_1: "hu", cog_argv_0: "haha"
      assert_equal "hahahu", response.body
    end

    def test_args_with_empty_arguments
      get "/cogy/cmd/empty_args/george"
      assert_equal "true", response.body
    end

    def test_args
      get "/cogy/cmd/add/george", cog_argv_0: 1, cog_argv_1: 2
      assert_equal "3", response.body
    end
  end
end
