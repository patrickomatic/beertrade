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

    if !@trade.accepted?
      if !current_user
        requires_authentication!
      elsif !@trade.waiting_for_approval?(current_user)
        render_forbidden!
      end
    end
  end


  def create
    @trade = Trade.new(trade_params)

    username = params[:participant_username]
    if @trade.create_participants(current_user, username)
      flash[:notice] = "trade successfully requested.  Waiting on /u/#{username} to confirm it"
      redirect_to current_user
    else
      flash[:alert] = @trade.errors.full_messages.first
      render :new
    end
  end


  def destroy 
    @trade = Trade.find(params[:id])

    unless @trade.can_delete?(current_user)
      render_forbidden! and return
    end

    @trade.destroy

    flash[:notice] = "trade cancelled"
    redirect_to user_path(current_user)
  end


  private

    def trade_params
      params.require(:trade).permit(:agreement)
    end
end
