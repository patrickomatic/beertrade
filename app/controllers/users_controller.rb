class UsersController < ApplicationController
  def show
    @user = User.find_by(username: params[:id])

    @pending = @user.trades.not_completed_yet.page(params[:pending_page])

    @completed = if @feedback_filter = feedback_filter_param
                   @user.trades.completed.with_feedback(@feedback_filter).page(params[:completed_page])
                 else
                   @user.trades.completed.page(params[:completed_page])
                 end

    @notifications = if current_user == @user
                       @user.notifications.page(params[:notification_page])
                     else
                       []
                     end
  end


  def index
    @users = User.by_feedback.page(params[:page])
  end


  private

    def feedback_filter_param
      if %w(positive neutral negative).include? params[:feedback].to_s
        params[:feedback].to_sym
      else
        nil
      end
    end
end
