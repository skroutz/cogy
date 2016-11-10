on "calc",
  args: [:a, :b],
  opts: { op: { description: "The operation to perform", type: "string" } },
  desc: "Perform an arithmetic operation between two numbers",
  long_desc: "Operations supported are provided with their respective symbols
              passed as the --op option.",
  examples: "Addition:\n\n    !calc --op + 1 2\n\n"       \
            "Subtraction:\n\n    !calc --op - 5 3\n\n"    \
            "Multiplication:\n\n    !calc --op * 2 5\n\n" \
            "Division:\n\n    !calc --op / 30 2\n\n",
  rules: ["allow"] do |req_args, req_opts, user|
  result = req_args.map(&:to_i).inject(&req_opts["op"].to_sym)
  "Hello #{user}, the answer is: #{result}"
end
