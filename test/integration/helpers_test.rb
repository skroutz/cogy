require "test_helper"

module Cogy
  class HelpersTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    def test_custom_helpers_can_access_default_helpers
      cmd :foohelper, cog_foo: "bar"
      assert_equal "bar", response.body
    end

    def test_custom_helper_with_arguments
      cmd :titleize
      assert_equal "This Should Be Titleized", response.body
    end
  end
end
