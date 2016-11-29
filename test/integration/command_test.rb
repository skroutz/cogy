require "test_helper"

module Cogy
  class CommandTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup { @routes = Engine.routes }

    def test_error_response_code
      post "/cogy/cmd/raiser/george"
      assert_equal 500, response.status
    end

    def test_calc_command
      post "/cogy/cmd/calc/george", COG_OPT_OP: "+", COG_ARGV_0: 1, COG_ARGV_1: 2
      assert_equal "Hello george, the answer is: 3", response.body

      post "/cogy/cmd/calc/george", COG_OPT_OP: "/", COG_ARGV_0: 10, COG_ARGV_1: 5
      assert_equal "Hello george, the answer is: 2", response.body
    end

    def test_command_not_found
      post "/cogy/cmd/idontexist/foo"
      assert_equal 404, response.status
    end

    def test_cogy_env
      post "/cogy/cmd/print_env/george", foo: "ha", COG_FOO: "baz", FOO: "foo"
      assert_equal "ha baz  foo", response.body
    end

    def test_rails_url_helpers
      post "/cogy/cmd/rails_url_helpers/george"
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
      post "/cogy/cmd/args_order/george", COG_ARGV_2: 3, COG_ARGV_1: 2, COG_ARGV_0: 1
      assert_equal "123", response.body
    end

    def test_opts_downcased_and_indifferent_access
      post "/cogy/cmd/test_opts_downcased/george", COG_OPT_A: "foo"
      assert_equal "foo", response.body
    end
  end
end
