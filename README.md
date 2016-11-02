# Cogy

Cogy provides a way to integrate [Cog](https://operable.io/) with Rails apps,
in a way that managing and adding commands is a breeze.

## Why

Creating a Cog command that talks with a Rails app typically involves writing
a route, maybe a controller, an action and code to handle the command arguments
and options.

This is a tedious and repetitive task and involves writing a lot of boilerplate
code each time someone wants to add a new command.

Cogy is an opinionated library that provides a way to get rid of all the
repetitive work and makes writing commands a breeze!

Making a new command available for use is as simple as adding the following line
to a file in your application:

```ruby
# in cogy/my_commands.rb

on "foo", desc: "Echo a foo bar back at you!" do |_args, _opts, user|
  "@#{user}: foo bar"
end
```

...and deploying!

## How it works

Cogy is essentially three things:

1. An opinionated way to write, manage & ship commands: All Cogy commands are
   defined in your Rails app and end up invoking a single executable within the
   Relay (see below). Cogy provides versioning and dynamically generates the
   bundle config, which is also served by your Rails app (via a Rails Engine).
   This, accompanied with the command [TODO: INSERT LINK HERE] that
   can install bundles from other bundles, makes it possible to automatically
   install the newly-written commands by invoking a trigger when you deploy
   your app.
2. A Rails Engine that is mounted in your application and routes the incoming
   requests to their user-defined handlers. It also creates the `/inventory`
   endpoint, which serves the installable bundle configuration in YAML and can be
   consumed directly by the `cogutils:install` command [TODO: INSERT LINK].
3. An executable [TODO: INSERT LINK HERE] which all commands point to.
   This is placed inside the Relays and performs the requests to your application
   when a user invokes a command in the chat. It then posts the result back
   to the user.

## Installation

Add the following to your Gemfile:

```ruby
gem "cogy"
```

## Configuration

The options provided are the following:

```ruby
# in config/initializers/cogy.rb

Cogy.configure do |config|
  # Used in the generated bundle config YAML.
  #
  # Default: "cogy"
  config.bundle_name = "myapp"

  # Used in the generated bundle config YAML.
  #
  # Default: "Cogy-generated commands"
  config.bundle_description = "myapp-generated commands from Cogy"

  # Can be either a string or an object that responds to `#call` and returns
  # a string. Must be set explicitly.
  config.bundle_version = "0.0.1"

  # If you used a callable object, it will be evaluated each time the inventory
  # is called. This can be useful if you want the version to change dynamically
  # when it's needed.
  #
  # For example, this will change the version only when a command is
  # added or is modified (uses the 'grit' gem).
  config.bundle_version = -> {
    repo = Grit::Repo.new(Rails.root.to_s)
    repo.log("HEAD", "cogy/", max_count: 1).first.date.strftime("%y%m%d.%H%M%S")
  }

  # The path in the Relay where the cogy command executable is located at.
  # Must be set explicitly.
  config.executable_path = "/cogcmd/cogy"

  # Paths in your application where the files that define the commands live in.
  # For example the default value will search for all `*.rb` files in the `cogy/`
  # directory relative to the root of your application.
  #
  # Default: ["cogy"]
  config.command_load_paths = "cogy"
end

```

## Usage

Commands are defined like so:

```ruby
# in cogy/commands.rb

on "foo", desc: "Echo a bar" do
  "bar"
end
```

The last line evaluated is the result of the command.

A more complete example:

```ruby
# in cogy/commands.rb
on "calc",
  args: [:a, :b],
  opts: { op: { type: "string", required: true, short_flag: "o" } },
  desc: "Performs a calculation between numbers <a> and <b>",
  example: "!myapp:calc sum 1 2" do |req_args, req_opts, user|
  op = req_opts[:op].to_sym
  result = req_args.map(&:to_i).inject(&op)
  "Hello @#{user}, the result is: #{result}"
end
```

## Error template

When a command throws an error, the default error template is rendered, which
is the following:

    @<%= @user %>: Command '<%= @cmd %>' returned an error.

    ```
    <%= @exception.class %>:<%= @exception.message %>
    ```

However it can be overriden in the application by creating a view in
`app/views/cogy/error.text.erb`.

## Authors

* [Agis Anastasopoulos](https://github.com/agis-)

## License

Cogy is licensed under MIT. See [LICENSE](LICENSE).




