require 'moderator_tools'

class TradesController < ApplicationController
  before_filter :requires_authentication!, except: [:index, :show]


  def new
    @trade = Trade.new
  end


  def index
    @trades = Trade.order(created_at: :desc).page(params[:page])
  end 


  def show
    @trade = Trade.find(params[:id])

    if params[:notification_id]
      n = @trade.notifications.find_by(id: params[:notification_id])
      n.mark_as_seen! if n.user == current_user
    end

    if !@trade.can_see?(current_user) 
      if current_user
        render_forbidden! 
      else
        requires_authentication!
      end
    end
  end


  def create
    return trade_import if current_user.moderator? && params[:users_to_import]

    @trade = Trade.new(trade_params)

    username = params[:participant_username].strip
    if new_participant = @trade.create_participants(current_user, username)
      TradeInviteJob.perform_later(new_participant.id)

      flash[:notice] = "trade successfully requested.  waiting on #{new_participant.user} to confirm it"
      redirect_to current_user
    else
      flash[:alert] = @trade.errors.full_messages.first
      render :new
    end
  end


  def destroy 
    @trade = Trade.find(params[:id])

    return render_forbidden! unless @trade.can_delete?(current_user)

    @trade.destroy

    flash[:notice] = "trade cancelled"
    redirect_to user_path(current_user)
  end


  private

    def trade_params
      params.require(:trade).permit(:agreement)
    end

    def trade_import
      user = User.find_by_username(params[:participant_username])

      if !user
        flash[:alert] = "user not found"
      elsif ModeratorTools.import_trades_for_user(user, params[:users_to_import])
        flash[:notice] = "successfully imported trades"
      else
        flash[:alert] = "error importing trades"
      end

      redirect_to moderators_path
    end
end
