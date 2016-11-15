require "test_helper"

module Cogy
  class HelpersTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup { @routes = Engine.routes }

    def test_foo_helper
      get "/cogy/cmd/foohelper/george", cogy_foo: "bar"
      assert_equal "bar", response.body
    end
  end
end
