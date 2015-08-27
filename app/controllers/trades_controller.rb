class TradesController < ApplicationController
  def new
    @trade = Trade.new
  end


  def create
    @trade = Trade.new(trade_params)
    @trade.participants.build(user: current_user)
    @trade.participants.build(user: User.find_or_create_by(username: params[:participant_username]))

    if @trade.save
      # XXX send message
      redirect_to @trade
    else
      render 'new'
    end
  end


  def edit
    @trade = Trade.find(params[:id])
  end

  def update
  end


  private

    def trade_params
      params.require(:trade).permit(:agreement)
    end
end
