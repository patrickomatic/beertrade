require 'rails_helper'

RSpec.describe "trades/index", type: :view do
  before(:each) do
    assign(:trades, [
           FactoryGirl.create(:trade),
           FactoryGirl.create(:trade)
    ])
  end

  it "renders a list of trades" do
    render
  end
end
