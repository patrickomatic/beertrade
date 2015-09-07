class ParticipantsController < ApplicationController
  def create
    @trade = Trade.find(params[:trade_id])
    @participant = @trade.participants.not_yet_accepted.where(user: current_user).first
    
    if !@participant.update_attributes(accepted_at: Time.now)
      flash[:error] = @participant.errors
    end

    redirect_to trade_path(@trade)
  end


  def edit
    @trade = Trade.find(params[:trade_id])
    @participant = @trade.participants.find!(params[:id])
  end


  def update
    @trade = Trade.find(params[:trade_id])
    @participant = @trade.participants.find!(params[:id])

    if @participant.update_attributes(params)
    else 
      flash[:error] = "Error updating shipping info"
      redirect_to edit_trade_participant_path(@participant)
    end
  end


  private

    def update_params
      params.require(:participant).permit(:shipping_info)
    end
end
