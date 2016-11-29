require "test_helper"

module Cogy
  class JsonResponseTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup { @routes = Engine.routes }

    def test_json_output_and_default_template
      post "/cogy/cmd/simple_json/george"

      expected = "COG_TEMPLATE: simple_json\n" \
                 "JSON\n" \
                 '{"a":3,"b":4}'

      assert_equal expected, response.body
    end

    def test_custom_template
      post "/cogy/cmd/custom_template/hyu"

      expected = "COG_TEMPLATE: foo\n" \
                 "JSON\n" \
                 '{"a":3}'

      assert_equal expected, response.body
    end
  end
end
