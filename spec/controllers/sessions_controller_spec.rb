require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe "GET new" do
    before { get :new }

    it "is a success" do
      expect(response).to be_success
    end

    it "sets a flash alert message" do
      expect(flash.now[:alert]).to_not be_nil
    end
  end


  describe "GET create" do
    let(:user) { FactoryGirl.create(:user) }
    let(:auth_uid) { user.id }
    let(:username) { user.username }

    before do
      request.env['omniauth.auth'] = OmniAuth.config.add_mock(:identity, {
        uid: auth_uid,
        info: {name: username},
      })
    end


    context "with existing user" do
      before { get :create, provider: "reddit" }

      it "sets session[:user_id]" do
        expect(session[:user_id]).to eq user.id
      end

      it "redirects to the user page" do
        expect(response).to redirect_to(user_path(user))
      end
    end


    context "with session[:last_page] set" do
      before do
        controller.session[:last_page] = "/foo"
        get :create, provider: "reddit"
      end


      it "redirects to the user page" do
        expect(response).to redirect_to("/foo")
      end

      it "deletes session[:last_page]" do
        expect(controller.session[:last_page]).to be nil
      end
    end


    context "first time logging in " do
      let(:auth_uid) { "asdf" }
      let(:username) { "asdf" }


      it "should create a user" do
        expect { get :create, provider: "reddit" }.to change { User.count }.by 1
      end
    end
  end


  describe "DELETE destroy" do
    let(:user) { FactoryGirl.create(:user) }

    before { delete :destroy, id: user.id }

    specify { expect(response).to redirect_to(root_path) }
    specify { expect(controller.session).to be_empty }
  end
end
