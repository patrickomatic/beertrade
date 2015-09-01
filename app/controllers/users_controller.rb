class UsersController < ApplicationController
  def show
    @user = User.find_by(username: params[:id])
    @pending = @user.participants.pending.page(params[:pending_page])
    @completed = @user.participants.completed.page(params[:completed_page])
  end


  def index
    @users = User.by_feedback.page(params[:page])
  end
end
