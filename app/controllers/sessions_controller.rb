class SessionsController < ApplicationController
  def new
    @last_completed = Trade.completed.order(created_at: :desc).page(params[:page])
  end


  def create
    user = find_or_create_user(auth_hash.uid, auth_hash.info.name)

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

    def find_or_create_user(uid, username)
      unless user = User.find_by(auth_uid: auth_hash.uid) 
        if user = User.find_by_username(auth_hash.info.name)
          user.update_attributes(auth_uid: auth_hash.uid, username: auth_hash.info.name)
        else
          user = User.create(auth_uid: auth_hash.uid, username: auth_hash.info.name)
        end
      end

      CheckIfModeratorJob.perform_later(user.id)

      user
    end

    def auth_hash
      request.env['omniauth.auth']
    end
end
