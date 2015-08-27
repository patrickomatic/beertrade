require 'rails_helper'

RSpec.describe "Trades", type: :request do
  describe "GET /trades" do
    it "works! (now write some real specs)" do
      get trades_path
      expect(response).to have_http_status(200)
    end
  end
end
