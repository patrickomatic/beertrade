class SessionsController < ApplicationController
  def new
  end

  def create
    user = find_or_create_user(auth_hash.uid, auth_hash.info.name)

    session[:user_id] = user.id
    redirect_to user_path(user)
  end

  def delete
    session.delete(:user_id)
  end


  private

    def find_or_create_user(uid, username)
      unless user = User.find_by(auth_uid: auth_hash.uid) 
        if user = User.find_by_username(auth_hash.info.name)
          user.update_attributes(auth_uid: auth_hash.uid, username: auth_hash.info.name)
        else
          user = User.create(auth_uid: auth_hash.uid, username: auth_hash.info.name)
        end
      end

      user
    end

    def auth_hash
      request.env['omniauth.auth']
    end
end
