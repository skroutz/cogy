require "test_helper"

module Cogy
  class BuiltinHelpersTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    def test_args_helper_overrides_predefined_helpers
      cmd :args_overrides, COG_ARGV_1: "hu", COG_ARGV_0: "haha"
      assert_equal "hahahu", response.body
    end

    def test_args_with_empty_arguments
      cmd :empty_args
      assert_equal "true", response.body
    end

    def test_args
      cmd :add, COG_ARGV_0: 1, COG_ARGV_1: 2
      assert_equal "3", response.body
    end
  end
end
