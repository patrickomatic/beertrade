require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { FactoryGirl.create(:user, :with_trades) }

  describe "GET show" do
    before { get :show, id: user.username, format: format }

    context "as html" do
      let(:format) { :html }

      it "assigns @user" do
        expect(assigns[:user]).to eq user
      end

      it "assigns @pending" do
        expect(assigns[:pending]).to be_nil
      end

      it "assigns @completed" do
        expect(assigns[:completed]).not_to be_nil
      end

      it "assigns @notifications" do
        expect(assigns[:notifications]).not_to be_nil
      end


      context "as the logged in user" do
        before do
          log_in_as(user) 
          get :show, id: user
        end

        it "assigns @pending" do
          expect(assigns[:pending]).not_to be_nil
        end
      end
    end


    context "as json" do
      let(:format) { :json }

      specify { expect(response).to be_success }
    end
  end


  describe "GET index" do
    let(:params) { {} }
    before { get :index, params }

    it "assigns @users" do
      expect(assigns[:users]).to include(user)
    end


    context "with a username_q param" do
      let(:user) { FactoryGirl.create(:user) }
      let(:params) { {username_q: user.username} }

      before { get :index, params }


      specify { expect(response).to redirect_to(user_path(user)) }

      context "with non-existant user" do
        let(:params) { {username_q: "foo"} }
        specify { expect(flash[:alert]).not_to be_nil }
      end
    end
  end


  describe "POST create" do
    # XXX 
    pending
  end
end
