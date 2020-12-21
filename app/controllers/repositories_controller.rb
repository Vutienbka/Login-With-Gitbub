class RepositoriesController < ApplicationController
  include RepoAuthen
  # Define query for repository listing.
  
  IndexQuery = RepoAuthen::Client.parse <<-'GRAPHQL'
    # All read requests are defined in a "query" operation
    query {
      # viewer is the currently authenticated User
      viewer {
        ...Views::Repositories::Index::Viewer
      }
    }
  GRAPHQL

  # GET /repositories
  def index
    # Use query helper defined in ApplicationController to execute the query.
    # `query` returns a GraphQL::Client::QueryResult instance with accessors
    # that map to the query structure.

    data = query IndexQuery

    # Render the app/views/repositories/index.html.erb template with our
    # current User.
    render "repositories/index", locals: {
      viewer: data.viewer
    }
  end

  # Define query for "Show more repositories..." AJAX action.
  MoreQuery = RepoAuthen::Client.parse <<-'GRAPHQL'
    # This query uses variables to accept an "after" param to load the next
    # 30 repositories.
    query($after: String!) {
      viewer {
        repositories(first: 30, after: $after) {
          # Instead of refetching all of the index page's data, we only need
          # the data for the repositories container partial.
          ...Views::Repositories::Repositories::RepositoryConnection
        }
      }
    }
  GRAPHQL

  # GET /repositories/more?after=CURSOR
  def more
    # Execute the MoreQuery passing along data from params to the query.
    data = query MoreQuery, after: params[:after]

    render partial: "repositories/repositories", locals: {
      repositories: data.viewer.repositories
    }
  end

  # Define query for repository show page.
  ShowQuery = RepoAuthen::Client.parse <<-'GRAPHQL'
    # Query is parameterized by a $id variable.
    query($id: ID!) {
      node(id: $id) {
        # Include fragment for app/views/repositories/show.html.erb
        ...Views::Repositories::Show::Repository
      }
    }
  GRAPHQL

  # GET /repositories/ID
  def show
    data = query ShowQuery, id: params[:id]

    if repository = data.node
      render "repositories/show", locals: {
        repository: repository
      }
    else
      # If node can't be found, 404. This may happen if the repository doesn't
      # exist, we don't have permission or we used a global ID that was the
      # wrong type.repository
      head :not_found
    end
  end

  StarMutation = RepoAuthen::Client.parse <<-'GRAPHQL'
    mutation($id: ID!) {
      star(input: { starrableId: $id }) {
        starrable {
          ...Views::Repositories::Star::Repository
        }
      }
    }
  GRAPHQL

  def star
    data = query StarMutation, id: params[:id]

    if repository = data.star
      respond_to do |format|
        format.js {
          render partial: "repositories/star", locals: { repository: data.star.starrable }
        }

        format.html {
          redirect_to "/repositories"
        }
      end
    else
      head :not_found
    end
  end

  UnstarMutation = RepoAuthen::Client.parse <<-'GRAPHQL'
    mutation($id: ID!) {
      unstar(input: { starrableId: $id }) {
        starrable {
          ...Views::Repositories::Star::Repository
        }
      }
    }
  GRAPHQL

  def unstar
    data = query UnstarMutation, id: params[:id]

    if repository = data.unstar
      respond_to do |format|
        format.js {
          render partial: "repositories/star", locals: { repository: data.unstar.starrable }
        }

        format.html {
          redirect_to "/repositories"
        }
      end
    else
      head :not_found
    end
  end

  ListStargazers = RepoAuthen::Client.parse <<-'GRAPHQL'
  query($id: ID!) {
      node(id: $id) {
        ...Views::Repositories::Stargazers::Repository
      }
    }
GRAPHQL

  def stargazers
    data = query ListStargazers, id: params[:id]
    if repository = data.node
      render "repositories/stargazers", locals: {
        repository: repository
      }
    else
      head :not_found
    end
  end

  MoreStargazers = RepoAuthen::Client.parse <<-'GRAPHQL'
  query($after: String!, $owner: String!, $name: String!) {
    repository(owner:$owner, name: $name) {
      stargazers(first: 30, after: $after) {
        ...Views::Repositories::ListStargazers::StargazerConnection
      }
    }
  }
GRAPHQL

def more_stargazers
  data = query MoreStargazers, after: params[:after], owner: params[:owner], name:params[:name]

  render partial: "repositories/list_stargazers", locals: {
    stargazers: data.repository.stargazers
  }
end
  
ListIssues = RepoAuthen::Client.parse <<-'GRAPHQL'
  query($id: ID!) {
      node(id: $id) {
        ...Views::Repositories::Issues::Repository
      }
    }
GRAPHQL

  def issues
    data = query ListIssues, id: params[:id]
    if repository = data.node
      render "repositories/issues", locals: {
        repository: repository
      }
    else
      head :not_found
    end
  end

  MoreIssues = RepoAuthen::Client.parse <<-'GRAPHQL'
  query($after: String!, $owner: String!, $name: String!) {
    repository(owner:$owner, name: $name) {
      issues(first: 30, after: $after) {
        ...Views::Repositories::ListIssues::IssueConnection
      }
    }
  }
GRAPHQL

  def more_issues
    data = query MoreIssues, after: params[:after], owner: params[:owner], name:params[:name]

    render partial: "repositories/list_issues", locals: {
      issues: data.repository.issues
    }
  end

end
