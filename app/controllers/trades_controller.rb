class TradesController < ApplicationController
  def new
    @trade = Trade.new
  end


  def index
    @trades = Trade.order(created_at: :desc).page(params[:page])
  end 


  def show
    if !@trade.accepted?
      if !current_user
        return requires_authentication!
      elsif !@trade.waiting_for_approval?(current_user)
        render status: :forbidden and return
      end
    end

    @trade = Trade.find(params[:id])
  end


  def create
    @trade = Trade.new(trade_params)

    if @trade.create_participants(current_user, params[:participant_username])
      redirect_to @trade
    else
      render 'new'
    end
  end


  def edit
    @trade = Trade.find(params[:id])
  end


  def destroy 
    @trade = Trade.find(params[:id])

    unless @trade.can_delete?(current_user)
      render status: :not_found and return
    end

    @trade.destroy

    flash[:notice] = "Trade cancelled"
    redirect_to user_path(current_user)
  end


  private

    def trade_params
      params.require(:trade).permit(:agreement)
    end
end
