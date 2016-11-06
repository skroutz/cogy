require 'active_support/test_case'

class ActiveSupport::TestCase
  def fetch_config
    get "/cogy/inventory"
    YAML.load(response.body)
  end

  def with_config(opts={})
    old = {}

    opts.each do |k, v|
      old[k] = Cogy.send(k)
      Cogy.send("#{k}=", v)
    end

    yield fetch_config

    old.each do |k, v|
      Cogy.send("#{k}=", v)
    end
  end
end
