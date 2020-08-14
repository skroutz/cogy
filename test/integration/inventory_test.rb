require "test_helper"
require "yaml"

module Cogy
  class InventoryTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    def test_valid_yaml
      with_config(bundle: { name: "hyu", version: "5.0",
                            description: "Yet another bundle" },
                  command_load_paths: ["cogy"]) do |inv|
        assert_equal "hyu", inv["name"]
        assert_equal "5.0", inv["version"]
        assert_equal "Yet another bundle", inv["description"]
      end
    end

    def test_cog_bundle_version
      assert_equal 4, fetch_inventory["cog_bundle_version"]
    end

    def test_bundle_version_lambda
      with_config(bundle: { version: -> { 1 + 2 } }) do |inv|
        assert_equal 3, inv["version"]
      end
    end

    def test_commands_section
      with_config(bundle: { cogy_executable: "/bin/no" }) do |inv|
        expected = {
          "executable" => "/bin/no",
          "description" => "Print a foo",
          "rules" => ["allow"],
          "env_vars" => { "COGY_BACKEND" => "http://www.example.com/cogy" }
        }

        assert_equal expected, inv["commands"]["say_foo"]
      end
    end

    def test_without_commands
      without_commands do
        refute_includes fetch_inventory.keys, "commands"
      end
    end

    def test_content_type
      get "/cogy/inventory"
      assert_equal "application/x-yaml", response.content_type
    end

    def test_template
      expected = <<TEMPLATE.strip
**foo:** ~$results[0].name~

~br~

foo
TEMPLATE

      assert_equal expected, fetch_inventory["templates"]["pretty-command"]["body"]
    end

    def test_command_example_array
      assert_equal "foo\n\nbar", fetch_inventory["commands"]["examples_as_array"]["examples"]
    end
  end
end
