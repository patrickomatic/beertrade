class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  def current_user
    User.find(session[:user_id]) rescue nil
  end

  def log_in_user(user)
    session[:user_id] = user.id
  end

  def log_out_user
    session.delete(:user_id)
  end

  def requires_authentication!
    session[:last_page] = request.original_url
    flash[:alert] = "You need to log in to access that page"
    redirect_to new_session_path
  end

  helper_method :current_user
end
