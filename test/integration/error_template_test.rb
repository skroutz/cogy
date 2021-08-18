require "test_helper"

module Cogy
  class ErrorTemplateTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    def test_error_tmpl_message
      cmd :raiser, {}, "george"
      assert response.body.include?("boom")
      assert response.body.include?("@george")
    end

    def test_error_tmpl_contenttype
      cmd :raiser, {}, "george"
      assert_equal "text/plain", response.media_type.to_s
    end
  end
end
