class UsersController < ApplicationController
  def show
    @user           = User.find_by!(username: params[:id])
    @pending        = @user.trades.not_completed_yet.page(params[:pending_page])
    @completed      = @user.trades.completed.page(params[:completed_page])

    @notifications = if current_user == @user
                       @user.notifications.unseen.page(params[:notification_page])
                     else
                       []
                     end
  end


  def index
    @users = User.by_feedback.page(params[:page])
  end
end
