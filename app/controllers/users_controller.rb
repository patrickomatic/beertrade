class UsersController < ApplicationController
  def show
    @user = User.find_by(username: params[:id])
    @pending = Trade.with_user(@user).not_completed_yet.page(params[:pending_page])
    @completed = Trade.with_user(@user).completed.page(params[:completed_page])
    @notifications = Notification.for_user(@user).page(params[:notification_page])
  end


  def index
    @users = User.by_feedback.page(params[:page])
  end
end
