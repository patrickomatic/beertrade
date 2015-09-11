require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  controller do 
    def index; end
  end

  describe "#current_user" do
    let(:user) { FactoryGirl.create(:user) }

    subject { controller.current_user }

    it { is_expected.to be nil }

    context "with session[:user_id] set" do
      before { controller.session[:user_id] = user.id }
      it { is_expected.to eq user }
    end
  end


  describe "#log_in_user" do
    let(:user) { FactoryGirl.create(:user) }

    before { controller.log_in_user(user) }

    it "should set the session" do
      expect(controller.session[:user_id]).to eq(user.id)
    end
  end


  describe "#log_out_user" do
    before do 
      controller.session[:user_id] = 1
      controller.log_out_user 
    end

    it "should delete session[:user_id]" do
      expect(controller.session[:user_id]).to be_nil
    end
  end


  describe "#requires_authentication!" do
    before do 
      expect(controller).to receive(:render).and_return(true)
      get :index

      controller.requires_authentication! 
    end

    it "should set a notice" do
      expect(controller.flash[:alert]).not_to be_nil
    end

    it "should save the last page" do
      expect(controller.session[:last_page]).to eq "http://test.host/anonymous"
    end
  end
end
