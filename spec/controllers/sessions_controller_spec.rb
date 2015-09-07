require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe "GET new" do
    before { get :new }

    it "assigns @last_completed" do
      expect(assigns[:last_completed]).not_to be_nil
    end
  end

  describe "POST create" do
  end

  describe "DELETE destroy" do
  end
end
