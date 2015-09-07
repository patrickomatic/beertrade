class TradesController < ApplicationController
  def new
    @trade = Trade.new
  end


  def index
    @trades = Trade.order(created_at: :desc).page(params[:page])
  end 


  def show
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


  def update
    # TODO shipping support and updating feedback
  end


  def destroy 
    @trade = Trade.find(params[:id])

    render status: 404 unless @trade.can_delete?(current_user)

    @trade.destroy

    flash[:success] = "Trade cancelled"
    redirect_to user_path(current_user)
  end


  private

    def trade_params
      params.require(:trade).permit(:agreement)
    end
end
