class UsersController < ApplicationController
  def show
    @user = User.find_by(username: params[:id])
    @pending = Trade.with_user(@user).pending.page(params[:pending_page])
    @completed = Trade.with_user(@user).completed.page(params[:completed_page])
  end


  def index
    @users = User.by_feedback.page(params[:page])
  end
end
