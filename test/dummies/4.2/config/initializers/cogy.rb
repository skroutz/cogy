Cogy.configure do |c|
  c.bundle = {
    name: "foo",
    description: "The bundle you really need",
    version: "0.0.1",
    cogy_executable: "/usr/bin/foo"
  }

  c.command_load_paths = ["../cogy"]
  c.cogy_endpoint = "http://www.example.com/cogy"

  c.helper(:foo) { env["cog_foo"] }
  c.helper(:bar) { |text| text.titleize }
end
