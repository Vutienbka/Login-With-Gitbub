require 'http'

class AuthController < ApplicationController
	
	def index
		session[:github_auth_state] = ""
	end
	
	def login
		session[:github_auth_state] = SecureRandom.alphanumeric(10)
		github = ENV['GITHUB_LOGIN_URL'] +
			"client_id=" + ENV['GITHUB_CLIENT_ID'] +
			"&redirect_uri=" + ENV['GITHUB_REDIRECT_URL'] +
			"&scope=user&state=" + session[:github_auth_state]

			redirect_to github
	end

	def logout	
		log_out
		flash[:notice] = "You have successfully logged out."

		redirect_to root_path
	end

	def callback
		
		state = params[:state]
		if state === session[:github_auth_state]
			response = request_access_token(ENV['GITHUB_ACCESS_TOKEN_URL'], {
				:client_id => ENV['GITHUB_CLIENT_ID'],
				:client_secret => ENV['GITHUB_CLIENT_SECRET'],
				:code => params[:code],
				:redirect_uri => ENV['GITHUB_REDIRECT_URL'],
				:state => session[:github_auth_state]
			})

			if response.code === 200
				access_token = response.parse['access_token']
				github_user_response = request_user_info(ENV['GITHUB_USER_URL'], access_token)

				if github_user_response.code === 200	
					github_user = github_user_response.parse
					user = User.find_by(uid: github_user['id'])
					if (!user)
						user = User.create(
							username: github_user['login'],
							email: github_user['email'],
							uid: github_user['id'],
							provider: 'github',
							token: access_token,
							avartar: github_user['avatar_url'].to_s
						)
						ENV["GITHUB_ACCSESS_TOKEN"] = user.token
					else
						user.token = access_token
						user.avartar = github_user['avatar_url'].to_s
						user.email = github_user['email'].to_s
						ENV["GITHUB_ACCSESS_TOKEN"] = access_token
						user.save
					end

					# session[:current_user_id] = user.id
					log_in(user)
					session[:github_auth_state] = ""
					flash[:notice] = "You have successfully logged in."
				end
			else
				flash[:danger] = "Failed attempt!"
			end
		else
			flash[:danger] = "Failed attempt!"
		end
		@current_user ||= User.find_by(id: session[:user_id])
		session[:current_user] = @current_user

		redirect_to repository_list_path
	end

	def user_profile
		@user = current_user
	end	

	private

	def request_access_token(url, params)
		HTTP.headers(:accept => 'application/json')
				.post(url, :json => params)
	end

  def request_user_info(url, token)
		HTTP.auth('token ' + token)
			.get(url)
	end

end
