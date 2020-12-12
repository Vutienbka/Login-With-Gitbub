# Login with Github

Application was developed on Ruby on Rails. To start create a [Github OAuth App](https://github.com/settings/applications/new)
Follow the next steps after clonning this repo:

  - Run `bundle install` on the terminal to install dependencies
  - Insert Client ID and Client Secret into `.env` file
  - Run `rails s` to start the application

# .env config
.env file has to contain next vars

```
HOSTNAME=localhost
APP_URL=http://localhost:3000
GITHUB_LOGIN_URL=https://github.com/login/oauth/authorize?
GITHUB_CLIENT_ID=52e99d21652f7ef022d5
GITHUB_CLIENT_SECRET=6153ea1bd27ee6ac5a039e2db8e26294fd5a488e
GITHUB_REDIRECT_URL=${APP_URL}/auth/github/cb
GITHUB_ACCESS_TOKEN_URL=https://github.com/login/oauth/access_token
GITHUB_USER_URL=https://api.github.com/user
```

# What was done
I have added next routes:
- `/` for displaying link to login with Github
- `/auth/github` redirects a user to request identity
- `/auth/github/cb` Github redirects back to this URL
- `/logout` to logout a user

I added `auth_controller` with following actions to handle routes.
- `index` shows a page with link to Github Auth
- `login` redirects to Github with needed params
- `cb` handles response from Github. It will request `access_token` from Github. Further, with `access_token` will be requesting user info that will be stored (if doesn't exist) on the database and session
- in the `logout` action will be removed user id from session, so will redirect to root url with flash message


Demonstrates how to use the [`graphql-client`](http://github.com/github/graphql-client) gem to build a simple repository listing web view against the [GitHub GraphQL API](https://developer.github.com/v4/guides/intro-to-graphql/).

<img width="365" src="https://cloud.githubusercontent.com/assets/137/18425026/a9929d7a-78f0-11e6-9fd4-f478470ad10b.png">

The application structure is setup like a typical Rails app using controllers, views and routes with one key difference, no models. This app doesn't connect directly to any database. All the data is being fetched remotely from the GitHub GraphQL API. Instead of declaring resource models, data queries are declared right along side their usage in controllers and views. This allows an efficient single request to be constructed rather than making numerous REST requests to render a single view.

## Table of Contents

Jump right into the code and read the inline documentation. The following is a suggested reading order:

1. [app/controller/repositories_controller.rb](https://github.com/github/github-graphql-rails-example/blob/master/app/controllers/repositories_controller.rb) defines the top level GraphQL queries to fetch repository list and show pages.
2. [app/views/repositories/index.html.erb](https://github.com/github/github-graphql-rails-example/blob/master/app/views/repositories/index.html.erb) shows the root template's listing query and composition over subviews.
3. [app/views/repositories/_repositories.html.erb]( https://github.com/github/github-graphql-rails-example/blob/master/app/views/repositories/_repositories.html.erb) makes use of GraphQL connections to show the first couple items and a "load more" button.
4. [app/views/repositories/show.html.erb](https://github.com/github/github-graphql-rails-example/blob/master/app/views/repositories/show.html.erb) shows the root template for the repository show page.
5.  [app/controller/application_controller.rb](https://github.com/github/github-graphql-rails-example/blob/master/app/controllers/application_controller.rb) defines controller helpers for executing GraphQL query requests.
6. [config/application.rb](https://github.com/github/github-graphql-rails-example/blob/master/config/application.rb) configures `GraphQL::Client` to point to the GitHub GraphQL endpoint.

## Running locally

First, you'll need a [GitHub API access token](https://help.github.com/articles/creating-an-access-token-for-command-line-use) to make GraphQL API requests. This should be set as a `GITHUB_ACCESS_TOKEN` environment variable as configured in [config/secrets.yml](https://github.com/github/github-graphql-rails-example/blob/master/config/secrets.yml).
