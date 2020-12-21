module AuthHelper
	
	# Logs in the given user.
	def log_in(user)
    session[:user_id] = user.id
    user = User.find(session[:user_id])  
    User.current = user  
  end

  # Returns the current logged-in user (if any).
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
	end
	
	# Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
	end
	
	def log_out
		session.delete(:user_id)
	end
end
