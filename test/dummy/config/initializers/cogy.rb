Cogy.configure do |c|
  c.bundle = {
    name: "foo",
    description: "The bundle you really need",
    version: "0.0.1",
    cogy_executable: "/usr/bin/foo"
  }

  c.command_load_paths = ["cogy"]

  c.helper(:foo) { env["cogy_foo"] }
  c.helper(:bar) { |text| text.titleize }
end
