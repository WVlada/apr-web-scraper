module SessionsHelper
    
  
    # Logs in the given user.
  def log_in(user)
    session[:user_email] = user.email
  end
  
  def current_user
    @current_user ||= User.find_by(email: session[:user_email])
  end
  
   # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end
  
  def log_out
    session.delete(:user_email)
    @current_user = nil
  end
end
