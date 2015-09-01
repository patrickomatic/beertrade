class UsersController < ApplicationController
  def show
    @user = User.find_by(username: params[:id])
    @pending_trades = nil # TODO
    @completed_trades = nil # TODO
  end

  def index
    @users = User.by_feedback.page(params[:page])
  end
end
