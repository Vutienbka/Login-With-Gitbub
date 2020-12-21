require_relative 'boot'
# require "sprockets/railtie"

require "rails/all"
require "action_controller/railtie"
require "action_view/railtie"
require "graphql/client/railtie"
require "graphql/client/http"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

Dotenv::Railtie.load

HOSTNAME = ENV['HOSTNAME']

module GithubAuth
  class Application < Rails::Application
  end

end
