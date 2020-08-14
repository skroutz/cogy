require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)
require "cogy"

module Dummy
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    config.action_dispatch.return_only_media_type_on_content_type = true

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end

