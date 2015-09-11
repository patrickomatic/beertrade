class ParticipantsController < ApplicationController
  def create
    @trade = Trade.find(params[:trade_id])
    @participant = @trade.not_yet_accepted.participant(current_user)
    
    if !@participant.update_attributes(accepted_at: Time.now)
      flash[:alert] = @participant.errors
    else
      flash[:notice] = "Successfully confirmed trade"
    end

    redirect_to trade_path(@trade)
  end


  def edit
    @trade = Trade.find(params[:trade_id])
    @participant = @trade.participants.find_by_id(params[:id])
  end


  def update
    @trade = Trade.find(params[:trade_id])
    @participant = @trade.participants.find_by_id(params[:id])

    params = @participant.user == current_user ? update_shipping_info_params : update_feedback_params

    # XXX trigger messages to other_participant
    if @participant.update_attributes(params)
      flash[:notice] = "Successfully updated trade"
      redirect_to @trade
    else 
      flash[:alert] = "Error updating trade info: you must answer all fields"
      redirect_to edit_trade_participant_path(@trade, @participant)
    end
  end


  private

    def update_shipping_info_params
      params.require(:participant).permit(:shipping_info)
    end

    def update_feedback_params
      params.require(:participant).permit(:feedback, :feedback_type)
    end
end
