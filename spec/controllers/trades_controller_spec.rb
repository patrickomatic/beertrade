require 'rails_helper'

RSpec.describe TradesController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }


  describe "GET new" do
    before do
      log_in_as user
      get :new
    end

    it "assigns @trade" do
      expect(assigns[:trade]).to be_a Trade
    end
  end


  describe "GET index" do
    before do
      FactoryGirl.create(:trade, :completed)
      get :index
    end

    it "assigns @trades" do
      expect(assigns[:trades]).not_to be_empty
    end
  end


  describe "GET show" do
    context "with a completed trade" do
      let(:trade) { FactoryGirl.create(:trade, :completed) }

      before { get :show, id: trade.id }

      it "should be a success" do
        expect(response).to be_success
      end

      it "should assign @trade" do
        expect(assigns[:trade]).to eq trade
      end
    end

    context "with a notification_id param" do
      let(:notification) { FactoryGirl.create(:notification) }
      let(:trade) { notification.trade }

      before do
        log_in_as notification.user
        get :show, id: trade.id, notification_id: notification.id
      end

      it "should mark the notification as seen" do
        notification.reload
        expect(notification).to be_seen
      end
    end

    context "when waiting for approval" do
      let(:trade) { FactoryGirl.create(:trade, :waiting_for_approval) }

      context "not logged in" do
        before { get :show, id: trade.id }

        it "should be a redirect response" do
          expect(response).to redirect_to(new_session_path)
        end
      end

      context "and logged in" do
        let(:user) { FactoryGirl.create(:user) }

        before do
          log_in_as user
          get :show, id: trade.id
        end

        context "as not the approver" do
          it "should not be a success" do
            expect(response).to be_forbidden
          end
        end

        context "as the approver" do
          let(:user) { trade.participants.first.user }

          it "should be a success" do
            expect(response).to be_success
          end
        end

        context "as the requester" do
          let(:user) { trade.participants.second.user }

          it "should be a success" do
            expect(response).to be_success
          end
        end
      end
    end
  end


  describe "POST create" do
    let(:user) { FactoryGirl.create(:user) }

    before do
      expect(TradeInviteJob).to receive(:perform_later)
      log_in_as user
      post :create, participant_username: "beertrade", trade: {agreement: "yinlinz"}
    end


    it "should set flash[:notice]" do
      expect(flash[:notice]).not_to be_nil
    end

    it "should redirect to user_path" do
      expect(response).to redirect_to(user_path(user))
    end


    context "when requesting a trade with yourself" do
      before do
        log_in_as user
        post :create, participant_username: user.username, trade: {agreement: "yinlinz"}
      end

      it "should set flash[:alert]" do
        expect(flash[:alert]).not_to be_nil
      end

      it "should render :new" do
        expect(response).to render_template(:new)
      end
    end
  end


  describe "DELETE destroy" do
    let(:trade) { FactoryGirl.create(:trade, :waiting_for_approval) }

    before do
      log_in_as user
      delete :destroy, id: trade.id
    end


    context "as the approver" do
      let(:user) { trade.participants.first.user }

      it "should redirect to user_path" do
        expect(response).to redirect_to(user_path(user))
      end

      it "should set flash[:notice]" do
        expect(flash[:notice]).not_to be nil
      end
    end

    context "as the requester" do
      let(:user) { trade.participants.second.user }

      it "should be forbidden" do
        expect(response).to be_forbidden
      end
    end
  end

  describe 'GET search' do
    let(:trade) { FactoryGirl.create(:trade, :completed) }
    let(:user) { FactoryGirl.create(:user) }

    context "as a logged in user" do
      before do
        log_in_as user
        get :search, query: 'pliny'
      end

      it "should be a success" do
        expect(response).to be_success
      end

      it "should assign @trade" do
        expect(assigns[:results]).to eq [trade]
      end
    end

    context "as a not logged in user" do
      before { get :search, query: 'pliny' }

      it "should be a redirect response" do
        expect(response).to redirect_to(new_session_path)
      end
    end
  end
end
