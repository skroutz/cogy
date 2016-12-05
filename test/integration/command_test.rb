require "test_helper"

module Cogy
  class CommandTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup { @routes = Engine.routes }

    def test_error_response_code
      cmd :raiser
      assert_equal 500, response.status
    end

    def test_calc_command
      cmd :calc, { COG_OPT_OP: "+", COG_ARGV_0: 1, COG_ARGV_1: 2 }, "george"
      assert_equal "Hello george, the answer is: 3", response.body

      cmd :calc, { COG_OPT_OP: "/", COG_ARGV_0: 10, COG_ARGV_1: 5 }, "george"
      assert_equal "Hello george, the answer is: 2", response.body
    end

    def test_command_not_found
      cmd :idontexist
      assert_equal 404, response.status
    end

    def test_cogy_env
      cmd :print_env, foo: "ha", COG_FOO: "baz", FOO: "foo"
      assert_equal "ha baz  foo", response.body
    end

    def test_rails_url_helpers
      cmd :rails_url_helpers
      assert_equal "http://dummy.com/baz /baz", response.body
    end

    def test_invalid_opts_declaration
      exception = assert_raises(ArgumentError) do
        Cogy.on "invalidopts", desc: "foo", opts: { foo: {} } do
          1
        end
      end

      assert_match(/\[:type, :required\]/, exception.message)
    end

    def test_args_ordering
      cmd :args_order, COG_ARGV_2: 3, COG_ARGV_1: 2, COG_ARGV_0: 1
      assert_equal "123", response.body
    end

    def test_opts_downcased_and_indifferent_access
      cmd :test_opts_downcased, COG_OPT_A: "foo"
      assert_equal "foo", response.body
    end
  end
end
