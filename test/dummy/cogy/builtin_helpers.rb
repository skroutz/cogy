on "args_overrides", args: [:handle, :bar], desc: "" do
  handle + bar
end

on "empty_args", args: [:a, :b], desc: "" do
  "#{a.nil? && b.nil?}"
end

on "add", args: [:a, :b], desc: "Add two numbers" do
  a.to_i + b.to_i
end
