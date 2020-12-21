# Login with Github

1. Firstly, login with your github account 
2. Visit page  https://github.com/settings/developers and Click [ Register a new application ] to start create a [Github OAuth App]
image link: https://gyazo.com/efeb7a148ae06f64029b66689e6f7c38
3. Click [New OAuthApp] button and you can see this page
image link: https://gyazo.com/9bdb0e43a1ef4f0564b629c39f1a1104
4. Insert info like under image
image link: https://gyazo.com/c612e6437ea2e9f04affbd7d40c66d8d
5. You can get Client ID and generate secret key in this page
image link: https://gyazo.com/87582ce09edbacaf1b7520046cd6f4da

6. # .env config
.env file has to contain next vars
you'll need a [GitHub API access token] to make GraphQL API requests. This should be set as a `GITHUB_ACCESS_TOKEN` environment variable as configured in [config/secrets.yml]
```
HOSTNAME=localhost
APP_URL=http://localhost:3000
GITHUB_LOGIN_URL=https://github.com/login/oauth/authorize?
GITHUB_CLIENT_ID= your_ClientID you get at step 5 (for example this is my test clientID: '7947909fcdc1dc5da57e' )
GITHUB_CLIENT_SECRET= your secret_key you generate at step 5 (for example this is my test secret_key: '502e9f93393133efb3a23108bd8bef8539c4e5b8' )
GITHUB_REDIRECT_URL=${APP_URL}/auth/github/callback
GITHUB_ACCESS_TOKEN_URL=https://github.com/login/oauth/access_token
GITHUB_USER_URL=https://api.github.com/user
```

7. Follow the next steps after clonning this repo:
repo link: https://github.com/Vutienbka/Login-With-Gitbub
  - Run `bundle install` on the terminal to install dependencies
  - Insert Client ID and Client Secret into `.env` file
  - Run `rails db:create` and `rails db:migrate` to create local database
  - Run `rails s` to start the application

# What was done
I have added next routes:
- `/` for displaying link to login with Github
- `/auth/github` redirects a user to request identity
- `/auth/github/callback` Github redirects back to this URL
- `/logout` to logout a user
- `/user_profile` to see current user's profile

I added [auth_controller] with following actions to handle routes.
- [index] shows a page with link to Github Auth
- [login] redirects to Github with needed params
- [callback] handles response from Github. It will request `access_token` from Github. Further, with `access_token` will be requesting user info that will be stored (if doesn't exist) on the database and session
- in the [logout] action will be removed user id from session, so will redirect to root url with flash message
- in the [user_profile] to see profile of current user
- 
- [app/controller/repositories_controller.rb] -> defines the top level GraphQL queries to fetch repository list and show pages.
- [app/views/repositories/index.html.erb] -> shows the root template's listing query and composition over subviews.
- [app/views/repositories/_repositories.html.erb] -> makes use of GraphQL connections to show the first couple items and a "load more" button.
- [app/views/repositories/show.html.erb]-> shows the root template for the repository show page.
- [app/views/repositories/stargazers.html.erb]-> shows the template for the stargazers show page.
- [app/controller/stargazers.rb] -> defines controller helpers for executing GraphQL query requests.
- [app/views/repositories/issues.html.erb]-> shows the template for the issues show page.
- [app/controller/issues.rb] -> defines controller helpers for executing GraphQL query requests.
- [app/views/repositories/user_profile.html.erb]-> shows the template for the current_user's profile page.
- [app/controller/issues.rb] -> defines controller helpers for executing get user's information from database.

- [app/controller/application_controller.rb] -> defines controller helpers for executing GraphQL query requests.
- [config/application.rb] -> configures `GraphQL::Client` to point to the GitHub GraphQL endpoint.

Demonstrates how to use the [`graphql-client`] -> (http://github.com/github/graphql-client) gem to build a simple repository listing web view against the [GitHub GraphQL API] -> (https://developer.github.com/v4/guides/intro-to-graphql/).


 