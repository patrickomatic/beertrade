class SessionsController < ApplicationController

  def new
    @last_completed = Trade.completed.order(created_at: :desc).page(params[:page])
  end


  def create
    user = User.find_from_auth_hash(auth_hash)

    log_in_user(user)

    if last_page = session.delete(:last_page)
      redirect_to last_page
    else
      redirect_to user_path(user)
    end
  end


  def destroy
    log_out_user
    redirect_to root_path
  end


  private

    def auth_hash
      request.env['omniauth.auth']
    end
end
