require 'rails_helper'

describe ParticipantsController, type: :controller do 
  describe "POST create" do
    let(:trade) { FactoryGirl.create(:trade, :waiting_for_approval) }

    before do
      log_in_as approving_user
      post :create, trade_id: trade
    end


    context "with the user that needs to approve it" do
      let(:approving_user) { trade.participants.first.user }

      it "should set flash[:notice]" do
        expect(flash[:notice]).not_to be_nil
      end

      it "should redirect to the trade" do
        expect(response).to redirect_to(trade)
      end
    end

    context "with a non-participating user" do
      let(:approving_user) { FactoryGirl.create(:user) }

      it "should be forbidden" do
        expect(response).to be_forbidden
      end
    end

    context "with the requesting user" do
      let(:approving_user) { trade.participants.second.user }

      it "should be forbidden" do
        expect(response).to be_forbidden
      end
    end
  end


  describe "GET edit" do
    let(:trade) { FactoryGirl.create(:trade, :accepted) }
    let(:participant) { trade.participants.first }

    let(:get_edit) do
      log_in_as participant.user
      get :edit, trade_id: trade, id: participant
    end


    context "as a participant" do
      it "should render :edit" do
        get_edit
        expect(response).to render_template(:edit)
      end
    end

    context "as a non-participant" do
      let(:participant) { FactoryGirl.create(:participant) }

      it "should be a 404" do
        expect { get_edit }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end


  describe "PATCH update" do
    let(:trade) { FactoryGirl.create(:trade, :accepted) }

    before do
      log_in_as current_user
      patch :update, trade_id: trade, id: participant, participant: params
    end


    context "updating shipping info" do
      let(:participant) { trade.participants.first }
      let(:current_user) { participant.user }
      let(:params) { {shpping_info: "774397776602"} }

      it "should redirect to the trade" do
        expect(response).to redirect_to(trade)
      end

      it "should set flash[:notice]" do
        expect(flash[:notice]).not_to be_nil
      end


      context "as non-participant" do
        let(:current_user) { FactoryGirl.create(:user) }

        it "should be forbidden" do
          expect(response).to be_forbidden
        end
      end
    end

    context "updating feedback" do
      let(:participant) { trade.participants.first }
      let(:current_user) { participant.other_participant.user }
      let(:params) { {feedback: "great trade", feedback_type: "positive"} }

      it "should redirect to the trade" do
        expect(response).to redirect_to(trade)
      end

      it "should set flash[:notice]" do
        expect(flash[:notice]).not_to be_nil
      end


      context "as non-participant" do
        let(:current_user) { FactoryGirl.create(:user) }

        it "should be forbidden" do
          expect(response).to be_forbidden
        end
      end
    end
  end
end
