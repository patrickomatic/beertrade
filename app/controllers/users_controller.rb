class UsersController < ApplicationController
  def show
    @user = User.find_by(username: params[:id])
  end

  def index
    @users = User.by_feedback.page(params[:page])
  end
end
