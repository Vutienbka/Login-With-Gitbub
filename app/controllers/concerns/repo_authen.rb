# frozen_string_literal: true
require "rails/all"
require "action_controller/railtie"
require "action_view/railtie"
require "graphql/client/railtie"
require "graphql/client/http"

module RepoAuthen

  class Application < Rails::Application
  end
    HTTPAdapter = GraphQL::Client::HTTP.new("https://api.github.com/graphql") do
      def headers(context)
        unless token = context[:access_token] || Application.secrets.github_access_token
          # $ GITHUB_ACCESS_TOKEN=3ed9a0e1cb8bf6ce162f85343f5e8e30c1ee197b bin/rails server
          #   https://help.github.com/articles/creating-an-access-token-for-command-line-use
          fail "Missing GitHub access token"
        end

        {
          "Authorization" => "Bearer #{token}"
        }
      end
    end
 
    Client = GraphQL::Client.new(
      schema: Application.root.join("db/schema.json").to_s,
      execute: HTTPAdapter
    )
    Application.config.graphql.client = Client
 
end
