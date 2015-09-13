class ParticipantsController < ApplicationController
  def create
    @trade = Trade.find(params[:trade_id])
    @participant = @trade.participants.not_yet_accepted.where(user: current_user).first

    render :forbidden and return unless @participant
    
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

    # XXX trigger messages to other_participant
    # XXX do we need any security checks?
    if @participant.user == current_user 
      update_shipping_info
    else
      update_feedback
    end
  end


  private

    def update_shipping_info
      if @participant.update_attributes(update_shipping_info_params)
        flash[:notice] = "successfully updated shipping info"
        redirect_to @trade
      else 
        flash[:alert] = "tracking number is invalid"
        render :edit
      end
    end

    def update_feedback
      if @participant.update_attributes(update_feedback_params)
        flash[:notice] = "successfully left feedback"
        redirect_to @trade
      else 
        flash[:alert] = "must complete all fields"
        render :edit
      end
    end

    def update_shipping_info_params
      params.require(:participant).permit(:shipping_info)
    end

    def update_feedback_params
      params.require(:participant).permit(:feedback, :feedback_type)
    end
end
