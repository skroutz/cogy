Cogy.configure do |c|
  c.bundle_name = "foo"
  c.bundle_description = "The bundle you really need"
  c.bundle_version = "0.0.1"
  c.executable_path = "/usr/bin/foo"
  c.command_load_paths = ["cogy"]
end
