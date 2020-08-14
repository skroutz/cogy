require "test_helper"

module Cogy
  class JsonResponseTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    def test_json_output_and_default_template
      cmd :simple_json

      expected = "COG_TEMPLATE: simple_json\n" \
                 "JSON\n" \
                 '{"a":3,"b":4}'

      assert_equal expected, response.body
    end

    def test_custom_template
      cmd :custom_template

      expected = "COG_TEMPLATE: foo\n" \
                 "JSON\n" \
                 '{"a":3}'

      assert_equal expected, response.body
    end
  end
end
