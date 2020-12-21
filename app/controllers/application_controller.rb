class ApplicationController < ActionController::Base
  include AuthHelper
  include RepoAuthen
  class QueryError < StandardError; end

private
    # Public: Define request scoped helper method for making GraphQL queries.
    #
    # Examples
    #
    #   data = query(ViewerQuery)
    #   data.viewer.login #=> "josh"
    #
    # definition - A query or mutation operation GraphQL::Client::Definition.
    #              Client.parse("query { version }") returns a definition.
    # variables - Optional set of variables to use during the operation.
    #             (default: {})
    #
    # Returns a structured query result or raises if the request failed.
    def query(definition, variables = {})
      response = RepoAuthen::Client.query(definition, variables: variables, context: client_context)
      
      if response.errors.any?
        raise QueryError.new(response.errors[:data].join(", "))
      else
        response.data
      end
    end

    # Public: Useful helper method for tracking GraphQL context data to pass
    # along to the network adapter.
    def client_context
      # Use static access token from environment. However, here we have access
      # to the current request so we could configure the token to be retrieved
      # from a session cookie.
      { access_token: GithubAuth::Application.secrets.github_access_token }
    end


end
