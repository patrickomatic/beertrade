class ParticipantsController < ApplicationController
  before_filter :requires_authentication!
   

  def create
    @trade = Trade.find(params[:trade_id])

    render_forbidden! and return unless @trade.waiting_for_approval?(current_user)

    @participant = @trade.participants.not_yet_accepted.find_by(user_id: current_user.id)
    
    if !@participant.update_attributes(accepted_at: Time.now)
      flash[:alert] = @participant.errors.full_messsaes.join(", ")
    else
      flash[:notice] = "successfully confirmed trade"
    end

    redirect_to trade_path(@trade)
  end


  def edit
    @participant = Participant.find(params[:id])

    render_forbidden! unless @participant || current_user.moderator?
  end


  def update
    @participant = Participant.find(params[:id])

    return render_forbidden! unless @participant.can_see?(current_user)

    if @participant.user == current_user 
      update_shipping_info
    else
      update_feedback
    end
  end


  private

    def update_shipping_info
      return render_forbidden! unless @participant.can_update_shipping_info?(current_user)

      if @participant.update_attributes(update_shipping_info_params)
        flash[:notice] = "successfully updated shipping info"
        redirect_to @participant.trade
      else 
        flash[:alert] = "tracking number is invalid"
        render :edit
      end
    end

    def update_feedback
      return render_forbidden! unless @participant.can_update_feedback?(current_user)

      @participant.moderator_approved_at = Time.now if current_user.moderator?

      if @participant.update_attributes(update_feedback_params)
        flash[:notice] = "successfully left feedback"
        redirect_to @participant.trade
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
