class UsersController < ApplicationController
  def show
    @user = User.find_by_username(params[:id])
    raise ActiveRecord::RecordNotFound unless @user

    if @user == current_user || current_user.try(:moderator?)
      @pending = @user.trades.not_completed_yet.page(params[:pending_page])
    end

    @completed = @user.trades.completed.page(params[:completed_page])

    @notifications = (current_user == @user) ? @user.notifications.unseen.page(params[:notification_page]) : []
  end


  def index
    if params[:username_q]
      if @searched_for = User.find_by_username(params[:username_q])
        return redirect_to(@searched_for)
      else
        flash[:alert] = "user not found: #{params[:username_q]}"
      end
    end

    @users = User.top_traders.page(params[:page])
  end


  def create
    return render_forbidden! unless current_user.moderator?

    old_user = User.find_by_username(user_params[:username])

    if old_user && new_user = User.find_or_create_by_username(user_params[:new_username])
      UsernameChangeJob.perform_later(old_user.id, new_user.id)
      flash[:notice] = "adding trades from #{old_user} to #{new_user}, this may take a while..."
      redirect_to user_path(new_user)
    else
      flash[:error] = "user not found: #{user_params[:username]}"
      redirect_to moderators_path
    end
  end


  private

    def user_params
      params.require(:user).permit(:username, :new_username)
    end
end
