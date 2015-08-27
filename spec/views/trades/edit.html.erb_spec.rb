require 'rails_helper'

RSpec.describe "trades/edit", type: :view do
  before(:each) do
    @trade = assign(:trade, Trade.create!())
  end

  it "renders the edit trade form" do
    render

    assert_select "form[action=?][method=?]", trade_path(@trade), "post" do
    end
  end
end
