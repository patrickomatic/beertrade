require 'moderator_tools'

class TradesController < ApplicationController
  before_filter :requires_authentication!, except: [:index, :show]


  def new
    @trade = Trade.new
  end


  def index
    @trades = Trade.completed
    @trades = @trades.basic_search(agreement: params[:q]) unless params[:q].blank?
    @trades = @trades.order(created_at: :desc).page(params[:page])
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
    return add_trade if current_user.moderator? && params[:user] and params[:other_user]

    @trade = Trade.new(trade_params)

    username = params[:participant_username].strip
    if new_participant = @trade.create_participants(current_user, username, request.remote_ip)
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

    def user_params
      params.require(:user).permit(:username)
    end

    def other_user_params
      params.require(:other_user).permit(:username)
    end

    def participant_params
      params.require(:participant).permit(:feedback_type, :feedback)
    end

    def other_participant_params
      params.require(:other_participant).permit(:feedback_type, :feedback)
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


    def add_trade
      user = User.find_or_create_by_username(user_params[:username])
      other_user = User.find_or_create_by_username(other_user_params[:username])

      trade = Trade.new(trade_params)
      trade.participants.build(participant_params.merge(user: user))
      trade.participants.build(other_participant_params.merge(user: other_user))
      trade.participants.each {|p| p.accepted_at = p.moderator_approved_at = Time.now}
      trade.completed_at = Time.now

      if trade.save
        flash[:notice] = "successfully added trade"
        redirect_to trade
      else
        flash[:alert] = "error adding trade"
        redirect_to moderator_add_trade_path
      end
    end
end
