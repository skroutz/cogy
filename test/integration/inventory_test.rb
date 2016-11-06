require "test_helper"
require "yaml"

module Cogy
  class InventoryTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup { @routes = Engine.routes }

    def test_valid_yaml
      with_config(bundle_name: "hyu", bundle_version: "5.0",
                  bundle_description: "Yet another bundle",
                  command_load_paths: ["cogy"]) do |inv|
        assert_equal "hyu", inv["name"]
        assert_equal "5.0", inv["version"]
        assert_equal "Yet another bundle", inv["description"]
      end
    end

    def test_cog_bundle_version
      assert_equal 4, fetch_config["cog_bundle_version"]
    end

    def test_bundle_version_lambda
      with_config(bundle_version: -> { 1 + 2 }) do |inv|
        assert_equal 3, inv["version"]
      end
    end

    def test_commands
      with_config(executable_path: "/bin/no") do |inv|
        expected = {
          "say_foo" => {
            "executable" => "/bin/no",
            "description" => "Print a foo",
            "rules" => ["allow"]
          }
        }

        assert_equal expected, inv["commands"]
      end
    end
  end
end

