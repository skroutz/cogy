module Cogy
  class ApplicationController < ActionController::Base
    if Rails::VERSION::MAJOR < 5
      # @todo https://github.com/skroutz/cogy/issues/43
      skip_before_action :verify_authenticity_token
    end
  end
end
