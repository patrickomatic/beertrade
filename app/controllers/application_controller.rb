class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception


  rescue_from ActiveRecord::RecordNotFound do |exception|
    render_not_found!
  end


  def current_user
    User.find(session[:user_id]) rescue nil
  end


  def log_in_user(user)
    session[:user_id] = user.id
    CheckIfModeratorJob.perform_later(user.id)
  end

  def log_out_user
    session.delete(:user_id)
  end


  def requires_authentication!
    return if current_user

    session[:last_page] = request.original_url
    flash[:alert] = "you need to log in to access that page"
    redirect_to new_session_path
  end


  def render_not_found!
    render status: :not_found, text: "the page you are requesting could not be found"
  end

  def render_forbidden!
    render status: :forbidden, text: "you do not have access to this page"
  end

  helper_method :current_user
end
