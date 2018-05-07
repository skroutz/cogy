require "active_support/test_case"

class ActiveSupport::TestCase
  def cmd(name, env={}, as="someone")
    params = if Rails::VERSION::MAJOR >= 5
               { params: env.merge("COG_CHAT_HANDLE" => as) }
             else
               env.merge("COG_CHAT_HANDLE" => as)
             end

    post "/cogy/cmd/#{name}", params
  end

  def fetch_inventory
    get "/cogy/inventory"
    YAML.safe_load(response.body)
  end

  def with_config(opts={})
    old = {}

    opts.each do |k, v|
      old[k] = Cogy.send(k)
      Cogy.send("#{k}=", v)
    end

    yield fetch_inventory

    old.each do |k, v|
      Cogy.send("#{k}=", v)
    end
  end

  def without_commands
    old = Cogy.commands
    Cogy.commands = {}
    yield
    Cogy.commands = old
  end
end
