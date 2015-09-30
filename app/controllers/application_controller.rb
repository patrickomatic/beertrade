class ApplicationController < ActionController::Base
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
    return if current_user

    session[:last_page] = request.original_url
    flash[:alert] = "You need to log in to access that page"
    redirect_to new_session_path
  end


  def render_forbidden!
    render status: :forbidden, body: :nothing
  end

  helper_method :current_user
end
