# Cogy

[![Build Status](https://api.travis-ci.org/skroutz/cogy.svg?branch=master)](https://travis-ci.org/skroutz/cogy)
[![Gem Version](https://badge.fury.io/rb/cogy.svg)](https://badge.fury.io/rb/cogy)
[![Inline docs](http://inch-ci.org/github/skroutz/cogy.svg)](http://inch-ci.org/github/skroutz/cogy)

Cogy integrates [Cog](https://operable.io/) with Rails
in a way that writing & deploying commands from your application is a breeze.

See the API documentation [here](http://www.rubydoc.info/github/skroutz/cogy).

Refer to the [Changelog](CHANGELOG.md) to see what's changed between releases.

## Features

- Write commands inside your Rails app, using Ruby (see [_Usage_](#usage))
- The bundle config is generated automatically
- Commands are installed _automatically_ when you deploy (see [_Deployment_](#deployment))
- Support for JSON responses and Templates (see [_Returning JSON to COG_](#returning-json-to-cog))
- Customizable error templates (see [_Error template_](#error-template))

...and more on the way!

## Why

Creating ChatOps commands that talk with a Rails app typically involves writing
a route, maybe a controller, an action and code to handle the command arguments
and options.

This is a tedious and repetitive task and involves a lot of boilerplate
code each time someone wants to add a new command.

Cogy is an opinionated library that provides a way to get rid of all the
boilerplate stuff so you can focus on just the actual commands.

Deploying a new command is as simple as writing:

```ruby
# in cogy/my_commands.rb

on "foo", desc: "Echo a foo bar back at you!" do
  "@#{handle}: foo bar"
end
```

...and deploying!

## How it works

Cogy is essentially three things:

1. An opinionated way to write, manage & ship commands: All Cogy commands are
   defined in your Rails app and end up invoking a single executable within the
   Relay (see below). Cogy also provides bundle versioning and dynamically generates the
   installable bundle config, which is also served by your Rails application
   and consumed by the [`cogy:install`](https://github.com/skroutz/cogy-bundle)
   command that installs the new Cogy-generated bundle when you deploy your
   application.
2. A library that provides the API for defining the commands. This library
   is integrated in your application via a Rails Engine that routes the incoming
   requests to their respective handlers. It also creates the `/inventory`
   endpoint, which serves the installable bundle configuration in YAML and can be
   consumed directly by the [`cogy:install`](https://github.com/skroutz/cogy-bundle) command.
3. A [Cog bundle](https://github.com/skroutz/cogy-bundle) that contains the
   [executable](https://github.com/skroutz/cogy-bundle/blob/master/commands/cogy)
   that all the commands end up invoking.
   It is placed inside the Relays and performs the requests to your application
   when a user invokes a command in the chat. It then posts the result back
   to the user. It also contains the `cogy:install` command for automating
   the task of installing the new bundle when a command is added/modified.

Take a look at the relevant [diagrams](diagrams/) for a detailed illustration.

## Requirements

* [cogy bundle v0.4.0+](https://github.com/skroutz/cogy-bundle)
* Ruby 2.1+
* Rails 4.2 (support for Rails 5 is on the way)

## Status

Cogy is still in public alpha.

While we use it in production, it's still under heavy development.
This means that there are a few rough edges and things change fast.

However we'd love any [feedback, suggestions or ideas](https://github.com/skroutz/cogy/issues/new).

## Install

Add it to your Gemfile:

```ruby
gem "cogy"
```

Then run `bundle install`

Next, run the generator:

```shell
$ bin/rails g cogy:install
```

This will create a sample command, mount the engine and add a sample
configuration initializer in your application.

## Usage

Defining a new command:

```ruby
# in cogy/my_commands.rb

on "foo", desc: "Echo a bar" do
  "bar"
end
```

This will print "bar" back to the user who calls `!foo` in Slack.

Let's define a command that simply adds the numbers passed as arguments:

```ruby
# in cogy/calculations.rb

on "add", args: [:a, :b], desc: "Add two numbers" do
  a.to_i + b.to_i
end
```

Inside the block there are the following helpers available:

* `args`: an array containing the arguments passed to the command
  * arguments can also be accessed by their names as local variables
* `opts`: a hash containing the options passed to the command
* `handle`: the chat handle of the user who called the command
* `env`: a hash containing the Relay environment as available in the cogy
  bundle

For instructions on defining your own helpers, see [Helpers](#helpers).

A more complete example:

```ruby
# in cogy/commands.rb
on "calc",
  args: [:a, :b],
  opts: { op: { type: "string", required: true } },
  desc: "Performs a calculation between numbers <a> and <b>",
  examples: "myapp:calc sum 1 2" do
  op = opts[:op].to_sym
  result = args.map(&:to_i).inject(&op)
  "Hello @#{user}, the result is: #{result}"
end
```

For more examples see the [test commands](https://github.com/skroutz/cogy/tree/master/test/dummy/cogy).

### Returning JSON to Cog

You can return JSON to Cog by just returning a `Hash`:

```ruby
on "foo", desc: "Just a JSON" do
  { a: 3 }
end
```

The hash is automatically converted to JSON. The above command would return
the following response to Cog:

```
COG_TEMPLATE: foo
JSON
{"a":3}
```

To customize the Cog [template](#Templates) to be used, use the `template`
option:

```ruby
on "foo", desc: "Just a JSON", template: "bar" do
  { a: 3 }
end
```

Info on how Cog handles JSON can be found in the [official documentation](https://cog-book.operable.io/#_returning_data_from_cog).

### Templates

[Templates](https://cog-book.operable.io/#_templates) are defined in their own files under `templates/` inside any of
the [command load paths](#Configuration). For example:

```
$ tree
.
├── README.rdoc
├── <..>
├── cogy
│   ├── some_commands.rb
│   └── templates
│       └── foo # <--- a template named 'foo'
|── <...>
```

Given the following template:

```
# in cogy/templates/foo
~ hello world ~
```

the resulting bundle config would look like this:

```yaml
---
cog_bundle_version: 4
name: foo
description: The bundle you really need
version: 0.0.1
commands:
  <...>
templates:
  foo:
    body: |-
      ~ hello world ~
```

Refer to the [Cog book](https://cog-book.operable.io/#_templates) for more on
templates.

## Configuration

The configuration options provided are the following:

```ruby
# in config/initializers/cogy.rb

Cogy.configure do |config|
  # Configuration related to the generated Cog bundle. Will be used when
  # generating the bundle config YAML to be installed.
  config.bundle = {
    # The bundle name.
    #
    # Default: "myapp"
    name: "myapp",

    # The bundle description
    #
    # Default: "Cog commands generated from Cogy"
    description: "myapp-generated commands from Cogy",

    # The bundle version.
    #
    # Can be either a string or an object that responds to `#call` and returns
    # a string.
    #
    # Default: "0.0.1"
    version: "0.0.1",

    # if you used a callable object, it will be evaluated each time the inventory
    # is called. This can be useful if you want the version to change
    # automatically.
    #
    # For example, this will change the version only when a command is
    # added or is modified (uses the 'grit' gem).
    version: -> {
      repo = Grit::Repo.new(Rails.root.to_s)
      repo.log("HEAD", "cogy/", max_count: 1).first.date.strftime("%y%m%d.%H%M%S")
    },

    # The path in the Relay where the cogy command executable is located.
    cogy_executable: "/cogcmd/cogy"
  }

  # Paths in your application where the files that define the commands live in.
  # For example the default value will search for all `*.rb` files in the `cogy/`
  # directory relative to the root of your application.
  #
  # Default: ["cogy"]
  config.command_load_paths = "cogy"
end

```

You can use the generator to quickly create a config initializer in your app:

```shell
$ bin/rails g cogy:config
```

### Helpers

It is possible to define helpers that can be used throughout commands. This is
useful for DRYing repetitive code.

They are defined during configuration and may also accept arguments.

Let's define a helper that fetches the `address` of a `Shop` record:
command:

```ruby
Cogy.configure do |c|
  c.helper(:shop_address) { Shop.find_by(owner: handle).address }
end
```

*(Note that custom helpers also have access to the default helpers like
`handle`, `args` etc.)*

Then we could have a command that makes use of the helper:

```ruby
on "shop_address", desc: "Returns the user's Shop address" do
  "@#{handle}: Your shop's address is #{shop_address}"
end
```

Helpers may also accept arguments:

```ruby
Cogy.configure do |c|
  c.helper(:format) { |answer| answer.titleize }
end
```

This helper could be called like so:

```ruby
on "foo", desc: "Nothing special" do
  format "hello there, how are you today?"
end
```

Rails URL helpers (ie. `foo_url`) are also available inside the commands.

## Error template

When a command throws an error the
[default error template](https://github.com/skroutz/cogy/blob/master/app/views/cogy/error.text.erb) is rendered, which
is the following:

    @<%= @user %>: Command '<%= @cmd %>' returned an error.

    ```
    <%= @exception.class %>:<%= @exception.message %>
    ```

It can be overriden in the application by creating a view in
`app/views/cogy/error.text.erb`.

## Installation Trigger

In order to automate the process of installing the new bundle versions
(eg. after a new command is added), you must create a [Cog Trigger](https://cog-book.operable.io/#_developing_a_trigger)
that will perform the installation, which will be called when you deploy your
app.

The trigger will look this:

```shell
$ cogctl triggers
Name               ID                                    Enabled  Pipeline
ReleaseUrlTrigger  d10df83b-a737-4fc4-8d9b-bf9627412d0a  true     cogy:install --url $body.url > chat://#general
```

It essentially uses the [cogy bundle](https://github.com/skroutz/cogy-bundle)
and installs the bundle config which is served by your application
(ie. http://your-app.com/cogy/inventory).

See [_Deployment_](#deployment) on information about how this trigger is
invoked.

## Deployment

Cogy provides integration with Capistrano 2 and 3.

There is the just one task, `cogy:notify_cog`, which just executes the
[installation Trigger](#installation-trigger).

The task should run
*after* the application server is restarted, so that the new commands
are picked up and served by the Inventory endpoint. In Capistrano 2 for
example, it should run after the built-in `deploy:restart` task.

The following options need to be set:

* `cogy_release_trigger_url`: This is the URL of the Cog Trigger that will
  install the newly deployed bundle (ie. `!cogy:install`).
* `cogy_endpoint`: Where the Cogy Engine is mounted at.
  For example `http://myapp.com/cogy`.

You can also configure the timeout value for the request to the Trigger by
setting the `cogy_trigger_timeout` option (default: 7).

The code of the task can be found [here](https://github.com/skroutz/cogy/blob/master/lib/cogy/capistrano/cogy.rake).

### Capistrano 2

Add the following in `config/deploy.rb`:

```ruby
# in config/deploy.rb
require "cogy/capistrano"

set :cogy_release_trigger_url, "<TRIGGER-INVOCATION-URL>"
set :cogy_endpoint, "<COGY-MOUNT-POINT>"

after "deploy:restart", "cogy:notify_cog"
```

### Capistrano 3

Add the following in your Capfile:

```ruby
require "cogy/capistrano"
```

Then configure the task and hook it:

```ruby
# in config/deploy.rb

set :cogy_release_trigger_url, "<TRIGGER-INVOCATION-URL>"
set :cogy_endpoint, "<COGY-MOUNT-POINT>"

after "<app-restart-task>", "cogy:notify_cog"
```

## Development

Running the tests and RuboCop:

```shell
$ rake
```

Running just the tests:

```shell
$ rake test
```

Running RuboCop:

```shell
$ rake rubocop
```

Generating documentation:

```shell
$ rake yard
```

## Authors

* [Agis Anastasopoulos](https://github.com/agis-)
* [Mpampis Kostas](https://github.com/charkost)

## License

Cogy is licensed under MIT. See [LICENSE](LICENSE).
