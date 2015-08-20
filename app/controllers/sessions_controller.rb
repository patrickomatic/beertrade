class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(auth_uid: auth_hash.uid)
    unless user
      user = User.create(auth_uid: auth_hash.uid, username: auth_hash.info.name)
    end

    session[:user_id] = user.id
    redirect_to user_path(user)
  end

  def delete
    session.delete(:user_id)
  end


  private
    def auth_hash
      request.env['omniauth.auth']
    end
end
