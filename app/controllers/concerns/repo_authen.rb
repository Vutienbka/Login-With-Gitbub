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
      unless token = context[:access_token] || User.first.token
        fail "Missing GitHub access token"
      end

      {
        "Authorization" => "Bearer #{token}",
      }
    end
  end

  Client = GraphQL::Client.new(
    schema: Application.root.join("db/schema.json"),
    execute: HTTPAdapter,
  )
  Application.config.graphql.client = Client
end
