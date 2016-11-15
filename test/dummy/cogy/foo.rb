on "say_foo", desc: "Print a foo" do
  "foo"
end

on "raiser", desc: "Raises an exception" do
  raise "boom"
end

on "print_env", desc: "Test cogy env access" do |_, _, _, env|
  env["cogy_foo"]
end

on "foohelper", desc: "" do |*, env|
  foo(env)
end


